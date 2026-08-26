# 13. What is a Namespace in Python?

A Namespace in Python is a mapping between a name and an object. It is currently implemented as Python dictionary.

E.g. the set of built-in exception names, the set of built-in names, local names in a function At different moments in Python, different Namespaces are created. Each Namespace in Python can have a different lifetime. For the list of built-in names, Namespace is created when Python interpreter starts. When Python interpreter reads the definition of a module, it creates global namespace for that module. When Python interpreter calls a function, it creates local namespace for that function.
