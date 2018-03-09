
require(package = "ggplot2")
require(grid)
k = 8.6173303e-05

df = read.csv("../Data/Feeding_data.csv")
df

df2 = read.csv("../Data/Respiration_data.csv")
df2

legends2 = c("B0 = 0.03\n Ea = 0.99\n  Eh = 1.8\n Tpk =25","B0 = 0.03\n Ea = 0.96\n  Eh = 2.3\n  Tpk = 29",
             "B0 = 0.01\n Ea = 0.89\n  Eh = 2.2\n Tpk = 34","B0 = 0.02\n Ea = 0.60\n  Eh = 4.1\n Tpk = 37",
             "B0 = 0.015\n Ea = 0.88\n  Eh = 2.1\n  Tpk = 31","B0 = 0.03\n Ea = 0.99    \n  Eh = 2.2  \n  Tpk = 28  ",
             "B0 = 0.02\n Ea = 0.99 \n  Eh = 2.2\n  Tpk = 32")
legend = data.frame(x = rep(15,7), y = rep(0.22,7), stream_temp = c(5.6,8.1,9.6, 13.2,13.9,14.4,19.3), legends = legends2)

new_df = df2[which(df2$exp_temp < 31),]
new_df

schoolfield5 = function(x) (0.029 * exp(((-0.99)/k) * (1/(x +273.15) - 1/283.15))/
   (1 + exp((1.8/k) * (1/298 - (1/(x + 273.15))))))
schoolfield8 = function(x) (0.026 * exp(((-0.96)/k) * (1/(x + 273.15) - 1/283.15))/
    (1 + exp((2.3/k) * (1/302 - (1/(x + 273.15))))))
schoolfield9 = function(x) (0.013 * exp((-0.89/k) * (1/(x + 273.15) - 1/283.15)))/
    (1 + exp((2.2/k) * (1/307 - 1/(x + 273.15))))
schoolfield132 = function(x) (0.018 * exp((-0.60/k) * (1/(x + 273.15) - 1/283.15)))/
    (1 + exp((4.1/k) * (1/310 - 1/(x + 273.15))))
schoolfield139 = function(x) (0.015 * exp((-0.88/k) * (1/(x + 273.15) - 1/283.15)))/
    (1 + exp((2.1/k) * (1/304 - 1/(x + 273.15))))    
schoolfield14 = function(x) (0.026 * exp((-0.99/k) * (1/(x + 273.15) - 1/283.15)))/
    (1 + exp((2.2/k) * (1/301 - 1/(x + 273.15))))    
schoolfield19 = function(x) (0.021* exp((-0.99/k) * (1/(x + 273.15) - 1/283.15)))/
    (1 + exp((2.2/k) * (1/305 - 1/(x + 273.15))))    
    
resp_full_plot = ggplot(df2, aes(x =  exp_temp, y = mass_resp, color = stream_temp)) + geom_point() + facet_wrap(~stream_temp, nrow = 2) + 
    ylab(expression(paste("Mass Corrected Oxygen Consumption (",mu,"m/h)"))) + 
    xlab(expression(paste("Experimental Temperature (", ~degree ~C,")"))) +  
    stat_function(dat = subset(df2, stream_temp == 13.2), fun = schoolfield132) + stat_function(dat = subset(df2, stream_temp == 5.6), fun = schoolfield5) + 
    stat_function(dat = subset(df2, stream_temp == 8.1), fun = schoolfield8) + stat_function(dat = subset(df2, stream_temp == 9.6), fun = schoolfield9) + 
    stat_function(dat = subset(df2, stream_temp == 13.9), fun = schoolfield139) + stat_function(dat = subset(df2, stream_temp == 14.4), fun = schoolfield14) + 
    stat_function(dat = subset(df2, stream_temp == 19.3), fun = schoolfield19) +
    theme(legend.title = element_text(face="bold"))+
    scale_color_continuous(name=(expression(paste("Acclimatization Temperature (", ~degree ~C,")")))) +
    geom_text(aes(x, y, label=legends, group=NULL), size = 2, data=legend)
