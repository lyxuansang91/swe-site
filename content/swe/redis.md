# Redis

***

### 1) Redis Core Architecture (Senior Depth)

#### 1. How does Redis handle single-threaded execution, and why is it still fast?

**Ideal answer** Redis executes commands in a mostly single-threaded event loop, which avoids thread contention and context switching. It’s fast because:

* Data is in-memory (no disk seek per operation).
* Commands are O(1) or near-O(1) for common structures.
* I/O is handled via non-blocking sockets + multiplexing (epoll/kqueue), so many connections can be served efficiently.

**Senior notes**

* “Single-threaded” is primarily the command execution path; some tasks can be multi-threaded in modern Redis (e.g., certain background I/O/persistence), but command semantics remain sequential.

**Follow-ups**

* Redis slows when commands block (big keys, slow Lua, persistence fork latency, network saturation).

***

#### 2. Explain Redis persistence: RDB vs AOF. Which one would you choose in production?

**Ideal answer**

* **RDB (snapshot)**: periodically writes a point-in-time dump. Pros: compact, fast restart. Cons: can lose recent writes (between snapshots), fork can cause latency spikes.
* **AOF (append-only file)**: logs every write. Pros: better durability; with `appendfsync everysec`, typical loss window is \~1s. Cons: larger files, slower restart (replay), rewrite overhead.

**Production choice**

* If I need stronger durability: **AOF everysec** (often with AOF rewrite).
* If I mostly want fast restart and can tolerate some loss: **RDB**.
* Common: **AOF enabled + periodic RDB / hybrid**, depending on ops posture and acceptable loss.

***

#### 3. What happens if Redis crashes during a write?

**Ideal answer** It depends on persistence mode:

* With **AOF**, on restart Redis replays the AOF. If the last command is partially written/corrupted, Redis can truncate/repair (depending on configuration/tools) and load up to the last valid entry—so you may lose the tail.
* With **RDB**, you restore to the last snapshot → data after snapshot is lost.

With `appendfsync everysec`, you may lose up to \~1 second of writes on crash (OS buffers).

***

### 2) Data Structures & Internals

#### 4. When would you choose Redis over a database as a primary store?

**Ideal answer** Only when the data model and durability requirements fit:

* **Ephemeral / TTL-based data**: sessions, OTP, rate limits.
* **Derived / cacheable** data where DB is source of truth.
* **Ultra-low latency** counters/leaderboards where occasional loss is acceptable or mitigated (streaming rebuild).

If the system needs strong durability, complex queries, and strict consistency, Redis should not be the primary store; it should be a cache/accelerator.

***

#### 5. Explain Redis data structures internally: Hash, Sorted Set, List

**Ideal answer**

* **Hash**: optimized for small hashes (compact encoding) and switches to hashtable when it grows. Great for grouping fields by key (user profile, settings).
* **Sorted Set (ZSET)**: typically implemented with a skiplist + hash map for member→score lookup. Great for leaderboards, ranking, time-based ordering.
* **List**: implemented as quicklist-like structure (linked list of compact blocks) to balance memory and speed. Good for queues, feeds (though Streams often better now).

**Senior note** Internal encodings change across versions; what matters in interviews is: Redis uses *space-efficient encodings for small values*, and upgrades to more general structures as it grows.

***

#### 6. How does Redis manage memory? What happens when memory is full?

**Ideal answer** Redis uses an allocator (commonly jemalloc) and supports:

* `maxmemory` to cap memory usage
* eviction policies:
  * `noeviction` (writes fail)
  * `allkeys-lru/lfu`, `volatile-lru/lfu` (only keys with TTL), `random`, `ttl` When memory is full:
* With eviction policy, Redis evicts keys according to the policy.
* With `noeviction`, write commands that increase memory fail.

**Senior angle** Memory fragmentation can be a real issue; monitoring `mem_fragmentation_ratio`, big keys, and allocator behavior matters.

***

### 3) Redis Cluster & High Availability

#### 7. Explain Redis Cluster. What is 16384 slots and why?

**Ideal answer** Redis Cluster partitions the keyspace into **hash slots** (fixed number: **16384**) using a CRC16 hash → slot mapping. Each slot is assigned to a master node; replicas follow that master. Why fixed slots:

* Simplifies rebalancing: move slots between nodes instead of rehashing everything.
* Clients can route requests based on slot metadata and handle MOVED/ASK redirections.

***

#### 8. What happens if a Redis master node goes down?

**Ideal answer** Two common HA setups:

* **Redis Sentinel (non-cluster)**: Sentinels detect failure, elect a leader, promote a replica, and reconfigure clients.
* **Redis Cluster**: cluster nodes detect failure, and if quorum is satisfied, a replica is promoted to master and takes over the slots.

**Senior pitfalls**

* Failover can cause brief unavailability and potential data loss if replication lag exists.
* Split-brain can happen if quorum/partition issues; correctness depends on topology and settings.

***

#### 9. How does Redis handle resharding?

**Ideal answer** In Cluster, resharding is **slot migration**:

* Pick slots to move from source master → target master.
* During migration, clients may get `ASK` redirections; after migration, `MOVED`. Impact:
* Increased latency during migration due to extra hops/redirects.
* Operational complexity: careful planning to avoid hot-slot imbalance.

***

### 4) Distributed Locking (Very Important)

#### 10. How would you implement a distributed lock using Redis?

**Ideal answer** Use a single atomic command:

* Acquire: `SET lock_key unique_value NX PX ttl`
  * `NX` ensures only one owner
  * `PX ttl` ensures auto-expire

Release safely:

* Only the owner should unlock → compare the stored value with your `unique_value`
* Use Lua to check-and-del atomically:
  * If value matches → DEL
  * Else do nothing

