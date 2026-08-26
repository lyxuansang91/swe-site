# 16.4. What is the role of Kafka KSQL?

Answer: Kafka's SQL-style streaming tools, commonly known through ksqlDB, let teams define stream-processing logic using declarative SQL instead of writing all processing code manually. They are useful for filtering, transforming, joining, aggregating, and materializing Kafka streams. For example, a team can derive a high-value-transactions stream from raw payment events with SQL-like syntax. The main benefit is faster development for common streaming transformations and easier access for data-oriented teams. For highly specialized algorithms, complex external integrations, or advanced application logic, a Kafka Streams or another processing framework may be more appropriate. I would choose based on complexity, required state, team skills, deployment model, and observability requirements.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
