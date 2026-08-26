# 13.9. What are the best practices for managing Kafka replication?

Answer: For replication, I choose a replication factor based on the failure model, spread replicas across independent failure domains when possible, and use appropriate min.insync.replicas and producer acknowledgements for important topics. I monitor ISR health and under-replicated partitions continuously. Replication factor should also account for storage because more replicas multiply disk and network usage. I avoid treating replication as a backup because accidental deletion or bad data can still propagate. For disaster recovery, I consider cross-cluster replication and regularly test failover. The final design balances durability, availability, recovery objectives, and cost instead of simply maximizing the replication factor.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
