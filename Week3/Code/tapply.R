x <- 1:20 # a vector

# A factor (of the same length) defining groups:
y <- factor(rep(letters[1:5], each = 4))


print(tapply( x, y, sum))
