# 42. What is the difference between ‘is’ and ‘==’ in Python?

We use ‘is’ to check an object against its identity. We use ‘==’ to check equality of two objects.

E.g. >>> lst = [10,20, 20] >>> lst == lst[:] True >>> lst is lst[:] False
