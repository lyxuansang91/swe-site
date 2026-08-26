# Spring Java

## Spring core

### What are the different scenarios to use Setter and Constructor based injection in Dependency Injection (DI) design pattern?

* We use Setter injection to provide optional dependencies of an object. Constructor injection is used to provide mandatory dependency of an object. In Spring IoC, Dependency Injection is heavily used. There we have to differentiate between the scenario suitable for Setter based and Constructor based dependency injection.

### What are the benefits of Spring framework in software development?

* Many benefits of Spring framework are: Lightweight Framework:
  * Basic Spring framework is very small in size. It is easy to use and does not add a lot of overhead on software. It just has 2 MB in basic version.
  * Container: Spring framework provides the basic container that creates and manages the life cycle of application objects like Plain old Java objects (POJO). It also stores the configuration files of application objects to be created.
  * Dependency Injection (DI): Spring provided loose coupling is application by Dependency Injection. It uses Inversion of Control technique by which objects specify their dependencies to Spring container instead of creating new objects themselves.
  * Aspect Oriented Programming (AOP): Spring framework promotes and provides support for Aspect oriented programming in Java. This helps in separating application business logic from system services that are common across all the business logic. E.g. Logging can be a cross cutting concern in an Application.
  * Transaction Management: Spring provides a framework for transaction management. So a developer does not have to implement it from scratch. Spring Transaction Management is so powerful that we can scale it from one local transaction to global transactions in a cluster.
  * MVC Framework: For Web applications, Spring provides MVC framework. This framework is based on MVC design pattern and has better features compared to other web frameworks.
  * Exception Handling: Spring also gives support for a common API to handle exceptions in various technologies like- Hibernate, JDBC etc.

### What are the modules in Core Container of Spring framework?

* Spring framework has a Core Container. Modules in Core Container are:
  * Core module
  * Bean module
  * Context module
  * Spring Expression Language module

### What are the modules in Data Access/Integration layer of Spring framework?

* Modules in Data Access/Integration Layer of Spring framework are:
  * JDBC module: An abstraction layer to remove tedious JDBC coding.
  * ORM module Integration layers for Object Relational
  * Mapping OXM module: An abstraction layer to support Object XML mapping.
  * Java Messaging Service (JMS) module: Module for producing and consuming messages.
  * Transactions module: Transaction Management for POJO classes

### What are the modules in Web layer of Spring framework?

* Modules in Web Layer of Spring framework are:
  * Web module: This provides basic web-oriented integration features.
  * Servlet module: Support for Servlet Listeners.
  * WebSocket module: Support for Web Socket style messaging.
  * Portlet module: MVC implementation for Portlet environment.

### What is the use of BeanFactory in Spring framework?

* BeanFactory is the main class that helps in implementing Inversion of Control pattern in Spring. It is based on the factory design pattern. It separates the configuration and dependencies of an application from the rest of application code.
* Implementations of BeanFactory like XmlBeanFactory class are used by applications built with Spring

### How does Spring support Object Relational Mapping (ORM) integration?

* Spring supports Object Relational Mapping (ORM) by providing ORM Module. This module helps in integrating with popular ORM framework like Hibernate, JDO, and iBATIS SQLMaps etc. Transaction Management module of Spring framework supports all of these ORM frameworks as well as JDBC

### What is the purpose of Spring IoC container?

* The Spring IoC Container is responsible for:
  * Creating the objects
  * Configuring the objects
  * Managing dependency between objects (with dependency injection (DI))
  * Wiring the objects together
  * Managing complete lifecycle of objects

### What is the main benefit of Inversion of Control (IOC) principle?

* Inversion of Control (IOC) principle is the base of Spring framework. It supports dependency injection in an application.
* With Dependency Injection, a programmer has to write minimal code. It also makes easier to test an application.
* Most important benefit is that it leads to loose coupling within objects. With loose coupling it is easier to change the application with new requirements.

