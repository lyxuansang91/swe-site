# 1.3. What is a Kafka Topic?

Answer: A Kafka topic is a named logical stream where records are published. I think of it as a category or event channel, such as orders, payments, or user-events. A topic is not a single physical file: Kafka divides it into partitions so multiple brokers and consumers can work in parallel. A record stays in the topic according to the retention policy even after a consumer reads it. That is an important difference from a traditional destructive queue. The topic can therefore support replay and multiple independent consumers. When creating a topic, I normally think about partition count, replication factor, retention, cleanup policy, key strategy, and naming. The topic design should match both throughput requirements and the ordering requirements of the business event.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
