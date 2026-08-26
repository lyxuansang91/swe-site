# 15.9. What is the role of Kafka’s `fetch.max.wait.ms` configuration?

Answer: fetch.max.wait.ms is the maximum time a broker may wait for enough data to accumulate before responding to a consumer fetch request, subject to the minimum fetch conditions. A lower value can reduce waiting time and improve responsiveness for low-volume traffic, while a higher value can improve batching efficiency for busy streams. It is a latency-throughput trade-off. In an event-driven application, I tune it based on end-to-end latency requirements rather than only broker throughput. I also consider fetch.min.bytes because the interaction between minimum bytes and maximum wait affects how often consumers receive data. The correct values depend on event rate and payload size.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
