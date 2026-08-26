# 15.7. What is the role of Kafka’s `message.max.bytes` configuration?

Answer: message.max.bytes limits the size of a record batch that a broker will accept for a topic or broker configuration, depending on where it is set. Large messages are generally expensive in Kafka because they consume memory, network bandwidth, disk, and can make replication and consumer processing harder. I prefer to keep Kafka events reasonably small and store large binary objects in object storage, placing only metadata or a reference in Kafka. If a legitimate use case needs larger messages, the broker, topic, producer, and consumer limits must all be compatible. A common production mistake is increasing only the broker limit while leaving the producer or consumer fetch limits too low.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
