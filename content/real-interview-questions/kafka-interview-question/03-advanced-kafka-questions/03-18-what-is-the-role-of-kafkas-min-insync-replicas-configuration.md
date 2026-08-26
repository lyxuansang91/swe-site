# 3.18. What is the role of Kafka’s `min.insync.replicas` configuration?

Answer: min.insync.replicas is the minimum number of in-sync replicas that must be available for Kafka to accept a write when the producer uses a strong acknowledgement mode such as acks=all. For example, with replication factor three and min.insync.replicas two, Kafka needs at least two eligible replicas for the partition before it accepts such a write. This setting protects durability because it prevents the leader from acknowledging writes when too few safe copies remain. It is a balance between availability and durability: a stricter minimum can reject writes during replica failures, while a looser minimum may allow writes with fewer copies. For critical payment or audit events, I prefer explicit durability guarantees and monitor ISR health closely.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
