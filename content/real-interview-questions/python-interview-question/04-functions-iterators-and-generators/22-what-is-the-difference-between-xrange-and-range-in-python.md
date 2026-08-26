# 22. What is the difference between xrange and range in Python?

In Python, we use range(0,10) to create a list in memory for 10 numbers. Python provides another function xrange() that is similar to range() but xrange() returns a sequence object instead of list object. In xrange() all the values are not stored simultaneously in memory. It is a lazy loading based function. But as per Python documentation, the benefit of xrange() over range() is very minimal in regular scenarios. As of version 3.1, xrange is deprecated.
