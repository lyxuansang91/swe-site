# 8.10. What is the role of Kafka’s `log.cleaner.threads` configuration?

Answer: log.cleaner.threads controls the number of background log cleaner threads available for log compaction. More cleaner threads can increase compaction throughput on a cluster with many compacted topics, but they also consume CPU and disk I/O. If compaction is falling behind, I would first verify whether the cleaner is actually the bottleneck rather than increasing threads blindly. I would also look at disk throughput, dirty ratio, compaction backlog, and the number and size of compacted partitions. The business goal is to keep compacted topics healthy while avoiding excessive contention with producers and consumers. This is one example where more concurrency is not automatically better because Kafka's disk and CPU resources are shared.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
