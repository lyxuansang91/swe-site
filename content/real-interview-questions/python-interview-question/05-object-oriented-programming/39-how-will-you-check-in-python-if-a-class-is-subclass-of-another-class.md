# 39. How will you check in Python, if a class is subclass of another class?

Python provides a useful method issubclass(a,b) to check whether class a is a subclass of b.

E.g. int is not a subclass of long >>> issubclass(int,long) False bool is a subclass of int >>> issubclass(bool,int) True
