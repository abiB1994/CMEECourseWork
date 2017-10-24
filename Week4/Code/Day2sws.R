# Stats with sparrows - day 2

#mean is equal to variance in Poisson distribution (Count data)

#Mean != variance in negative binomial (count data)

#Parametric tests are for numeric data i.e. continuous, discrete, count. Also have to be norm. distributed. Have a better significance if correctly used

#Non-para for categorical data i.e. Ranked, nominal
rm(list = ls())

sparrow = read.table("../Data/SparrowSize.txt", header=TRUE)
str(sparrow)
dplyr::tbl_df(sparrow)

graphics.off()
par(mfrow = c(2,2))
hist(sparrow$Mass)
hist(sparrow$Tarsus)
hist(sparrow$Bill)
hist(sparrow$Wing)
d <- density(sparrow$Mass, na.rm = TRUE)
graphics.off()
plot(d)

graphics.off()
par(mfrow=c(1,2))
x = sample(sparrow$Mass, 300)
#normal fit
qqnorm(x);qqline(x)
qqplot(sparrow$Mass, x,main= "t(3) Q-Q Plot", ylab = "Sample Quantiles")
abline(0,1)

#sws lecture 4

rm(list=ls())
graphics.off()

d = read.table("../Data/SparrowSize.txt", header=TRUE)

Bill_mean = mean(d$Bill, na.rm = TRUE)
Bill_var = var(d$Bill, na.rm = TRUE) 
Bill_sd = sd(d$Bill, na.rm = TRUE)
mass_mean = mean(d$Mass, na.rm = TRUE)
mass_var = var(d$Mass, na.rm = TRUE)
mass_sd = sd(d$Mass, na.rm = TRUE)
wing_mean = mean(d$Wing, na.rm = TRUE)
wing_var = var(d$Wing, na.rm = TRUE) 
wing_sd = sd(d$Wing, na.rm = TRUE)

d2 = subset(d, d!= "NA")

#calculating standard error
Bill_se = Bill_sd/sqrt(length(d2$Bill))
Mass_se = mass_sd/sqrt(length(d2$Mass))
Wing_se = wing_sd/sqrt(length(d2$Wing))

#calcuating standard error for subset
d1 <- subset(d2, d2$Year==2001)

Bill_se_2001 = Bill_sd/sqrt(length(d1$Bill))
Mass_se_2001 = mass_sd/sqrt(length(d1$Mass))
Wing_se_2001 = wing_sd/sqrt(length(d1$Wing))

#calculating 95%CI
qnorm(c(0.025,0.975))
CI_Bill = c((Bill_mean -(Bill_se*1.96)), (Bill_mean + (Bill_se*1.96)))
CI_Mass = c((mass_mean -(Mass_se*1.96)), (mass_mean + (Mass_se*1.96)))
CI_Wing = c((wing_mean -(Wing_se*1.96)), (wing_mean + (Wing_se*1.96)))
CI_Bill
CI_Mass
CI_Wing


# sws lecture 5

rm(list = ls())
graphics.off()

#Accept or relect H0
N_Tarsus = 1685
SE_Tarsus = 0.02
Mean_Tarsus = 18.52
N_T_2001 = 168
SE_T_2001 = 0.07
Mean_T_2001 = 18.19

CI_T_2001 = c(Mean_T_2001 - (1.96 * SE_T_2001), Mean_T_2001 + (1.96 * SE_T_2001))

CI_T_2001
# reject H0

#T Test!
  
df = 167 # no. of observations - 1

#True mean is = 18.5 H0

TM = 18.5

T_result = (Mean_T_2001 - TM)/ SE_T_2001

p_value = 2*pt(-abs(T_result), 167)
p_value

sparrow = read.table("../Data/SparrowSize.txt", header=TRUE)

d1<- subset(sparrow, sparrow$Year==2001)
t.test(d1$Tarsus, mu=18.5, na.rm = TRUE)

#Male and female mean not equal
t.test(sparrow$Tarsus ~sparrow$Sex, na.rm = TRUE)


#HO 5

wing_length_differ = t.test(d1$Wing, mu = mean(sparrow$Wing, na.rm = TRUE), na.rm = TRUE)

wing_length_differ

wing_length_mf = t.test(d1$Wing ~ d1$Sex, na.rm = TRUE)

wing_length_mf

wing_length_mf_full = t.test(sparrow$Wing~ sparrow$Sex, na.rm = TRUE)

wing_length_mf_full

#sws6

rm(list = ls())

graphics.off()

# DoF effects 

#Type 1 (effect does not exist, but test says it does) and Type 2 (no effect detected, but one does exist) errors


### 5% chance of detecting an 
### effect that does not exist (T1)

#Type  II effects depend  on  statisticalpower . The bigger  the sample size, the smaller the chance for type II errors

library(pwr)
pwr.t.test(d=(0-0.05)/0.96, power = .8, sig.level = 0.05, type = "two.sample", alternative = "two.sided")

#sws - pdf 4
rm(list=ls()) 	

d <- read.table("../Data/SparrowSize.txt",  header=TRUE) 	

d1 <- subset(d,  d$Tarsus!="NA") 	

seTarsus <- sqrt(var(d1$Tarsus)/length(d1$Tarsus)) 	

seTarsus 	

d12001<- subset(d1,  d1$Year==2001) 	

seTarsus2001<- sqrt(var(d12001$Tarsus)/length(d12001$Tarsus)) 	

seTarsus2001 	


# pdf 5 - Hypothesis testing

boxplot(d$Mass~d$Sex.1,  col  =  c("red",  "blue"),  ylab="Body  mass  (g)") 	

#Is this plot showing significant results?
t.test1  <-  t.test(d$Mass~d$Sex.1) 	

t.test1 	



