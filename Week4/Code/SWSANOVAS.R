#SWS ANOVAS

rm(list=ls())
d <- read.table("../Data/SparrowSize.txt",  header=TRUE)

d1 <- subset(d, d$Wing!= "NA") #creating new df without NAs in Wing
summary((d1$Wing))
hist(d1$Wing)

model1 <- lm(Wing~Sex.1, data = d1) #creating  a lm of Sex effect on Wing size
summary(model1)
boxplot(d1$Wing~d1$Sex.1,  ylab="Wing  length  (mm)")
anova(model1) #ANOVAS test whether variation within groups is smaller than the variation between/amoung groups
t.test(d1$Wing~d1$Sex.1,  var.equal=TRUE)


boxplot(d1$Wing~d1$BirdID,  ylab="Wing  length  (mm)") # doesn't make much sense yet

require(dplyr) 	

d$Mass %>% cor.test(d$Tarsus, na.rm= TRUE) # piping from dplyr allows for shorter code! Testing correlation between Mass and Tarsus length
d1  %>%   	#Taking data
  
  group_by(BirdID)  %>% 	#grouping by BirdID
  
  summarise  (count=length(BirdID)) # summarising data, how many counts for each ID


count(d1,  BirdID)  #Same output as above, but count is a funct this time, not able to do : count(d1,  d1$BirdID)  %>% 	count(count) 	as the name would clash with function


d1  %>%   	
  
  group_by(BirdID)  %>% 	
  
  summarise  (count=length(BirdID))    %>% 	
  
  count(count) 	#counting number of counts, i.e. 1 appears most..

model3 <- lm(Wing~as.factor(BirdID),  data=d1) 	

anova(model3) 	# T- test is about estimates, difference in size. ANOVA is diff in var amoung vs within. 

boxplot(d$Mass~d$Year) # bird weight over years

m2<-lm(d$Mass~as.factor(d$Year)) 	

anova(m2) 	#is a variation (sig) amoung years, but which ones? do summary
summary(m2)



# Excercise:
d2 = subset(d, d$Year!="2000")

model4 <- lm(Mass ~ as.factor(Year), data = d2)
anova(model4)  #Excluding the year 2000 results in no sig diff, 2000 was likely to be a recording/ human error , or possibly equiptment error
summary(model4)


# Anovas and repeatablity
rm(list=ls())

d <- read.table("../Data/SparrowSize.txt",  header=TRUE)

d1<-subset(d,  d$Wing!="NA") 	

model3<-lm(Wing~as.factor(BirdID),  data=d1) 	

anova(model3) 	

library(dplyr)
count(d1,  BirdID) #working out n1, n2 etc

d1  %>% 
  group_by(BirdID)  %>%
  summarise(count = length(BirdID)) %>%
    summarise(length(BirdID)) #working out a


# Excercise:

 d2 <- subset(d, d$Mass!="NA")

 
 d2 %>%
   group_by(BirdID) %>%
   summarise (count = length(Mass)) %>%
   summarise (sum(count^2))
 
a = 633
d = 1704
sn = 7226
n0 = (1/(a -1)) * (d - (sn/d))

model5 <- lm(Mass~as.factor(BirdID), data = d2)
model5a <- anova(model3)
sa <- (model5a$`Mean Sq`[1] - model5a$`Mean Sq`[2]) / n0
sw <- model5a$`Mean Sq`[2]
rep <- sa / (sw + sa)
percentrep <- rep * 100
