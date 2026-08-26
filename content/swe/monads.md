# Monads

Monads are a functional programming concept that have been widely adopted in languages like Haskell and Scala. While Java is not a purely functional programming language, you can leverage monad-like patterns in Java using constructs such as `Optional`, `Stream`, `CompletableFuture`, or by creating your own custom monads.

Here’s a deeper dive into Monads in Java:

***

#### **What is a Monad?**

A monad is a design pattern used in functional programming to handle computations wrapped in a context, such as handling optional values, side effects, or asynchronous operations. It has three primary characteristics:

1. **Wrapping a value**: Monads encapsulate a value or computation.
2. **Binding operations**: You can chain operations on the encapsulated value without unwrapping it explicitly.
3. **Associativity**: Operations should be chainable in any order without affecting the result.

***

#### **Examples of Monads in Java**

**1. `Optional` as a Monad**

The `Optional` class is a simple monad used for handling the presence or absence of a value, avoiding `null` references.

```java
import java.util.Optional;

public class OptionalMonad {
    public static void main(String[] args) {
        Optional<String> name = Optional.of("Java");
        String greeting = name
            .map(n -> "Hello, " + n) // Apply a transformation
            .orElse("Hello, Guest!"); // Provide a fallback

        System.out.println(greeting);
    }
}
```

* **`map`**: Applies a function to the value inside the `Optional`, returning another `Optional`.
* **`flatMap`**: Similar to `map`, but flattens nested `Optional` results.

***

**2. `Stream` as a Monad**

Streams allow processing sequences of elements in a functional style. They support operations like `map`, `filter`, and `flatMap`.

```java
import java.util.List;
import java.util.stream.Collectors;

public class StreamMonad {
    public static void main(String[] args) {
        List<Integer> numbers = List.of(1, 2, 3, 4, 5);
        List<Integer> squared = numbers.stream()
            .map(n -> n * n) // Apply a transformation
            .collect(Collectors.toList());

        System.out.println(squared); // [1, 4, 9, 16, 25]
    }
}
```

* **`map`**: Transforms each element in the stream.
* **`flatMap`**: Flattens nested structures, useful when working with streams of streams.

***

**3. `CompletableFuture` as a Monad**

`CompletableFuture` handles asynchronous computations in Java.

```java
import java.util.concurrent.CompletableFuture;

public class CompletableFutureMonad {
    public static void main(String[] args) {
        CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> "Java")
            .thenApply(name -> "Hello, " + name)
            .thenApply(String::toUpperCase);

        future.thenAccept(System.out::println); // Prints: HELLO, JAVA
    }
}
```

* **`thenApply`**: Similar to `map` for synchronous operations.
* **`thenCompose`**: Similar to `flatMap` for chaining asynchronous operations.

***

#### **Custom Monads in Java**

You can create your own monads by following the monad pattern:

1. Define a wrapper class to encapsulate the value.
2. Provide methods for `map` (transforming the value) and `flatMap` (chaining computations).

Example: A simple `Maybe` monad.

```java
public class Maybe<T> {
    private final T value;

    private Maybe(T value) {
        this.value = value;
    }

    public static <T> Maybe<T> of(T value) {
        return new Maybe<>(value);
    }

    public <R> Maybe<R> map(Function<T, R> mapper) {
        if (value == null) {
            return new Maybe<>(null);
        }
        return new Maybe<>(mapper.apply(value));
    }

    public <R> Maybe<R> flatMap(Function<T, Maybe<R>> mapper) {
        if (value == null) {
            return new Maybe<>(null);
        }
        return mapper.apply(value);
    }

    public T orElse(T defaultValue) {
        return value != null ? value : defaultValue;
    }

    @Override
    public String toString() {
        return value == null ? "Nothing" : "Just " + value;
    }
}

public class MonadExample {
    public static void main(String[] args) {
        Maybe<Integer> result = Maybe.of(10)
            .map(x -> x * 2)
            .flatMap(x -> Maybe.of(x + 5));

        System.out.println(result); // Just 25
    }
}
```

***

#### **Benefits of Monads in Java**

* **Improved code readability**: Avoids explicit null checks and nested structures.
* **Composability**: Enables chaining of operations cleanly.
* **Error handling**: Encapsulates errors without exceptions (e.g., `Optional`).

***

#### **Challenges**

* Java's verbosity makes implementing and using custom monads cumbersome compared to functional programming languages.
* Lack of built-in monadic support in the language itself (e.g., no syntactic sugar like `for`-comprehensions in Scala).

***

By adopting monads in Java, you can write cleaner, more expressive, and more robust functional-style code.
