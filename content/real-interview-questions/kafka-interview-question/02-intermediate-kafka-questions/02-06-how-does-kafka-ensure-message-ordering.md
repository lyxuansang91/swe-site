# 2.6. How does Kafka ensure message ordering?

Answer: Kafka guarantees ordering within a single partition. If the producer sends A, B, and C to the same partition, consumers will read them in that order. Kafka does not provide one global order across all partitions because partitions are designed for parallelism. When business ordering matters, I choose a stable message key such as orderId, accountId, or userId so all related events are routed to the same partition. The trade-off is that a hot key can concentrate traffic on one partition. I would therefore define the exact ordering requirement first. For example, an order's lifecycle events must be ordered for that order, but events for unrelated orders do not need global ordering. This gives Kafka both correct business semantics and scalable parallel processing.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
