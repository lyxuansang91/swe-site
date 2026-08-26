# 13.2. What are the best practices for configuring Kafka producers?

Answer: For producers, I enable idempotence for important workloads, choose a suitable acknowledgement level, use batching and compression, define delivery timeouts and retry behavior, and use stable keys when ordering matters. I validate payload size limits and schema compatibility. I also make error handling explicit: transient broker errors can be retried, while permanent serialization or authorization errors need a different response. For high-throughput workloads, I measure batch size, network usage, CPU, and latency. For low-latency workloads, I minimize unnecessary batching delay. Finally, producer configuration should be standardized through application libraries or platform templates so every service does not invent its own reliability model.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
