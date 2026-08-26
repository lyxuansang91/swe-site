# 16.10. What is the role of Kafka Streams Interactive Queries?

Answer: Kafka Streams Interactive Queries allow an application to query some of its local state stores through a service interface. The idea is that a streaming application can continuously build a materialized view and then expose that view for low-latency reads without recomputing the result from the full event history each time. The key design challenge is that the state is partitioned across application instances, so the application needs a way to determine which instance owns the relevant key or to route queries appropriately. I would use this for read-mostly views derived from streaming data, but I would not treat it as a replacement for every general-purpose database. It is most valuable when the query corresponds naturally to the materialized stream state.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
