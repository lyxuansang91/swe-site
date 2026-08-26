# Java Core

## Java Basics

### What are the different types of memory areas allocated by JVM?

* In java, JVM allocates memory to different processes, methods and objects. Some of the memory areas allocated by JVM are:

1. ClassLoader: It is a component of JVM used to load class files.
2. Class (Method) Area: It stores per-class structures such as the runtime constant pool, field and method data, and the code for methods.
3. Heap: Heap is created a runtime and it contains the runtime data area in which objects are allocated.
4. Stack: Stack stores local variables and partial results at runtime. It also helps in method invocation and return value. Each thread creates a private JVM stack at the time of thread creation.
5. Program Counter Register: This memory area contains the address of the Java virtual machine instruction that is currently being executed.
6. Native Method Stack: This area is reserved for all the native methods used in the application.

### What is OOP and examples

Object-Oriented Programming (OOP) is a programming paradigm that organizes and models software as a collection of objects, which represent real-world entities. These objects encapsulate data (attributes) and behaviors (methods) and interact with each other to perform various operations.

***

#### **Main Principles of OOP**

1. **Abstraction**

   * Abstraction refers to the process of hiding complex implementation details and showing only the essential features of an object. It helps reduce complexity and makes the system easier to use and maintain.
   * **Example**: A `Car` class may expose methods like `startEngine()` and `stopEngine()`, while hiding the internal workings of the engine.

   ```java
   abstract class Shape {
       abstract void draw(); // Abstract method
   }

   class Circle extends Shape {
       @Override
       void draw() {
           System.out.println("Drawing a circle");
       }
   }

   ```
2. **Encapsulation**

* Encapsulation involves bundling data (attributes) and methods (functions) that operate on that data into a single unit (class). It also includes restricting direct access to some components using access modifiers like `private`, `protected`, and `public`.
* **Example**: A `BankAccount` class where the account balance is private and accessed via getter and setter methods.

```java
class BankAccount {
    private double balance;

    public double getBalance() {
        return balance;
    }

    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
        }
    }

    public void withdraw(double amount) {
        if (amount > 0 && amount <= balance) {
            balance -= amount;
        }
    }
}

```

3. **Inheritance**

* Inheritance allows one class to inherit the properties and methods of another class, promoting code reuse and hierarchical relationships.
* **Example**: A `Dog` class inheriting from an `Animal` class.

```java
class Animal {
    void eat() {
        System.out.println("This animal eats food");
    }
}

class Dog extends Animal {
    void bark() {
        System.out.println("The dog barks");
    }
}

public class Main {
    public static void main(String[] args) {
        Dog dog = new Dog();
        dog.eat();  // Inherited from Animal
        dog.bark();
    }
}

```

4. **Polymorphism**

* Polymorphism enables a single interface to represent different underlying forms (data types). It allows objects to be treated as instances of their parent class, enabling method overriding and method overloading.
* **Example**: A `Shape` class with multiple implementations of the `draw()` method.

```java
class Shape {
    void draw() {
        System.out.println("Drawing a shape");
    }
}

class Circle extends Shape {
    @Override
    void draw() {
        System.out.println("Drawing a circle");
    }
}

class Square extends Shape {
    @Override
    void draw() {
        System.out.println("Drawing a square");
    }
}

public class Main {
    public static void main(String[] args) {
        Shape shape1 = new Circle();
        Shape shape2 = new Square();

        shape1.draw(); // Output: Drawing a circle
        shape2.draw(); // Output: Drawing a square
    }
}

```

#### Explain the concept of Inheritance?

* Inheritance is an important concept in Object Oriented Programming. Some objects share certain characteristics and behavior.
* By using Inheritance, we can put the common behavior and characteristics in a base class which also known as super class. And then all the objects with common behavior inherit from this base class. It is also represented by IS-A relationship.
* Inheritance promotes, code reuse, method overriding and polymorphism.

#### Why Java does not support multiple inheritance?