### Explain Dependency Injection (DI) concept in Spring framework?

* Dependency Injection is a software design pattern. It is used to implement Inversion of Control (IOC) in Spring framework. As per this pattern, we do not create objects in an application by calling new. Rather, we describe how an object should be created.
* In this way creation of an object is not tightly coupled with another object. A container is responsible for creating and wiring the objects. The container can call injecting code and wire the objects as per the configuration at runtime.

### What are the different roles in Dependency Injection (DI)?

* There are four roles in Dependency Injection:
  * Service object(s) to be used
  * Client object that depends on the service
  * Interface that defines how client uses services
  * Injector responsible for constructing services and injecting them into client

### Spring framework provides what kinds of Dependency Injection mechanism?

* Spring framework provides two types of Dependency Injection mechanism:
  * Constructor-based Dependency Injection: Spring container can invoke a class constructor with a number of arguments. This represents a dependency on other class.
  * Setter-based Dependency Injection: Spring container can call setter method on a bean after creating it with a no-argument constructor or no-argument static factory method to instantiate another bean.

### In Spring framework, which Dependency Injection is better? Constructor-based DI or Setter-based DI?

* Spring framework provides support for both Constructor-based and Setter-based Dependency Injection.
* There are different scenarios in which these options can be used. It is recommended to use Constructor-based DI for mandatory dependencies. Whereas Setter-based DI is used for optional dependencies.

### What is a Spring Bean?

* A Spring Bean is a plain old Java object (POJO) that is created and managed by a Spring container.
* There can be more than one bean in a Spring application. But all these Beans are instantiated and assembled by Spring container.
* Developer provides configuration metadata to Spring container for creating and managing the lifecycle of Spring Bean. In general a Spring Bean is singleton.
* Every bean has an attribute named "singleton". If its value is true then bean is a singleton. If its value is false then bean is a prototype bean. By default the value of this attribute is true. Therefore, by default all the beans in spring framework are singleton in nature.

### What does the definition of a Spring Bean contain?

* A Spring Bean definition contains configuration metadata for bean. This configuration metadata is used by Spring container to:
  * Create the bean
  * Manage its lifecycle
  * Resolve its dependencies

### What are the different scopes of a Bean supported by Spring?

* Spring framework support seven types of scopes for a Bean. Out of these only five scopes are available for a web-aware ApplicationContext application:
  * Singleton: This is the default scope of a bean. Under this scope, there is a single object instance of bean per Spring IoC container.
  * Prototype: Under this scope a single bean definition can have multiple object instances.
  * Request: In this scope, a single bean definition remains tied to the lifecycle of a single HTTP request. Each HTTP request will have its own instance of a bean for a single bean definition. It is only valid in the context of a web-aware Spring ApplicationContext.
  * Session: Under this scope, a single bean definition is tied to the lifecycle of an HTTP Session. Each HTTP Session will have one instance of bean. It is also valid in the context of a web-aware Spring ApplicationContext.
  * GlobalSession: This scope, ties a single bean definition to the lifecycle of a global HTTP Session. It is generally valid in a Portlet context. It is also valid in the context of a web-aware Spring ApplicationContext.
  * Application: This scope, limits a single bean definition to the lifecycle of a ServletContext. It is also valid in the context of a web-aware Spring ApplicationContext.
  * Websocket: In this scope, a single bean definition is tied to the lifecycle of a WebSocket. It is also valid in the context of a webaware Spring ApplicationContext.

### What is the lifecycle of a Bean in Spring framework?

<figure><img src="/files/53GFXSUf5xUQDtd3whLp" alt=""><figcaption><p>Lifecycle of a Bean</p></figcaption></figure>

