# 2.12. What is the role of a Kafka Controller?

Answer: The Kafka controller is responsible for cluster-level metadata operations such as managing partition leadership and reacting to broker membership changes. In modern KRaft clusters, controller nodes form a metadata quorum that manages the cluster's metadata and leadership decisions. If a broker fails, controller logic detects the change and coordinates leader election for affected partitions. This is different from a partition leader, which handles data operations for one specific partition. In an older ZooKeeper-based cluster, the controller role was coordinated using ZooKeeper. In an interview I would say the controller is about cluster coordination and metadata, while partition leaders are about serving the data path for individual partitions.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
