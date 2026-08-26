# 2.11. How does Kafka handle message compression?

Answer: Kafka supports producer-side compression so batches of records can be stored and transmitted more efficiently. Common codecs include gzip, snappy, lz4, and zstd. The producer compresses batches before sending them, which can reduce network usage and disk consumption. The trade-off is CPU overhead. In practice, compression can improve overall throughput because moving fewer bytes over the network is often more valuable than the additional CPU cost, especially with highly compressible JSON or repetitive event data. I would benchmark using realistic payloads rather than assume one codec is always best. I also distinguish compression from serialization: serialization defines how the object becomes bytes, while compression reduces the size of those bytes for transport and storage.

Interview close: The key is to choose the Kafka behavior that matches the required durability, ordering, throughput, and recovery guarantees.
