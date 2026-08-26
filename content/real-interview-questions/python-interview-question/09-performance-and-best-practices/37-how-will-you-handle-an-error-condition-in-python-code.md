# 37. How will you handle an error condition in Python code?

We can implement exception handling to handle error conditions in Python code. If we are expecting an error condition that we cannot handle, we can raise an error with appropriate message.

E.g. >>> if student_score < 0: raise ValueError(“Score can not be negative”) If we do not want to stop the program, we can just catch the error condition, print a message and continue with our program.
E.g. In following code snippet we are catching the error and continuing with the default value of age. #!/usr/bin/python try: age=18+'duration' except: print("duration has to be a number") age=18 print(age)
