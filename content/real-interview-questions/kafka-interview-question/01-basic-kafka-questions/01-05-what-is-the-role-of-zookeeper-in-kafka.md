# 1.5. What is the role of Zookeeper in Kafka?

Answer: ZooKeeper was historically used by Kafka for cluster metadata and coordination, including controller election, broker registration, and management of partition state. However, current Kafka deployments can run in KRaft mode, where Kafka manages its own metadata quorum instead of depending on ZooKeeper. In an interview, I would explicitly say: ZooKeeper is relevant to older Kafka architectures, while KRaft is the modern direction. If I am troubleshooting an older cluster, I check broker-to-ZooKeeper connectivity, session timeouts, authentication, and whether the brokers can maintain their ZooKeeper sessions. For a new deployment, I would generally prefer KRaft unless there is a specific compatibility reason to use an older ZooKeeper-based setup.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
