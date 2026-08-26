# 13.1. What are the best practices for designing Kafka topics?

Answer: For topic design, I keep names stable and meaningful, define one clear event contract per topic, choose the partition key from the business ordering requirement, and set partitions based on throughput and consumer parallelism. I define retention or compaction intentionally, configure replication for the failure model, and document producers and consumers. I also avoid putting unrelated event types together unless there is a good reason, because a mixed topic can make schema evolution and consumer ownership harder. Large binary payloads usually belong in object storage with a reference in Kafka. Finally, I treat topic creation and configuration as controlled infrastructure, not as ad-hoc manual steps in production.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