* Multiple Inheritance means that a class can inherit behavior from two or more parent classes.
* The issue with Multiple Inheritance is that both the parent classes may have different implementation for the same method. So they have different ways of doing the same thing. Now which implementation should the child class choose?
* This leads to ambiguity in Multiple Inheritance. This is the main reason for Java not supporting Multiple Inheritance in implementation. Lets say you have a class TV and another class AtomBomb. Both have method switchOn() but only TV has switchOff() method.
* If your class inherits from both these classes then you have an issue that you can switchOn() both parents, but switchOff will only switchOff() TV. But you can implement multiple interfaces in Java.

#### In OOPS, what is meant by composition?

* Composition is also known as “has-a” relationship. In composition, “has-a” relation relates two classes. E.g. Class Car has a steering wheel.
* If a class holds the instance of another class, then it is called composition.

#### How aggregation and composition are different concepts?

* In OOPS, Aggregation and Composition are the types of association relations. A composition is a strong relationship. If the composite object is destroyed, then all its parts are destroyed. E.g. A Car has a Steering Wheel. If Car object is destroyed, then there is no meaning of Steering Wheel.
* In Aggregation, the relationship is weaker than Composition.
* E.g. A Library has students. If a Library is destroyed, Students still exist. So Library and Student are related by Aggregation. A Library has Books. If Library is destroyed, the Books are also destroyed. Books of a Library cannot exist without the Library. So Book and Library are related by Composition.

### Why do we need constructor in Java?

* Java is an object-oriented language, in which we create and use objects. A constructor is a piece of code similar to a method. It is used to create an object and set the initial state of the object. A constructor is a special function that has same name as class name. Without a constructor, there is no other way to create an object. By default, Java provides a default constructor for every object. If we overload a constructor then we have to implement default constructor.

### Why do we need default constructor in Java classes?

* Default constructor is the no-argument constructor that is automatically generated by Java if no other constructor is defined.
* Java specification says that it will provide a default constructor if there is no overloaded constructor in a class. But it does not say anything about the scenario in which we write an overloaded constructor in a class.
* We need at least one constructor to create an object, that’s why Java provides a default constructor. When we have overloaded constructor, then Java assumes that we want some custom treatment in our code. Due to which it does not provide default constructor. But it needs default constructor as per the specification. So it gives error.

### Why constructors cannot be final, static, or abstract in Java?

* If we set a method as final it means we do not want any class to override it. But the constructor (as per Java Language Specification) cannot be overridden. So there is no use of marking it final.
* If we set a method as abstract it means that it has no body and it should be implemented in a child class. But the constructor is called implicitly when the new keyword is used. Therefore it needs a body.
* If we set a method as static it means that it belongs to the class, but not a particular object. The constructor is always called to initialize an object. Therefore, there is no use of marking constructor static.

### Why there are no pointers in Java?

* In Java there are references instead of pointers. These references point to objects in memory. But there is no direct access to these memory locations. JVM is free to move the objects within VM memory.
* The absence of pointers helps Java in managing memory and garbage collection effectively. Also it provides developers with convenience of not getting worried about memory allocation and deallocation

### What is the purpose of ‘super’ keyword in java?

* ‘super’ keyword is used in the methods or constructor of a child class. It refers to immediate parent class of an object.
* By using ‘super’ we can call a method of parent class from the method of a child class.
* We can also call the constructor of a parent class from the constructor of a child class by using ‘super’ keyword.

### In Java, why do we use static variable?

* Whenever we want to have a common property for all objects of a class, we use a class level variable i.e. a static variable.
* This variable is loaded in memory only once at the time of class loading. So it saves memory, since it is not defined per object in Java.

### What is the purpose of static method in Java?

* Java provides the feature of static method to create behavior at the class level. The static method is common to all the objects of a class. We do not need to create any object of a class to call a static method. So it provides convenience of not creating an object for calling it.
* Also a static method can access and modify static data members. This also helps in keeping the behavior as well as state at the class level.

### In what scenario do we use a static block?

* At times, there is a class that has static member variables. These variables need some complicated initialization.
* At this time static block helps as a tool to initialize complex static member variable initialization.
* The static block is executed even before the execution of main. Sometimes, we can also replace static block with a static method of class.

## Method Overloading and Overriding

### What is the other name of Method Overloading?

* Method Overloading is also known as Static Polymorphism.

### How will you implement method overloading in Java?