**Senior pitfalls**

* TTL too short → lock expires while work still running → two owners
* TTL too long → slow recovery if owner dies
* Always pick unique values (UUID) per lock holder.

***

#### 11. What is Redlock? Do you trust it?

**Ideal answer** Redlock is an algorithm for locks across multiple independent Redis masters (acquire lock in a majority within a time window). Senior stance:

* It improves safety under some failure modes, but **network partitions, clock drift, and GC pauses** can still break assumptions.
* For *money-critical or strict correctness* (e.g., banking ledger), I’d prefer DB constraints/transactions or a consensus system (ZooKeeper/etcd) rather than Redis locking.

***

#### 12. Can Redis locks be used for idempotency?

**Ideal answer** Yes, but lock ≠ idempotency key.

* **Idempotency** is about “same request → same effect/result.”
* A lock only serializes execution; retries after lock expiry can still duplicate effects.

Better pattern:

* Store **idempotency key** with result (or status) in Redis/DB.
* Use `SETNX`/`SET NX PX` to “claim” processing.
* Persist final outcome so retries can return the same response without reprocessing.

***

### 5) Consistency, Transactions & Lua

#### 13. Does Redis support transactions? Are they ACID?

**Ideal answer** Redis has `MULTI/EXEC`:

* Commands queued then executed sequentially.
* It is **atomic** (no interleaving during EXEC), but **not ACID**:
  * No rollback if a command fails at runtime.
  * No isolation like DB levels beyond single-thread sequencing. For conditional updates, use **Lua scripts** or **WATCH** (optimistic concurrency).

***

#### 14. Why and when would you use Lua scripts in Redis?

**Ideal answer** Lua scripts provide:

* **Atomic multi-step operations** (check then set, conditional increments, etc.)
* Fewer round trips → lower latency Use cases:
* Safe unlock
* Rate limiter token bucket
* Compare-and-swap updates

**Risk** Lua runs in the main thread; long scripts block Redis → must keep scripts short and predictable.

***

### 6) Caching Patterns (Real Production)

#### 15. Explain cache-aside vs write-through vs write-behind

**Ideal answer**

* **Cache-aside**: app reads cache; on miss reads DB then populates cache. Writes go to DB then invalidate/update cache.
  * Pros: simple, flexible
  * Cons: stale data risk, stampede on hot miss
* **Write-through**: app writes cache, cache writes DB synchronously.
  * Pros: cache always warm/consistent
  * Cons: added write latency, cache becomes critical path
* **Write-behind**: app writes cache; cache flushes to DB asynchronously.
  * Pros: very fast writes
  * Cons: risk of data loss, complex recovery

***

#### 16. How do you prevent cache stampede?

**Ideal answer** Use one or combine:

* **Mutex / lock on miss**: only one request rebuilds, others wait/fallback.
* **Request coalescing**: collapse concurrent rebuilds.
* **Early refresh / soft TTL**: refresh before expiration in background.
* **Jittered TTL**: avoid synchronized expirations.

***

#### 17. How do you handle cache penetration?

**Ideal answer** Cache penetration = many requests for non-existing keys hitting DB. Mitigations:

* **Cache nulls** (short TTL) for misses
* **Bloom filter** in front
* **Rate limit / WAF** for abusive patterns

***

### 7) Performance & Scalability

#### 18. Why can Redis become slow even if CPU usage is low?

**Ideal answer** Because bottlenecks may be:

* Network saturation (NIC/packet processing)
* Blocking commands on big keys
* Fork/persistence causing latency spikes (copy-on-write overhead)
* Disk I/O during AOF rewrite
* Slow clients / output buffer issues

***

#### 19. What is a “big key” problem? How do you detect and fix it?

**Ideal answer** A big key is a key with very large value or huge collection (big hash/zset/list). Problems:

* Single command takes long time, blocks event loop
* Replication and persistence become heavy
* Memory fragmentation & eviction inefficiency

Detection:

* `SCAN` + `MEMORY USAGE <key>`
* Monitor latency/slowlog Fix:
* Split into multiple keys (sharding by userId:part)
* Use better structures (Streams instead of huge Lists)
* Limit per-key size and enforce via app logic

***

### 8) Security & Ops

#### 20. How do you secure Redis in production?

**Ideal answer**

* Never expose Redis publicly
* Use private network/VPC, security groups/firewall
* Enable **AUTH/ACL** (least privilege)
* Enable **TLS** if crossing untrusted networks
* Disable dangerous commands in shared environments (or restrict via ACL)
* Monitor config drift

***

#### 21. How do you monitor Redis health?

**Ideal answer** Key signals:

* Latency percentiles (p95/p99) and slowlog
* Memory usage, fragmentation ratio
* Evictions and keyspace hits/misses
* Replication lag, number of connected clients
* AOF rewrite status / fork time spikes

Alerting:

* sustained high latency
* evictions increasing unexpectedly
* replication lag growing
* near maxmemory + rising fragmentation

***

### 9) Scenario-Based (Interview Favorite)

#### 22. You use Redis as cache. DB is down. What happens?

**Ideal answer** Cache can keep reads alive **temporarily** if data is already cached. But:

* Cache-aside misses will fail (can’t load from DB). Mitigations:
* Serve stale cache (stale-while-revalidate)
* Circuit breaker: stop DB calls, degrade gracefully
* Fallback default responses for non-critical endpoints
* Pre-warm critical keys / protect hot paths

***

#### 23. Redis is up, but latency spikes randomly. How do you debug?

**Ideal answer** I’d check in order:

1. Redis metrics: `INFO`, latency stats, slowlog
2. Persistenc
