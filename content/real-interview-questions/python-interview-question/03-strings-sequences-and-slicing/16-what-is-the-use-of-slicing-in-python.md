# 16. What is the use of Slicing in Python?

We can use Slicing in Python to get a substring from a String. The syntax of Slicing is very convenient to use.

E.g. In following example we are getting a substring out of the name John. >>> name="John" >>> name[1:3] 'oh' In Slicing we can give two indices in the String to create a Substring. If we do not give first index, then it defaults to 0.
E.g. >>> name="John" >>> name[:2] 'Jo' If we do not give second index, then it defaults to the size of the String. >>> name="John" >>> name[3:] 'n'