* In Java, a class can have multiple methods with same name but different arguments. It is called Method Overloading. To implement method overloading we have to create two methods with same name in a class and do one/more of the following:

1. Different number of parameters
2. Different data type of parameters
3. Different sequence of data type of parameters

### Why it is not possible to do method overloading by changing return type of method in java?

* If we change the return type of overloaded methods then it will lead to ambiguous behavior. How will clients know which method will return what type.
* Due to this different return type are not allowed in overloaded methods.

### Are we allowed to override a static method in Java?

* No. Java does not allow overriding a static method. If you create a static method with same name in subclass, then it is a new method, not an overridden method.

### What is the difference between method overloading and method overriding in Java?

* Differences between method overloading and overriding are:

1. Method overloading is static polymorphism. Method overriding is runtime polymorphism.
2. Method overloading occurs within the same class. Method overriding happens in two classes with hierarchy relationship.
3. Parameters must be different in method overloading. Parameters must be same in method overriding.
4. Method overloading is a compile time concept. Method overriding is a runtime concept.

## Polymorphism

### What is Runtime Polymorphism?

* Runtime Polymorphism or Dynamic Polymorphism is the polymorphism that exists at runtime. In case of method overriding it is not known which method will be called at runtime. Based on the type of object, JVM decides the exact method that should be called.
* So at compile time it is not known which method will be called at run time.

## Abstraction

### What is Abstraction in Object Oriented programming?

* Abstraction is the process of hiding certain implementation details of an object and showing only essential features of the object to outside world.
* It is different from Abstract class in Java. Abstraction process identifies commonalities and hides the complexity of implementation.
* It helps us in focusing on the interface that we share with the outside world.

### How is Abstraction different from Encapsulation?

* Abstraction happens at class level design. It results in hiding the implementation details. Encapsulation is also known as “Information Hiding”. An example of encapsulation is marking the member variables private and providing getter and setter for these member variables.

### What is an abstract class in Java?

* An abstract class in Java has one or more abstract methods. An abstract method is just declared in the abstract class, but it is not implemented.
* An abstract class has to be extended in Java and its abstract methods have to be implemented by a child class. Also Java does not allow new instance of Abstract class.

### Why an Interface cannot be marked as final in Java?

* A final method cannot be overridden. But an interface method has to be implemented by another class. So the interface method cannot be marked as final.

### What is the difference between abstract class and interface in Java?

* Differences between Abstract class and Interface are as follows:

1. An abstract class can have implemented methods with body (non-abstract methods). Interface has only abstract methods. From Java 8 onwards, interface can have static/default methods in implemented form.
2. An abstract class can have instance member variables. An interface cannot have instance variables. It can only have constants.
3. An abstract class can have a constructor. Interface cannot have constructor. It has to be implemented by another class.
4. A class can extend only one abstract class. A class can implement more than one interface.

### Which is the most important class in Java?

* It is an open-ended question with many answers. In my view, Object class is the most important class of Java programming language. It is the root of all the classes in Java. It provides some very important and fundamental methods.

## Serialization

### What is the serialization?

* Serialization is a process converting an object into a byte array. This byte array represents the class, version and internal state of the object. JVM can use this byte array to transmit/read the object over a network.

### What is the purpose of serialization?

* Some of the uses of serialization are:

1. Communication: It is used for transmitting an object over network between two machines.
2. Persistence: We can store the object’s state in a database and retrieve it from database later on.
3. Caching: Serialization can be used for caching to improve performance. We may need 10 minutes to build an object, but it may take just 10 seconds to de-serialize the object.
4. Cross JVM Synchronization: It can be used in same way across multiple JVM that follow different architecture.

### What is Deserialization?

* Deserialization is the process of reconstructing the object from the serialized state. It is the reverse process of serialization.

## Garbage Collection

### What is Garbage Collection in Java?

* Java has an internal mechanism called Garbage collection to reclaim the memory of unused projects at run time.
* Garbage collection is also known as automatic memory management.

### Why Java provides Garbage Collector?

* In Java, there are no pointers. Memory management and allocation is done by JVM. Since memory allocation is automated, after some time JVM may go low on memory.
* At that time, JVM has to free memory from unused objects. To help with the process of reclaiming memory, Java provides an automated process called Garbage Collector.

