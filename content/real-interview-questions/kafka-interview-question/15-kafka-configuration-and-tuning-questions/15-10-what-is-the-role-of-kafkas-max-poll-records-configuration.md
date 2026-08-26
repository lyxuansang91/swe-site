# 15.10. What is the role of Kafka’s `max.poll.records` configuration?

Answer: max.poll.records controls the maximum number of records returned by one consumer poll. It is an application-processing setting more than a broker storage setting. A very large value can improve throughput but may make one processing cycle take too long, increasing the risk of exceeding max.poll.interval.ms and triggering a rebalance. A smaller value gives the consumer more frequent opportunities to poll and can make processing more predictable. I choose it based on the cost of processing one record, the allowed processing latency, and consumer memory. For slow downstream operations, I often reduce the batch size and use bounded concurrency rather than allowing one poll to produce an enormous amount of work.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
