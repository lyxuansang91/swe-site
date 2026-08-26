# 30. What is the use of zip() function in Python?

In Python, we have a built-in function zip() that can be used to aggregate all the Iterable objects of an Iterator. We can use it to aggregate Iterable objects from two iterators as well.

E.g. list_1 = ['a', 'b', 'c'] list_2 = ['1', '2', '3'] for a, b in zip(list_1, list_2): print a, b Output: a1 b2 c3 By using zip() function we can divide our input data from different sources into fixed number of sets.
