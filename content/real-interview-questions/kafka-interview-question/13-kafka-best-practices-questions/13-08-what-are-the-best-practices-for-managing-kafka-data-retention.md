# 13.8. What are the best practices for managing Kafka data retention?

Answer: Retention should be designed from replay and recovery requirements first, then checked against storage capacity. I estimate daily event volume, average record size, replication factor, and the desired retention window, and I leave extra disk capacity for failures and rebalancing. Topics with current-state semantics may use compaction, while immutable business events may use time- or size-based retention. I document who owns the data and how long it may remain according to legal or business requirements. I also monitor actual disk growth so a producer traffic spike or misconfigured retention value is caught early. Retention is a data lifecycle decision, not just an infrastructure cleanup setting.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
