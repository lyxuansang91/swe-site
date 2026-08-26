# 15.4. What is the role of Kafka’s `num.replica.fetchers` configuration?

Answer: num.replica.fetchers controls the number of replica fetcher threads a broker uses to fetch data for follower replicas. More fetchers can increase replication parallelism, especially on larger or busy clusters, but they also consume CPU, network, and other resources. If replication is falling behind because the broker cannot fetch enough partitions concurrently, increasing this setting can help after confirming that the underlying disk and network capacity are sufficient. It is not a universal fix: if the bottleneck is disk I/O or network bandwidth, more threads can simply create more contention. I would change it carefully and monitor ISR recovery time, replication lag, CPU, and network utilization.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