resp_full_plot 

ggsave("../Results/Schoolfield_plots.eps", height = 5, width = 6.4)
ggsave("../Results/Schoolfield_plots.pdf", height = 5, width = 6.4)
    
new_df$stream_temp_fact = factor(new_df$stream_temp, labels = c(5.6,8.1,9.6,13.2,13.9,14.4,19.3))

#print(new_df$stream_temp_fact)
    
    
lmresp <- lm(log_mass_resp ~ stream_temp_fact * exp_temp, data = subset(new_df, exp_temp < 31))    
summary(lmresp)
anova(lmresp) 
new_df2 = subset(new_df, exp_temp < 31)
avresp <- aov(new_df2$log_mass_resp ~ new_df2$stream_temp_fact * new_df2$exp_temp)
posthoc <- TukeyHSD(x=avresp,"new_df2$stream_temp_fact", conf.level=0.95)
   
posthoc
    

ggplot(new_df, aes(y = log_mass_resp, x = exp_temp, colour = stream_temp_fact )) + geom_boxplot() + scale_colour_discrete(name =(expression(paste("Acclimatization Temperature (", ~degree ~C,")")))) +
    xlab("Experimental Temperature") + ylab(expression(paste("Mass Corrected Oxygen Consumption (",mu,"m/h)"))) 

legends = c("a = -9.1e-07\nb = -1.7e-04\nc = 0.0115\nd = -0.066",
            "a = -8.33e-06\nb = 3.13e-04\nc = 0.0033\nd = -0.024     ",
          "a = -1.27e-05\nb = 7.9e-04\nc = -0.011\nd = 0.0481",
          "a = -1.275e-05\nb = 8e-04\nc = -0.0111\nd = 0.059",
            "a = -1.1016e-05\nb = 6e-04\nc = -0.0071\nd = 0.0302",
          "a = -6.96e-06\nb = 1.6e-04\nc = 0.008      \nd = -0.062   ",
          "a = -1.13e-05\nb = 6e-04\nc = -0.0027\nd = -0.002  ")



legend = data.frame(x = c(17,20,19,21,21,17.9,18), y = c(0.21, 0.209, 0.21,0.21,0.21,0.215, 0.195), stream_temp = c(5.6,8.1,9.6, 13.2,13.9,14.4,19.3), legends = legends)

cubic_132 = function(x) -1.275e-05*(x^3) + (0.0008*x^2) - 
                    (0.0111*x) + 0.059
cubic_5 = function(x) -9.113e-07*(x^3) - 1.7e-04*(x^2) + 
                    (0.0115*x) - 0.066
cubic_8 = function(x) - 8.33e-06*(x^3) + 0.000313*(x^2) +
                    (0.0033*x) - 0.024
cubic_9 = function(x) - 1.27e-05*(x^3) + 0.00079*(x^2) -
                    (0.011*x) + 0.0481
cubic_139 = function(x) -1.1016e-05*(x^3) + 0.000637*(x^2) - 
                    (0.0071*x) + 0.03015
cubic_14 = function(x) -6.96e-06*(x^3) + 0.00016*(x^2) + 
                    (0.0077*x) - 0.062
cubic_193 = function(x) -1.13e-05*(x^3) + 0.0006*(x^2) -
                    (0.0027*x) - 0.002
resp_full_plot2 = ggplot(df2, aes(x =  exp_temp, y = mass_resp, color = stream_temp)) + geom_point() + facet_wrap(~stream_temp, nrow = 2) + 
    stat_function(dat = subset(df2, stream_temp == 13.2), fun = cubic_132) + stat_function(dat = subset(df2, stream_temp == 5.6), fun = cubic_5) + 
    stat_function(dat = subset(df2, stream_temp == 8.1), fun = cubic_8) + stat_function(dat = subset(df2, stream_temp == 9.6), fun = cubic_9) + 
    stat_function(dat = subset(df2, stream_temp == 13.9), fun = cubic_139) + stat_function(dat = subset(df2, stream_temp == 14.4), fun = cubic_14) + 
    stat_function(dat = subset(df2, stream_temp == 19.3), fun = cubic_193) + ylab(expression(paste("Mass Corrected Oxygen Consumption (",mu,"m/h)"))) + 
    xlab(expression(paste("Experimental Temperature (", ~degree ~C,")"))) + theme(legend.title = element_text(face="bold"))+
    scale_color_continuous(name=(expression(paste("Acclimatization Temperature (", ~degree ~C,")"))))# +
    #geom_text(aes(x, y, label=legends, group=NULL), size = 2, data=legend)#, parse = T)

    