### What is the purpose of gc() in Java?

* Java provides two methods System.gc() and Runtime.gc() to request the JVM to run the garbage collection. By using these methods, programmers can explicitly send request for Garbage Collection. But JVM process can reject this request and wait for some time before running the GC.

### How does Garbage Collection work in Java?

* Java has an automated process called Garbage Collector for Memory Management. It is a daemon in JVM that monitors the memory usage and performs memory cleanup. Once JVM is low on memory, GC process finds the unused objects that are not referenced by other objects. These unused objects are cleaned up by Garbage Collector daemon in JVM.

### What are the different types of References in Java?

* In Java, there are four types of references:

1. Strong Reference
2. Soft Reference
3. Weak Reference
4. Phantom Reference

### What kind of process is the Garbage collector thread?

* Garbage Collection is a Daemon process in JVM. It is an internal process that keep checking Memory usage and cleans up the memory.

## Multi-threading

### How Multi-threading works in Java?

* Java provides support for Multithreading. In a Multithreading environment, one process can execute multiple threads in parallel at the same time.
* In Java, you can create process and then create multiple threads from that process.
* Each process can execute in parallel to perform independent tasks.
* Java provides methods like- start(), notify(), wait(), sleep() etc. to maintain a multi-threading environment.

### What are the advantages of Multithreading?

* Main advantages of Multithreading are:

1. Improved performance: We can improve performance of a job by Multi-threading.
2. Simultaneous access to Multiple Applications: We can access multiple applications from a process by doing multithreading
3. Reduced number of Servers required: With Multithreading we need lesser number of servers, since one process can spawn multiple threads.
4. Simplified Coding: In certain scenarios, it is easier to code multiple threads than managing it from same thread.

### What are the disadvantages of Multithreading?

* There are certain downsides to Multithreading. These are:

1. Difficult to Debug: Multithreading code is difficult to debug in case of an issue.
2. Difficult to manage concurrency: Due to multiple threads, we may experience different kinds of issues.
3. Difficulty of porting code: It is difficult to convert existing single threaded code into multi-threading code.
4. Deadlocks: In case of multi-threading we can experience deadlocks in threads that are waiting for same resource.

### What is a Thread in Java?

* In Java, a thread is a lightweight process that runs within another process or thread. It is an independent path of execution in an application.
* Each thread runs in a separate stack frame. By default Java starts one thread when the main method of a class is called.

### What is a Thread’s priority and how it is used in scheduling?

* In Java, every Thread has a priority. This priority is specified as an integer value.
* The priority value is used in scheduling to pick up the thread with higher priority for execution.
* The threads with higher priority get more preference in execution than the threads with lower priority.
* The task scheduler schedules the higher priority threads first, followed by the lower priority threads.

### What are the differences between Pre-emptive Scheduling Scheduler and Time Slicing Scheduler?

* In Pre-emptive scheduling, the highest priority task will keep getting time to execute until it goes to waiting state or dead state or a task with higher priority comes into queue for scheduling.
* In Time slicing scheduling, every task gets a predefined slice of time for execution, and then it goes to the pool of tasks ready for execution. The scheduler picks up the next task for execution, based on priority and various other factors.

### Can we start a thread two times in Java?

* No. We can call start() method only once on a thread in Java. If we call it twice, it will give us exception.

### In Java, is it possible to lock an object for exclusive use by a thread?

* Yes. We can use synchronized block to lock an object. The locked object is inaccessible to any other thread. Only the thread that has locked it can access it.

### What are the differences between Collection and Collections in Java?

* Main differences between Collection and Collections are:

1. Type: Collection is an interface in Java. Collections is a class.
2. Features: Collection interface provides basic features of data structure to List, Set and Queue interfaces. Collections is a utility class to sort and synchronize collection elements. It has polymorphic algorithms to operate on collections.
3. Method Type: Most of the methods in Collection are at instance level. Collections class has mainly static methods that can work on an instance of Collection

### What are the differences between a HashSet and TreeSet collection in Java?

* Main differences between a HashSet and TreeSet are:

