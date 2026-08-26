# 15.2. What is the role of Kafka’s `replica.fetch.max.bytes` configuration?

Answer: replica.fetch.max.bytes controls the amount of data a follower replica can fetch from the leader in one fetch response. If it is too small relative to the size and rate of partition records, replication can become inefficient and followers may fall behind. If it is extremely large, memory and network bursts can become heavier. I would size it with message sizes, batch sizes, and available broker resources in mind. The goal is to allow followers to fetch enough data efficiently to keep up with leaders. When troubleshooting replication lag, I would also examine disk I/O, network throughput, compression, fetch response sizes, and whether one broker is hosting disproportionately busy partitions.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
