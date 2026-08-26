# 15.3. What is the role of Kafka’s `replica.fetch.wait.max.ms` configuration?

Answer: replica.fetch.wait.max.ms controls how long a follower's fetch request may wait for enough data to become available before Kafka responds. A small value can make replication responses more frequent but can increase request overhead. A larger value allows more data to accumulate, which can improve batching and throughput but may increase replication latency. The right setting depends on workload characteristics and should be considered together with fetch size and network capacity. In production I would not tune this property in isolation. I would look at ISR stability, follower fetch rate, replication latency, broker network usage, and whether the cluster is throughput- or latency-sensitive.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