1. Ordering: In a HashSet elements are stored in a random order. In a TreeSet, elements are stored according to natural ordering.
2. Null Value Element: We can store null value object in a HashSet. A TreeSet does not allow to add a null value object.
3. Performance: HashSet performs basic operations like add(), remove(), contains(), size() etc in a constant size time. A TreeSet performs these operations at the order of log(n) time.
4. Speed: A HashSet is better than a TreeSet in performance for most of operations like add(), remove(), contains(), size() etc .
5. Internal Structure: a HashMap in Java internally backs a HashSet. A NavigableMap backs a TreeSet internally.
6. Features: A TreeSet has more features compared to a HashSet. It has methods like pollFirst(), pollLast(), first(), last(), ceiling(), lower() etc.
7. Element Comparison: A HashSet uses equals() method for comparison. A TreeSet uses compareTo() method for

### What are the differences between a HashMap and a Hashtable in Java?

* Main differences between a HashMap and a Hashtable are:

1. Synchronization: HashMap is not a synchronized collection. If it is used in multi-thread environment, it may not provide thread safety. A Hashtable is a synchronized collection. Not more than one thread can access a Hashtable at a given moment of time. The thread that works on Hashtable acquires a lock on it and it makes other threads wait till its work is completed.
2. Null values: A HashMap allows only one null key and any number of null values. A Hashtable does not allow null keys and null values.
3. Ordering: A HashMap implementation by LinkedHashMap maintains the insertion order of elements. A TreeMap sorts the mappings based on the ascending order of keys. On the other hand, a Hashtable does not provide guarantee of any kind of order of elements. It does not maintain the mappings of key values in any specific order.
4. Legacy: Hashtable was not the initial part of collection framework in Java. It has been made a collection framework member, after being retrofitted to implement the Map interface. A HashMap implements Map interface and is a part of collection framework since the beginning.
5. Iterator: The Iterator of HashMap is a fail-fast and it throws ConcurrentModificationException if any other Thread modifies the map by inserting or removing any element except iterator’s own remove() method.

### What are the differences between a HashMap and a TreeMap?

* Main differences between a HashMap and a TreeMap in Java are:

1. Order: A HashMap does not maintain any order of its keys. In a HashMap there is no guarantee that the element inserted first will be retrieved first.
2. In a TreeMap elements are stored according to natural ordering of elements. A TreeMap uses compareTo() method to store elements in a natural order.
3. Internal Implementation: A HashMap uses Hashing internally. A TreeMap internally uses Red-Black tree implementation.
4. Parent Interfaces: A HashMap implements Map interface. TreeMap implements NavigableMap interface.
5. Null values: A HashMap can store one null key and multiple null values. A TreeMap can not contain null key but it may contain multiple null values.
6. Performance: A HashMap gives constant time performance for operations like get() and put(). A TreeMap gives order of log(n) time performance for get() and put() methods.
7. Comparison: A HashMap uses equals() method to compare keys. A TreeMap uses compareTo() method for maintaining natural ordering.
8. Features: A TreeMap has more features than a HashMap. It has methods like pollFirstEntry() , pollLastEntry() , tailMap() , firstKey() , lastKey() etc. that are not provided by a HashMap.

### What are the differences between Comparable and Comparator?

* Main differences between Comparable and Comparator are:

1. Type: Comparable is an interface in Java where T is the type of objects that this object may be compared to.
2. Comparator is also an interface where T is the type of objects that may be compared by this comparator.
3. Sorting: In Comparable, we can only create one sort sequence. In Comparator we can create multiple sort sequences.
4. Method Used: Comparator interface in Java has method public int compare (Object o1, Object o2) that returns a negative integer, zero, or a positive integer when the object o1 is less than, equal to, or greater than the object o2. A Comparable interface has method public int compareTo(Object o) that returns a negative integer, zero, or a positive integer when this object is less than, equal to, or greater than the object o.
5. Objects for Comparison: The Comparator compares two objects given to it as input. Comparable interface compares "this" reference with the object given as input.
6. Package location: Comparable interface in Java is defined in java.lang package. Comparator interface in Java is defined in java.util package.

### How does hashCode() method work in Java?

* Object class in Java has hashCode() method. This method returns a hash code value, which is an integer. The hashCode() is a native method and its implementation is not pure Java.
* Java doesn't generate hashCode(). However, Object generates a HashCode based on the memory address of the instance of the object. If two objects are same then their hashCode() is also same.

