#INTRODUCTION TO R
# Variables in R are used to store data values.
# Assigning values to variables
x <- 10
y <- 20
name <- "John Doe"
is_active <- TRUE

#Data Structures
# Printing variables
print(x)
print(name)
print(is_active)


#1). DATA TYPES
# Numeric data type
numeric_value <- 10.5
numeric_value2 <- 10
class(numeric_value)

# Integer data type
integer_value <- 10L
class(integer_value)

# Character data type
character_value <- "Hello, R!"
class(character_value)

# Logical data type
logical_value <- TRUE
class(logical_value)


#2)DATA STRUCTURES in R
#1) Vectors - Sequence of data elements of the same basic type.
numeric_vector <- c(1, 2, 3, 4, 5)
character_vector <- c("apple", "banana", "cherry")
print(numeric_vector)
print(character_vector)



#2)Matrices - 2D data structure with data of the same type. 
matrix1 <- matrix(1:9, byrow = TRUE, nrow = 3)
matrix2 <- matrix(11:19, ncol = 3, nrow = 3)
print(matrix1)
print(matrix2)

#3) Data Frames - Are Similar to matrices but can contain different types of data.
data_frame <- data.frame(Name = c("John", "Ana", "Fred", "Cindy"), Age = c(23, 21, 55, 31))
View(data_frame)
print(data_frame)

#4) List - An ordered collection of objects
list_data <- list("Red", 20, TRUE, 1:5)

print(list_data)






#OPERATORS - are symbols that tell the compiler to perform specific mathematical, relational, or logical operations and produce a result.

#1. Arithmetic Operators - Arithmetic operators are used for basic mathematical operations:
a <- 10
b <- 3

# Examples of arithmetic operations
print(a + b)  # Addition
print(a - b)  # Subtraction
print(a * b)  # Multiplication
print(a / b)  # Division
print(a ^ b)  # Exponentiation
print(a %% b) # Modulus
print(a %/% b) # Integer Division


#2. Logical Operators - Logical operators are used to perform logical operations, primarily with boolean values (TRUE or FALSE):
x <- TRUE
y <- FALSE

# Examples of logical operations
print(x & y)   # Logical AND
print(x | y)   # Logical OR
print(!x)      # Logical NOT
print(x && y)  # Logical AND (first element)
print(x || y)  # Logical OR (first element)


#3. Relational Operators - Relational operators are used for comparison and return a boolean value based on the relationship:
c <- 20
d <- 15

# Examples of relational operations
print(c == d)  # Equal to
print(c != d)  # Not equal to
print(c < d)   # Less than
print(c > d)   # Greater than
print(c <= d)  # Less than or equal to
print(c >= d)  # Greater than or equal to


#4. Assignment Operators - Assignment operators are used to assign values to variables
# Assigning values
e <- 5
f <<- 10
20 -> g

print(e)
print(f)
print(g)

