KWAMT = load("../Data/KeyWestAnnualMeanTemperature.RData")

KWAMT = ats[,]

# utils::View(KWAMT)

Temperature = KWAMT[[2]]
Year = KWAMT[[1]]

plot.ts(Year, Temperature)

# ?plot.ts


# Control - shift - c #'s everything highlighted!

?cor
x_time = KWAMT[-nrow(KWAMT),2] # 1901 - 1999
y_time = KWAMT[-1,2] # 1902 -2000

step_1_result = cor(x_time, y_time, method = "pearson") # pearsons corr for pairs of data

n_repeats = 1000 # repeat 1000 times

step_2_result = rep(0,n_repeats) # creating an empty vector()
  
for (v in 1:n_repeats) { # for loop for calculating 100 reps.
  samp1 = sample(KWAMT[[2]], 60) 
  samp2 = sample(KWAMT[[2]], 60)
  corr = cor(samp1, samp2, method = "pearson")
  step_2_result[v] = corr
}

graphics.off()

plot.new()

svg("../Results/TAutoCorr.svg",11.7, 8.3)

p_value = step_2_result[] > step_1_result[]

p_value = as.numeric(p_value)
p_value = sum(p_value) / 1000 # significantly different from normal

hist(step_2_result, xlab = "correlation coefficient values", 
  ylab = "Frequency", col = rgb(1, 0, 0, 0.5), 
  main = "Temperature Coefficients", breaks = 20) 
legend('topleft', c("1000 random correlation coefficients", "successive year correlation"),
  fill=c(rgb(1, 0, 0, 0.5), rgb(0, 0, 1, 0.5)), cex = 1.25)
abline(v = step_1_result, col = rgb(0, 0, 1, 0.5), lwd = 4) # successive year corr

dev.off()

print(p_value)
