# 8.5. How does Kafka handle log cleanup?

Answer: Kafka log cleanup is the process of removing or compacting older log segments according to the topic's cleanup policy. With delete-style retention, Kafka removes old segments when they exceed the configured time or size limits. With compaction, Kafka rewrites segments to remove obsolete values for keys while preserving the latest state and tombstones according to the compaction rules. Cleanup occurs asynchronously; it is not performed for every record at write time. This architecture keeps the hot write path fast. When disk usage grows unexpectedly, I check retention settings, cleanup policy, segment rolling, cleaner activity, partition distribution, and whether one topic is producing much more data than expected.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
