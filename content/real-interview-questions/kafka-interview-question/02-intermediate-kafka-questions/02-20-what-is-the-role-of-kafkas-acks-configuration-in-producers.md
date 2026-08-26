# 2.20. What is the role of Kafka’s `acks` configuration in producers?

Answer: The producer acks setting controls how much acknowledgement the producer requires from Kafka before treating a write as successful. With acks=0, the producer does not wait for a broker acknowledgement, giving low latency but weak delivery guarantees. With acks=1, the leader acknowledges after accepting the record, while replicas may still be catching up. With acks=all, the leader waits for the required in-sync replicas according to the topic and broker configuration, giving the strongest durability protection. In production, I commonly combine acks=all with idempotence and an appropriate min.insync.replicas setting for important events. The important interview point is that acks is a producer durability control, not a magical exactly-once switch by itself.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