resp_full_plot2 
    
ggsave("../Results/cubic_plots.eps", height = 5.5, width = 6.4)
ggsave("../Results/cubic_plots.pdf", height = 5.5, width = 6.4)

feed_full_plot = ggplot(df, aes(x =  exp_temp, y = log_mass_feed, color = stream_temp_fact)) + geom_point()  + 
    stat_smooth(dat = subset(df, stream_temp == 9.6), method = "lm", se = FALSE) +
    stat_smooth(dat = subset(df, stream_temp == 14.4), method = "lm", se = FALSE) +
    stat_smooth(dat = subset(df, stream_temp == 19.3), method = "lm", se = FALSE) +
   ylab(expression(paste("Ln Mass Corrected Feeding rate (mg ",m^-2," ", hr^-1,")"))) + 
    xlab(expression(paste("Experimental Temperature (", ~degree ~C,")"))) + theme(legend.title = element_text(face="bold"))+
    scale_color_discrete(name=(expression(paste("Acclimatization Temperature (", ~degree ~C,")"))))
feed_full_plot

df$stream_temp_fact = factor(df$stream_temp_fact, labels = c("cold","tepid","warm"))
#levels(df$stream_temp_fact)
#feeding_model = lm(log_mass_feed~exp_temp, data = df)
#feeding_model
#anova(feeding_model)
acc_on_feed_model = lm(log_mass_feed~exp_temp*stream_temp_fact, data = df)
anova(acc_on_feed_model)
ggsave("../Results/meancorrectedfeeding_vs_exp_acctemp.eps" , height = 4.5, width = 6)
ggsave("../Results/meancorrectedfeeding_vs_exp_acctemp.pdf" , height = 4.5, width = 6)



acc_feed_model = lm(log_feeding~exp_temp*stream_temp_fact, data = df)
anova(acc_feed_model)

ener_full_plot = ggplot(df, aes(x =  exp_temp, y = En_Eff, color = stream_temp_fact)) + geom_point(shape=1) + facet_wrap(~stream_temp, ncol = 1) + 
                stat_smooth(method = "lm", se = FALSE) + ylab(expression(paste("Energetic Efficiency (",gamma,")"))) + 
    xlab(expression(paste("Experimental Temperature (", ~degree ~C,")"))) + theme(legend.title = element_text(face="bold"))+
    scale_color_discrete(name=(expression(paste("Acclimatization Temperature (", ~degree ~C,")")))) 
ener_full_plot
ggsave("../Results/eneff_vs_accexptemp.eps", height = 5.5, width = 6.4)

model_feed = lm(En_Eff~exp_temp, data = df)
summary(model_feed)

#boxplot(df$En_Eff~df$exp_temp)


EnExp_full_plot = ggplot(df, aes(x =  exp_temp, y = En_Eff, colour = exp_temp)) + geom_boxplot(aes(group = exp_temp)) + 
     ylab(expression(paste("Energetic Efficiency(",gamma,")"))) + 
    xlab(expression(paste("Experimental Temperature (", ~degree ~C,")"))) + theme(legend.title = element_text(face="bold"))+
    scale_color_continuous(name=(expression(paste("Experimental Temperature (", ~degree ~C,")")))) + theme(legend.position="none")
EnExp_full_plot

anova(model_feed)
ggsave("../Results/eneff_vs_exptemp.eps", height = 5.5, width = 6)

