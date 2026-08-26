# 15.5. What is the role of Kafka’s `unclean.leader.electi on.enable` configuration?

Answer: Unclean leader election is the mechanism that can allow Kafka to elect a replica that is not fully caught up with the previous leader. It can improve availability because the partition can recover even when no fully in-sync replica is available, but it risks losing records that existed only on the old leader. That is why I would normally prefer clean leader election for durability-sensitive workloads. For example, in a payment event stream, I would rather accept temporary unavailability than elect a stale replica and silently lose acknowledged events. The setting should therefore reflect business risk. Availability-focused systems may make a different trade-off, but the choice must be explicit and tested.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
