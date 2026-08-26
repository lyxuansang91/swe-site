# 16.1. What is the role of Kafka REST Proxy?

Answer: Kafka REST Proxy provides an HTTP interface for interacting with Kafka. It is useful when a client cannot use a native Kafka protocol library or when an organization wants a simple REST-based integration layer. A REST call can publish records or consume records through the proxy without embedding a Kafka client in the application. The trade-off is that an extra HTTP layer can add latency and operational complexity, so native clients are usually preferable for high-throughput internal services. I would use REST Proxy for integration convenience, lightweight clients, or environments where HTTP is the required boundary. I would still apply authentication, authorization, schema handling, rate limiting, and observability just as I would for any other production Kafka interface.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
