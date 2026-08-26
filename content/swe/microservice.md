# Microservice

### What is a Microservice?

* A Microservice is a small and autonomous piece of code that does one thing very well. It is focused on doing well one specific task in a big system.
* It is also an autonomous entity that can be designed, developed and deployed independently.
* Generally, it is implemented as a REST service on HTTP protocol, with technology-agnostic APIs. Ideally, it does not share database with any other service.

### What are the benefits of Microservices architecture?

* Microservices provide many benefits. Some of the key benefits are:

1. Scaling: Since there are multiple Microservices instead of one monolith, it is easier to scale up the service that is being used more. Eg. Let say, you have a Product Lookup service and Product Buy service. The frequency of Product Lookup is much higher than Product Buy service. In this case, you can just scale up the Product Lookup service to run on powerful hardware with multiple servers. Meanwhile, Product Buy service can remain on less powerful hardware.
2. Resilience: In Microservice architecture, if your one service goes down, it may not affect the rest of the system. The other parts can keep functioning, business as usual (BAU). Eg. Let say, you have Product Recommendation service and Product Buy service. If Product Recommendation service goes down, the Product Buy service can still keep running.
3. Technology Mix: With so many changes in technology everyday, you can keep using the latest technology for your new Microservices. You can adopt new technologies with less risk compared to Monolithic architecture. This is one of the best benefits of Microservices architecture.
4. Reuse: Microservices help you in reusing the lessons learnt from one service to another.
5. Easy Deployment: Microservices architecture, if done correctly, helps in making the deployment process smooth. If anything goes wrong, it can be rolled back easily and quickly in Microservices.

### What is the role of architect in Microservices architecture?

* Architects, in Microservices architecture, play the role of Town planners. They decide in broad strokes about the layout of the overall software system. They help in deciding the zoning of the components. They make sure components are mutually cohesive but not tightly coupled.
* They need not worry about what is inside each zone. Since they have to remain up to date with the new developments and problems, they have to code with developers to learn the challenges faced in day-to-day life.
* They can make recommendations for certain tools and technologies, but the team developing a micro service is ultimately empowered to create and design the service. Remember, a micro service implementation can change with time.
* They have to provide technical governance so that the teams in their technical development follow principles of Microservice. At times they work as custodians of overall Microservices architecture.

### What is the advantage of Microservices architecture over Service Oriented Architecture (SOA)?

### Is it a good idea to provide a Tailored Service Template for Microservices development in an organization?

### What are the disadvantages of using Shared libraries approach to decompose a monolith application?

### What are the characteristics of a Good Microservice? 994.What is Bounded Context?

### What are the points to remember during integration of Microservices?

### Is it a good idea for Microservices to share a common database?

* Sharing a common database between multiple Microservices increases coupling between them. One service can start accessing data tables of another service. This can defeat the purpose of bounded context. So it is not a good idea to share a common database between Microservices.

### What is the preferred type of communication between Microservices? Synchronous or Asynchronous?

* Synchronous communication is a blocking call in which client blocks itself from doing anything else, till the response comes back. In Asynchronous communication, client can move ahead with its work after making an asynchronous call. Therefore client is not blocked.
* In synchronous communication, a Microservice can provide instant response about success or failure. In real-time systems, synchronous service is very useful. In Asynchronous communication, a service has to react based on the response received in future.
* Synchronous systems are also known as request/response based. Asynchronous systems are event-based. Synchronous Microservices are not loosely coupled. Depending on the need and critical nature of business domain, Microservices can choose synchronous or asynchronous form of communication.

### What is the difference between Orchestration and Choreography in Microservices architecture?

### What are the issues in using REST over HTTP for Microservices?

* In REST over HTTP, it is difficult to generate a client stub. Some Web-Servers also do not support all the HTTP verbs likeGET, PUT, POST, DELETE etc. Due to JSON or plain text in response, performance of REST over HTTP is better than SOAP. But it is not as good as plain binary communication.
* There is an overhead of HTTP in each request for communication. HTTP is not well suited for low-latency communications. There is more work in consumption of payload. There may be overhead of serialization, deserialization in HTTP.

### Can we create Microservices as State Machines?
