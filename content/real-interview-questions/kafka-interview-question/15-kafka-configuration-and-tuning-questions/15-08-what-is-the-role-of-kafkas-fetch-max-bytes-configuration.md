# 15.8. What is the role of Kafka’s `fetch.max.bytes` configuration?

Answer: fetch.max.bytes controls the maximum amount of data a consumer will try to receive in one fetch request. Larger fetches can improve throughput because the consumer processes more data per network round trip, but they also increase memory usage and can create larger processing bursts. The setting should align with message sizes, consumer memory, processing time, and downstream capacity. I would combine it with max.poll.records and fetch.max.wait.ms so that the consumer fetch behavior does not overwhelm the application. When investigating lag, I check whether the consumer is actually fetching enough data and whether the time spent processing each batch is the limiting factor.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