### Is it a good idea to use Generics in collections?

* Yes. A collection is a group of elements put together in an order or based on a property. Often the type of element can vary. But the properties and behavior of a Collection remains same. Therefore it is good to create a Collection with Generics so that it is type-safe and it can be used with wide variety of elements.

## Mixed questions

### What is the other name of Shallow Copy in Java?

* Object Cloning. A Shallow Copy just copies the values of references in a Class.

### What is the difference between Shallow Copy and Deep Copy in Java?

* A Shallow copy just copies the values of the references in the class. A Deep copy copies the values of the objects as well.

### What is a Singleton class?

* A Singleton class in Java has maximum one instance of the class present in JVM, all the time. The constructor of this class is written in such a way that it never creates more than one object of same class.

### What is the difference between Singleton class and Static class?

* A static class in Java has only static methods. It is a container of functions. It is created based on procedural programming design.
* Singleton class is a pattern in Object Oriented Design. A Singleton class has only one instance of an object in JVM. This pattern is implemented in such a way that there is always only one instance of that class present in JVM.

### What is Hash Collision? How Java handles hash-collision in HashMap?

* In a Hashing scenario, at times two different objects may have same HashCode but they may not be equal. Therefore, Java will face issue while storing the two different objects with same HashCode in a HashMap. This kind of situation is Hash Collision.
* There are different techniques of resolving or avoiding Hash Collision. But in HashMap, Java simply replaces the Object at old Key with new Object in case of Hash Collision.

### What are the main differences between HashMap and ConcurrentHashMap in Java?

* Main differences between HashMap and ConcurrentHashMap are:

1. Synchronization: A HashMap is not synchronized. But a ConcurrentHashMap is a synchronized object.
2. Null Key: A HashMap can have one null key and any number of null values. A ConcurrentHashMap cannot have null keys or null values.
3. Multi-threading: A ConcurrentHashMap works well in a multi-threading environment

### What is the importance of hashCode() and equals() methods?

* In a HashMap collection it is very important for a key object to implement hashCode() method and equals() method. If hashCode() method returns same hashcode for all key objects then the hash collision will be high in HashMap.
* Also with same hashcode, we will get same equals method that will make our HashMap inefficient. The problem arises when HashMap treats both outputs same instead of different.
* It will overwrite the most recent key-value pair with the previous key-value pair. So it is important to implement hashCode() and equals() methods correctly for an efficient HashMap collection.

### What are the different states of a Thread in Java?

* Following are the different states of a Thread in Java:

1. New: In the New state the thread has not yet.
2. Runnable: A thread executing in the JVM is in Runnable state.
3. Blocked: A thread waiting for a monitor lock is in Blocked state.
4. Waiting: A thread waiting indefinitely for another thread to perform a particular action is in Waiting state.
5. Timed\_waiting: A thread waiting for another thread to perform an action for up to a specified waiting time is in Timed\_waiting state.
6. Terminated: A thread that has exited is in Terminated state.

### What is an atomic operation?

* An atomic operation is an operation that completes in a single step relative to other threads. An Atomic operation is either executed completely or not at all. There is no halfway mark in Atomic operation.

### What are the minimum requirements for a Deadlock situation in a program?

* For a deadlock to occur following are the minimum requirements:

1. Mutual exclusion: There has to be a resource that can be accessed by only one thread at any point of time.
2. Resource holding: One thread locks one resource and holds it, and at the same time it tries to acquire lock on another mutually exclusive resource.
3. No preemption: There is no pre-emption mechanism by which resource held by a thread can be freed after a specific period of time.
4. Circular wait: There can be a scenario in which two or more threads lock one resource each and they wait for each other’s resource to get free. This causes circular wait among threads for same set of resources.

### How can we prevent a Deadlock?

* To prevent a Deadlock from occurring at least one requirement for a deadlock has to be removed:

1. Mutual exclusion: We can use optimistic locking to prevent mutual exclusion among resources.
2. Resource holding: A thread has to release all its exclusive locks if it does not succeed in acquiring all exclusive locks for resources required.
3. No preemption: We can use timeout period for an exclusive lock to get free after a given amount of time.
4. Circular wait: We can check and ensure that circular wait does not occur, when all exclusive locks have been acquired by all the threads in the same sequence.

