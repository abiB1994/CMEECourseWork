#Day 3 + 4 sws

rm(list=ls())
d <- read.table("../Data/SparrowSize.txt",  header=TRUE) 	


boxplot(d$Mass~d$Sex.1,  col  =  c("red",  "blue"),  ylab="Body  mass  (g)") 	

t.test1  <-  t.test(d$Mass~d$Sex.1) 	

t.test1 	


d1<- as.data.frame(head(d,  50)) 	

length(d1$Mass) 	

t.test2  <-  t.test(d1$Mass~d1$Sex) 	

t.test2 	


#sws - 10


plot(d$Mass~d$Tarsus,  ylab="Mass  (g)",  xlab="Tarsus  (mm)",  pch=19,  cex=0.4) 	#plotting a linear model!

x<-c(1:100) 	#Making a linear model plot

b<- 0.5 	

m<-1.5 	

y<-m*x+b 	

plot(x,y,  xlim=c(0,100),  ylim=c(0,100),  pch=19,  cex=0.5) 	

graphics.off()
par(mfrow = c(2,1))
plot(d$Mass~d$Tarsus,  ylab="Mass  (g)",  xlab="Tarsus  (mm)",  pch=19,  cex=0.4,  
     ylim=c(-5,38),  xlim=c(0,22)) 	#Trying to see a potential intercept to calculate y = b + mx
plot(d$Mass~d$Tarsus,  ylab="Mass  (g)",  xlab="Tarsus  (mm)",  pch=19,  cex=0.4) 	


d1<- subset(d,  d$Mass!="NA") 	#Stripping data of NAs
d2<- subset(d1,  d1$Tarsus!="NA") 	

length(d2$Tarsus) 	

model1<- lm(Mass~Tarsus,  data=d2) 	

summary(model1) 	

graphics.off()
hist(model1$residuals)
head(model1$residuals)

model2<-lm(y~x) 	# R-squared of 1, as it's a made up data set 

summary(model2) 	

d2$z.Tarsus<- scale(d2$Tarsus) 	

model3<- lm(Mass~z.Tarsus,  data=d2) 	

summary(model3) 	

plot(d2$Mass~d2$z.Tarsus,  pch=19,  cex=0.4) 	

abline(v  =  0,  lty  =  "dotted") 	#plotting mass in relation to z.Tarsus

head(d2)

str(d)

d$Sex<-as.numeric(d$Sex) 	


par(mfrow  =c(2,  1)) 	
#Testing slope of lm 
plot(d$Wing  ~  d$Sex.1,  ylab="Wing(mm)") 	
plot(d$Wing  ~  d$Sex,  xlab="Sex",  xlim=c(-0.1,1.1),  ylab="") 	
abline(lm(d$Wing  ~  d$Sex),  lwd  =  2) 	
text(0.15,  76,  "intercept") 	
text(0.9,  77.5,  "slope",  col  =  "red") 	

#t-test for Wing~sex on linear models

d4 <- subset(d, d$Wing!="NA")
m4<- lm(Wing~Sex, data = d4)
t4 <- t.test(d4$Wing~d4$Sex, var.equal = TRUE)
?t.test
summary(m4)
t4


par(mfrow=c(2,2))
plot(model3) # Mass against tarsus


par(mfrow=c(2,2))
plot(m4)
