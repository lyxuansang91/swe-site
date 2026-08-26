# 1.9. What is the purpose of Kafka Connect?

Answer: Kafka Connect is a framework for moving data between Kafka and external systems without writing a custom consumer or producer for every integration. A source connector reads data from a system such as a database, API, or file system and writes it to Kafka. A sink connector reads from Kafka and writes to a target such as Elasticsearch, object storage, or a database. Connect workers can be run as a distributed cluster so connector tasks can scale horizontally and recover from failures. The key interview benefit is operational simplicity: connectors standardize configuration, task management, offsets, and error handling. I would use Kafka Connect when the problem is primarily data movement. I would use Kafka Streams or application code when I need business logic or stateful event processing.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
