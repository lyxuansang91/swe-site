# 16.9. What is the role of Kafka Streams State Stores?

Answer: Kafka Streams state stores provide local, queryable state for stateful stream processing. They allow an application to keep data such as counts, aggregates, or keyed records close to the processing task instead of querying an external database for every event. Kafka Streams can back up that state through changelog topics, which helps recover state when a task moves to another instance or the local disk is lost. This makes stateful streaming practical while preserving Kafka's partitioned processing model. For example, a stream can group transactions by customer and maintain a running balance or count. I would still think carefully about state size, restore time, partitioning, and whether an external database is a better fit for the query requirements.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