1. **Instantiation**: Spring container creates an instance of the bean using its constructor.
2. **Population of Properties**: Spring injects dependencies and sets properties of the bean.
3. **Aware Interfaces**: Spring invokes any callback methods implemented by the bean such as InitializingBean's **afterPropertiesSet()** or BeanNameAware's **setBeanName()**.
4. **Custom Init Method**: If configured, Spring calls custom initialization methods annotated with @PostConstruct or defined in XML.
5. **Bean Ready for Use**: The bean is now fully initialized and ready for use by other beans or components.
6. **Bean Destruction**: When the application context is shut down or the bean is no longer needed, Spring calls any destruction callbacks such as DisposableBean's **destroy()** method or methods annotated with @PreDestroy.

### What are the two main groups of methods in a Bean’s lifecycle?

* A Bean in Spring has two main groups of lifecycle methods.
  * Initialization Callbacks: Once all the necessary properties of a Bean are set by the container, Initialization Callback methods are used for performing initialization work. A developer can implement method afterPropertiesSet() for this work.
  * Destruction Callbacks: When the Container of a Bean is destroyed, it calls the methods in DisposableBean to do any cleanup work. There is a method called destroy() that can be used for this purpose to make Destruction Callbacks. Recent recommendation from Spring is to not use these methods, since it can strongly couple your code to Spring code.

### What is Autowiring in Spring?

* Autowiring is a feature of Spring in which container can automatically wire/connect the beans by reading the configuration file.
* Developer has to just define “autowire” attribute in a bean. Spring resolves the dependencies automatically by looking at this attribute of beans that are autowired.

### What are the cases in which Autowiring may not work in Spring framework?

* Autowiring is a great feature in Spring. It can be used in most of the cases. But there are certain scenarios in which Autowiring may not work.
* Explicit wiring: Since Autowiring is done by Spring, developer does not have full control on specifying the exact class to be used. It is preferable to use Explicit wiring in case of full control over wiring.
* Primitive Data types: Autowiring does not allow wiring of properties that are based on primitive data types like- int, float etc.

### What is the purpose of @Configuration annotation?

* This annotation is used in a class to indicate that this is class is the primary source of bean definitions. This class can also contain inter-bean dependencies that are annotated by @Bean annotation.

### What is the difference between Full @Configuration and 'lite' @Beans mode?

* Spring allows for using @Bean annotation on methods that are declared in classes not annotated with @Configuration. This is known as “lite” mode. In this mode, bean methods can be declared in a @Component or a plain java class without any annotation.
* In the “lite” mode, @Bean methods cannot declare inter-bean dependencies.
* It is recommended that one @Bean method should not invoke another @Bean method in 'lite' mode.
* Spring recommends that @Bean methods declared within @Configuration classes should be used for full configuration. This kind of full mode can prevent many bugs.

### What is @Autowired annotation?

* We can use @Autowired annotation to auto wire a bean on a setter method, constructor or a field. @Autowired auto wiring is done by matching the data type.

### What is @Required annotation?

* We use @Required annotation to a property to check whether the property has been set or not.
* Spring container throws BeanInitializationException if the @Required annotated property is not set.
* When we use @Required annotation, we have to register RequiredAnnotationBeanPostProcessor in Spring config file.

### What is @Qualifier annotation in Spring?

* We use @Qualifier annotation to mark a bean as ready for auto wiring. This annotation is used along with @Autowired annotation to specify the exact bean for auto wiring by Spring container.

### How Spring framework makes JDBC coding easier for developers?

* Spring provides a mature JDBC framework to provide support for JDBC coding. Spring JDBC handled resource management as well as error handling in a generic way. This reduces the work of software developers.
* They just have to write queries and related statements to fetch the data or to store the data in database.

### What are the different types of the Transaction Management supported by Spring framework?

* Spring framework provides support for two types of Transaction Management:
  * Programmatic: In this method, we have to manage Transaction by programming explicitly. It provides flexibility to a developer, but it is not easier to maintain.
  * Declarative: In this approach, we can separate Transaction Management from the Application Business code. We can use annotations or XML based configuration to manage the transactions in declarative approach.
