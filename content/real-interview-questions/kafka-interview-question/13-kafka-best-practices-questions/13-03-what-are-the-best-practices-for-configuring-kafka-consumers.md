# 13.3. What are the best practices for configuring Kafka consumers?

Answer: For consumers, I make processing idempotent, choose a clear offset commit strategy, size poll and fetch settings around actual processing time, and ensure the consumer does not block so long that it is removed from the group. I monitor lag and rebalance frequency. Slow or poison records should not permanently stop a partition, so I define retry and dead-letter behavior where appropriate. I keep the number of consumer instances aligned with partition count and make sure downstream databases or APIs can handle the concurrency. Finally, I test restart, rebalance, duplicate delivery, and lag recovery scenarios. The goal is not merely to 'receive messages' but to create a predictable processing contract.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