model_acc = lm(Log_Eneff_Mass~stream_temp_fact*exp_temp, data = df)
model_acc

#boxplot(Log_Eneff_Mass~stream_temp, data = df)

Log_massen_full_plot = ggplot(df, aes(x =  stream_temp, y = Log_Eneff_Mass, colour = stream_temp_fact)) + geom_boxplot(aes(group = stream_temp)) + 
     ylab(expression(paste("Ln Mass Corrected Energetic Efficiency(",gamma,")"))) + 
    xlab(expression(paste("Acclimatization Temperature (", ~degree ~C,")"))) + theme(legend.title = element_text(face="bold"))+
    scale_color_discrete(name=(expression(paste("Acclimatization Temperature (", ~degree ~C,")")))) + theme(legend.position="none")
Log_massen_full_plot

ggsave("../Results/meancorrectedeneff_vs_acctemp.eps", height = 4, width = 4)
ggsave("../Results/meancorrectedeneff_vs_acctemp.pdf", height = 4, width = 4)

model_acc_an = aov(df$Log_Eneff_Mass~df$stream_temp_fact)
summary(model_acc_an)

posthoc <- TukeyHSD(x=model_acc_an)
posthoc

model_accen_mass = lm(Log_Eneff_Mass~stream_temp_fact*exp_temp, data = df)

summary(model_accen_mass)

model_accen = lm(Log_Eneff~stream_temp_fact*exp_temp, data = df)

anova(model_accen)

   
par(mfrow=c(1,2))

ggplot(df, aes(x =  exp_temp, y = Log_Eneff_Mass, colour = stream_temp_fact)) + geom_point() + 
    stat_smooth(dat = subset(df, stream_temp == 9.6), method = "lm", se = FALSE) +
    stat_smooth(dat = subset(df, stream_temp == 14.4), method = "lm", se = FALSE) +
    stat_smooth(dat = subset(df, stream_temp == 19.3), method = "lm", se = FALSE) +
     ylab(expression(paste("Ln Mass Corrected Energetic Efficiency(",gamma,")"))) + 
    xlab(expression(paste("Experimental Temperature (", ~degree ~C,")"))) + theme(legend.title = element_text(face="bold"))+
    scale_color_discrete(name=(expression(paste("Acclimatization Temperature (", ~degree ~C,")"))))

ggsave("../Results/meancorrectedeneff_vs_expacctemp.eps", height = 4.5, width = 6)
ggsave("../Results/meancorrectedeneff_vs_expacctemp.pdf", height = 4.5, width = 6)

ggplot(df, aes(x =  exp_temp, y = Log_Eneff, colour = stream_temp_fact)) + geom_point() + 
    stat_smooth(dat = subset(df, stream_temp == 9.6), method = "lm", se = FALSE) +
    stat_smooth(dat = subset(df, stream_temp == 14.4), method = "lm", se = FALSE) +
    stat_smooth(dat = subset(df, stream_temp == 19.3), method = "lm", se = FALSE) +
     ylab(expression(paste("Ln Energetic Efficiency"))) + 
    xlab(expression(paste("Experimental Temperature (", ~degree ~C,")"))) + theme(legend.title = element_text(face="bold"))+
    scale_color_discrete(name=(expression(paste("Acclimatization Temperature (", ~degree ~C,")"))))

ggsave("../Results/lneneff_vs_expacctemp.eps", height = 5.5, width = 6.4)

anova(model_accen_mass)
anova(model_accen)



ggplot(df2[1:270,], aes(x = exp_temp, y = mass_resp, colour = mass_resp)) + geom_point(size = 0.00002) + 
    theme(axis.ticks.y = element_blank(),axis.text.y = element_blank()) + 
    theme(axis.ticks.x = element_blank(),axis.text.x = element_blank()) + 
    xlab("Temperature") + ylab("Trait response") + 
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(), axis.line = element_line(colour = "black")) + 
    geom_jitter(width = 0.30) + theme(legend.position = "none" )


ggsave("../Results/example_TPC.pdf", height = 3, width = 3)






















