### How can we detect a Deadlock situation?

* We can use ThreadMXBean.findDeadlockedThreads() method to detect deadlocks in Java program. This bean comes with JDK: Sample code is as follows: \`ThreadMXBean bean = ManagementFactory.getThreadMXBean(); long\[] threadIds = bean.findDeadlockedThreads(); // It will return null for no deadlock if (threadIds != null) { ThreadInfo\[] infos = bean.getThreadInfo(threadIds); for (ThreadInfo info : infos) { StackTraceElement\[] stack = info.getStackTrace(); // Log or store stack trace information. } }

### What is a Race condition?

* A race condition is an unwanted situation in which a program attempts to perform two or more operations at the same time, but because of the logic of the program, the operations have to be performed in proper sequence to run the program correctly. Since it is an undesirable behavior, it is considered as a bug in code. Most of the time race condition occurs in “check then act” scenario. Both threads check and act on same value. But one of the threads acts in between check and act. See this example to understand race condition. `if (x == 3) // Check { y = x * 5; // Act // If another thread changes x // between "if (x == 3)” and "y = x * 5”, // then y will not be equal to 15. }`

### What is a CAS operation?

* CAS is also known a Compare-And-Swap operation. In a CAS operation, the processor provides a separate instruction that can update the value of a register only if the provided value is equal to the current value.
* CAS operation can be used as an alternate to synchronization. Let say thread T1 can update a value by passing its current value and the new value to be updated to the CAS operation. I
* n case another thread T2 has updated the current value of previous thread, the previous thread T1’s current value is not equal to the current value of T2. Hence the update operation fails. I
* n this case, thread T1 will read the current value again and try to update it.

### Which Java classes use CAS operation?

* Java classes like AtomicInteger or AtomicBoolean internally use CAS operations to support multi-threading. These classes are in package java.util.concurrent.atomic.

### What is the volatile keyword useful for?

* `volatile` has semantics for memory visibility. Basically, the value of a `volatile` field becomes visible to all readers (other threads in particular) after a write operation completes on it. Without `volatile`, readers could see some non-updated value.

### What are the scenarios to use parallel stream?

* A parallel stream in Java 8 has a much higher overhead compared to a sequential one. It takes a significant amount of time to coordinate the threads. We can use parallel stream in following scenarios:
* When there are a large number of items to process and the processing of each item takes time and is parallelizable.
* When there is a performance problem in the sequential processing. When current implementation is not already running in a multithread environment. If there is already a multi-threading environment, adding parallel stream can degrade the performance.

### When will you use Adapter design pattern in Java?

* If we have two classes with incompatible interfaces, we use Adapter pattern to make it work. We create an Adapter object that can adapt the interface of one class to another class. It is generally used for working with third party libraries.
* We create an Adapter class between third party code and our class. In case of any change in third party code we have to just change the Adapter code. Rest of our code can remain same and just take to Adapter.

### What are the Architectural patterns that you have used?

* Architectural patterns are used to define the architecture of a Software system. Some of the patterns are as follows:

1. MVC: Model View Controller. This pattern is extensively used in the architecture of Spring framework.
2. Publish-subscribe: This pattern is the basis of messaging architecture. In this case messages are published to a Topic. And subscribers subscribe to the topic of their interests. Once the message is published to a topic in which a Subscriber has an interest, the message is consumed by the relevant subscriber.
3. Service Locator: This design pattern is used in a service like JNDI to locate the available services. It uses as central registry to maintain the list of services.
4. n-Tier: This is a generic design pattern to divide the architecture in multiple tiers. E.g. there is 3-tier architecture with Presentation layer, Application layer and Data access layer. It is also called multi-layer design pattern.
5. Data Access Object (DAO): This pattern is used in providing access to database objects. The underlying principle is that we can change the underlying database system, without changing the business logic. Since business logic talks to DAO object, there is no impact of changing Database system on business logic.
6. Inversion of Control (IoC): This is the core of Dependency Injection in Spring framework. We use this design pattern to increase the modularity of an application. We keep the objects loosely coupled with Dependency Injection.
