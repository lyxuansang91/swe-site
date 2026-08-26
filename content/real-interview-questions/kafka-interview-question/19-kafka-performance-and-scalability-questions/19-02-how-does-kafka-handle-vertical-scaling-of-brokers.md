# 19.2. How does Kafka handle vertical scaling of brokers?

Answer: Vertical scaling means giving an existing broker more CPU, memory, faster disks, or more network bandwidth. It can be useful when a broker is resource-constrained and the workload does not justify adding more machines immediately. Faster disks can help with log writes, replication, and cleanup; more CPU can help with compression, TLS, and request handling; more memory may improve page-cache effectiveness. However, vertical scaling has a ceiling and still leaves a large failure domain if one broker contains too much capacity. I prefer horizontal scaling for long-term Kafka growth and use vertical scaling to remove specific bottlenecks. In either case, I validate the change through measured throughput, latency, disk I/O, CPU, and replication metrics.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
