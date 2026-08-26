# 8.6. What is the role of Kafka’s `log.segment.bytes` configuration?

Answer: Kafka stores each partition as a sequence of log segment files rather than one endlessly growing file. A new segment is created when the active segment reaches the configured size or when the segment's time-based rolling conditions are met. Segment rolling makes retention and compaction practical because Kafka can operate on older closed segments without disturbing the active write file. A smaller segment can make cleanup more granular but creates more files and metadata operations; a larger segment reduces file counts but can delay cleanup precision and increase the amount of data processed during some maintenance operations. I would tune segment size together with retention, workload rate, disk capacity, and the number of partitions.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
