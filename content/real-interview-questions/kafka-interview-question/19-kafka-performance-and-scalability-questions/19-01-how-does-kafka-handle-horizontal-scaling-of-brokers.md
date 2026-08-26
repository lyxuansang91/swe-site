# 19.1. How does Kafka handle horizontal scaling of brokers?

Answer: Kafka scales horizontally by adding brokers and distributing partition replicas across them. New brokers do not automatically receive a perfectly balanced workload in every version or configuration, so partition reassignment or an appropriate balancing mechanism may be needed. The system scales well when topics have enough partitions to distribute work. More brokers increase total disk, network, and request capacity, but they do not increase the number of active processing consumers within a single partition. I would therefore plan scaling in terms of broker resources and partition layout together. After adding brokers, I would verify replica placement, network utilization, ISR health, and whether the rebalance or reassignment process is itself creating too much traffic.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
