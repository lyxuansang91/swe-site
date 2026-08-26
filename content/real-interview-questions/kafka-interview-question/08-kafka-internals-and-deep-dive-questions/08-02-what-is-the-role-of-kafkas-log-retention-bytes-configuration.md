# 8.2. What is the role of Kafka’s `log.retention.bytes` configuration?

Answer: log.retention.bytes puts a size-based upper bound on how much log data is retained. Cleanup removes older segments when the partition or broker-level retention size limit is exceeded, subject to Kafka's cleanup cycle and segment boundaries. This is useful when storage capacity is the primary constraint. Time-based retention and size-based retention can be used together, meaning data may be removed when either policy makes a segment eligible. In production, I calculate expected storage from message rate, average message size, replication factor, and retention rather than choosing the number arbitrarily. I also keep free disk headroom for recovery and rebalancing because running a Kafka broker close to full capacity can create operational risk.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
