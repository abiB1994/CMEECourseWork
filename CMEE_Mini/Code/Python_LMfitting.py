# !/usr/bin/env python


__author__ = "Abigail Baines a.baines17@imperial.ac.uk"
__version__ = '0.0.5'

# Let printing work the same in Python 2 and 3
from __future__ import print_function
import statsmodels.formula.api as smf
from sklearn.linear_model import LinearRegression as LR
from scipy.constants import physical_constants as phy
import random
import subprocess
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from lmfit import minimize, Parameters, Parameter, report_fit, Model
import statsmodels.api as ap
import seaborn as sns
sns.set(color_codes = True)
np.random.seed(1974)
ev = phy["joule-electron volt relationship"]
bolts = phy["Boltzmann constant in eV/K"]
k = bolts[0]

random.seed(1)


#Importing DF


filename = '../Data/snail_respiration_BK.csv'
try:
    df1 = pd.read_csv(filename, sep =',')
    print("working from within Code directory!")
except FileNotFoundError: 
    df1 = pd.read_csv(filename[3:], sep = ",")
    print("Working outside the Code directory!")

df1["stream_temp"] = df1["stream_temp"].astype(str)

new_df = df1[["stream", "stream_temp", "exp_temp", "mass","resp"]]
df1


# # Adding new columns to df


workingdf = new_df.assign(Exp_Temp_K = new_df["exp_temp"] + 273.15)
workingdf = workingdf.assign(log_resp = lambda x: np.log((x.resp)))
workingdf = workingdf.assign(mass_g = lambda x: x["mass"]/1000)
workingdf = workingdf.assign(x1 = lambda x: ((x["Exp_Temp_K"] - 290.65)/(k*x["Exp_Temp_K"]*290.65)))
workingdf = workingdf.assign(x2 = lambda x: (1/(k * x["Exp_Temp_K"]) ))
workingdf = workingdf.assign(log_mass_resp = lambda x: np.log(x["resp"] * (x["mass"]**(-3./4))))
workingdf = workingdf.assign(lnmass = lambda x: np.log(x["mass"]))
workingdf = workingdf.assign(mass_resp = lambda x: x["resp"] * (x["mass"]**(-3./4)))
workingdf = workingdf.dropna()
new_df = workingdf
workingdf = workingdf[(workingdf["exp_temp"] <= 30)]

M = workingdf["mass_g"]
T = workingdf["Exp_Temp_K"] 
b = 0.75
power = (k * T)
#workingdf = workingdf.loc[(workingdf["exp_temp"] < 31) & (workingdf["exp_temp"] > 14)]
workingdf


# # Linear Regression

# ## On T - t0/ kTT0

# In[56]:

print("Statsmodel.Formula.Api Method")
model1 = smf.ols(formula='log_resp ~ x1', data=workingdf).fit()
print(model1.params)
model1.summary()
print("\nThe aic of this model is: ", model1.aic, "\nand the bic is: ", model1.bic)


# In[57]:

#sns.stripplot(x='x1', y='log_resp', data= workingdf, jitter=True) 
plt.scatter("x1", "log_resp", data=workingdf,  marker='x')
plt.plot(workingdf["x1"], model1.params[0] + workingdf["x1"]*model1.params[1], color='red')
plt.ylabel('Log Respiration rate')
plt.xlabel('t - t0/ k t t0')
plt.show()

p = sns.lmplot(x = "exp_temp", y = "log_resp", data= workingdf, x_jitter= 0.7)


# In[71]:

y1 = (workingdf["log_resp"]).values.reshape(-1,1)
x1 = (workingdf["x1"]).values.reshape(-1,1)

print("Sci-Kit Learn Method")
model2 = LR()
model2.fit(x1, y1)
print(model2.coef_[0][0])
print(model2.intercept_[0])

aov_table1 = ap.stats.anova_lm(model1, typ=2)
print(aov_table1)


# ## 1/kt

# In[40]:

print("Statsmodel.Formula.Api Method")
model3 = smf.ols(formula='log_resp ~ x2', data=workingdf).fit()
print(model3.params)
model3.summary()
print("\nThe aic of this model is: ", model3.aic, "\nand the bic is: ", model3.bic)


# In[41]:

#sns.stripplot(x='x1', y='log_resp', data= workingdf, jitter=True) 
plt.scatter("x2", "log_resp", data=workingdf,  marker='x')
plt.plot(workingdf["x2"], model3.params[0] + workingdf["x2"]*model3.params[1], color='red')
plt.ylabel('Log Respiration rate')
plt.xlabel('1/KT')
plt.show()



# In[98]:




# ## x2 on log_resp_mass

# ln(resp * mass ^ -3/4) = ln(B0) - E (1/kT)

# In[60]:

print("Statsmodel.Formula.Api Method")
model4 = smf.ols(formula='log_mass_resp ~ x2', data=workingdf).fit()
print(model4.params)
model4.summary()
print("\nThe aic of this model is: ", model4.aic, "\nand the bic is: ", model4.bic)


# In[44]:

#sns.stripplot(x='x1', y='log_resp', data= workingdf, jitter=True) 
plt.scatter("x2", "log_mass_resp", data=workingdf,  marker='x')
plt.plot(workingdf["x2"], model4.params[0] + workingdf["x2"]*model4.params[1], color='red')
plt.ylabel('Log Mass Respiration rate')
plt.xlabel('1/KT')
plt.show()



# # ln(mass) by ln(I e ^ (E/kt))

# In[45]:

workingdf = workingdf.assign(lnIEkt = lambda x: np.log((x.resp) * np.exp(model4.params[1]/(k *workingdf["Exp_Temp_K"]))))
lnm, lnE = workingdf["lnmass"].values.reshape(-1,1) , workingdf["lnIEkt"].values.reshape(-1,1)
workingdf


# In[132]:

print("Statsmodel.Formula.Api Method")
model5 = smf.ols(formula='lnIEkt ~ lnmass', data=workingdf).fit()
print(model5.params)
model5.summary()
print("\nThe aic of this model is: ", model5.aic, "\nand the bic is: ", model5.bic)


# In[133]:

plt.scatter("lnmass", "lnIEkt", data=workingdf,  marker='x')
plt.plot(lnm, model5.params[0] + lnm*model5.params[1], color='red')
plt.ylabel('Ln(IeEkt)')
plt.xlabel('ln(mass)')
plt.show()


# # Groupby

# In[88]:

grouped = workingdf.groupby("stream_temp")
model_acc_exp = smf.ols(formula="log_mass_resp ~ x2*stream_temp", data= workingdf).fit()

aov_table2 = ap.stats.anova_lm(model_acc_exp, typ=2)
print(aov_table2)


# In[47]:

for name, group in grouped:
    #print("Statsmodel.Formula.Api Method")
    modelgroup = smf.ols(formula='log_mass_resp ~ x2', data=group).fit()
    y = modelgroup.params[0] + (modelgroup.params[1] * group.x2)
    print("\n", modelgroup.summary())
    print("\n" ,modelgroup.params)
    print("\nStream Temp: ",name)
    print("\nThe aic of this model is: ", modelgroup.aic, "\nand the bic is: ", modelgroup.bic)
    group.plot.scatter(x = "x2", y = "log_mass_resp", marker = "x", title = name)
    plt.plot(group.x2, y, "r" )
    plt.show()


# In[48]:

averageint = (22.436 + 31.262 + 38.583 + 40.461 + 30.283 + 35.810 + 33.344) / 7
averagecoef = -(0.52 + 0.74 + 0.923 + 0.97 + 0.715 + 0.843 + 0.8) / 7
print(averagecoef, averageint)


# # NLLS

# ## Groupby

# In[ ]:

def schoolfield(param, x, workingdf = None):
    E = param["mass_resp_coef"]
    B0 = param["mass_resp_at_10"]
    Eh = param["Eh"]
    Th = param["Temp_H_K"]
    #Tl = param["Temp_L_K"]
    #El = param["Temp_L_K"]
    K = param["boltz"]
    exp1 = ((-E)/K) * (1/x - 1/283.15)
    #print(exp1)
    exp2 = (Eh/K) * (1/Th - 1/x)
    #print(exp2)
    #exp3 = (El/K) * (1/Tl - 1/x)
    #model = (B0 * np.exp(exp1))/(1 + np.exp(exp3) + np.exp(exp2))
    model = (B0 * np.exp(exp1))/(1 + np.exp(exp2))
    
    if workingdf is None:
        return model
    
    return model - workingdf

mass_resp_10 = np.exp(model1.params[0] + (283 - 291)/(k * 283 * 291))
av_mass_resp_10 = np.log(averageint)
print(mass_resp_10)
print(model1.params[1])

last_EH_aic_val = 100000
last_EH_bic_val = 100000
Eh = 1.8

try_params = Parameters()
try_params.add_many(("mass_resp_coef", -(model4.params[1]),True, 0, 1),
               ("mass_resp_at_10", mass_resp_10 ,True),
               ("Eh", Eh, False),# -(model4.params[1]), 5),
               ("Temp_H_K", 303, True, 303, 310),
               #("Temp_L_K", Temp_L_K, True, 273, 283),
               ("boltz", k, False))
               #("El", 0.3, True, -2.0, 2.0))
               #("mass_resp_intercept", mass_resp_intercept_lr, True, 30, 35))

data = new_df.mass_resp.values

x = np.linspace(new_df["Exp_Temp_K"].min(),new_df["Exp_Temp_K"].max(),len(new_df["Exp_Temp_K"]))




#try_params.add("Eh", value =random.uniform(-model4.params[1],5), vary = False)
trying = minimize(schoolfield, try_params, args=(x, data))   
print(trying.success)
# calculate final result
final = data + trying.residual
# write error report
report_fit(trying.params)


# plot the data
plt.scatter(x = "Exp_Temp_K", y =  "mass_resp", marker ='o', color = "r", data=new_df)
plt.plot(x, final, 'g')
plt.show()   
print("AIC value: {0:.2f} \nBIC value: {1:.2f} \nEh Parameter {2}".format(trying.aic, trying.bic, try_params["Eh"]))


# In[53]:

grouped2 = new_df.groupby("stream_temp")

for name, group in grouped2: 
    best_EH_param = 1000
    best_stream = 0

    last_EH_aic_val = 100000
    last_EH_bic_val = 100000
    
    for l in range(1,10000): 
        try:
            x = np.linspace(group["Exp_Temp_K"].min(),group["Exp_Temp_K"].max(),len(group["Exp_Temp_K"]))
            data = group.mass_resp.values
            try_params.add("Eh", value =random.uniform(-model4.params[1],5), vary = False)
            #print(try_params["Eh"])
            trying = minimize(schoolfield, try_params, args=(x, data))   
            #print(trying.success)
            # calculate final result
            final = data + trying.residual
            # write error report
            #report_fit(trying)
            
            #if trying.aic < 300:
            #    fname = "../Results/Plot_sch" + str(l) + "-" + name + ".pdf"
            #    print(fname)
            #    # plot the data
            #    group.plot.scatter(x = "Exp_Temp_K", y =  "mass_resp", marker ='o', color = "r")
            #    #plt.plot(x, data, 'bo')
            #    plt.plot(x, final, 'g')
            #    plt.savefig(fname)
            #    plt.show()

            if (trying.aic < last_EH_aic_val and trying.bic < last_EH_bic_val): 
                best_stream = name
                best_EH_param = try_params["Eh"]
                last_EH_aic_val = trying.aic
                last_EH_bic_val = trying.bic
                best_params = trying.params
                best_r2 = (1 - trying.residual.var() / np.var(data))

            #print("Round: {0} ".format(l))
            #print("The stream temp was: ", name)
            #print("AIC value: {0:.2f} \nBIC value: {1:.2f} \nEh Parameter {2} \nReduced chi value {3:.2f}".format(trying.aic, trying.bic, try_params["Eh"], trying.redchi))
            #print("The best EH value so far: ", best_EH_param, "\nand the stream which it was from: ", best_stream, 
            #      "\nThe aic of that: ", last_EH_aic_val,
            #      "\nand the bic of that: ", last_EH_bic_val)
            #return(best_EH_param, last_EH_aic_val, last_EH_bic_val)   
            #print("-----------------------\n-----------------------")
            #with open(("../Results/Output_sch" + str(l) + "-" + name + ".txt"), "w") as text_file:
            #    print("Round: {0} ".format(l), file = text_file)
            #    print("The stream temp was: {0} ".format(name), file = text_file)
            #    print("AIC value: {0:.2f} \nBIC value: {1:.2f} \nEh Parameter {2} \nReduced chi value: {3:.2f}".format(trying.aic, trying.bic, try_params["Eh"], trying.redchi),file = text_file)
            #text_file.close()
        except:
            print("this didn't work")
    with open(("../Results/Best_values" + name + ".txt"), "w") as text_file: 
        print(best_stream, best_EH_param, last_EH_aic_val, last_EH_bic_val,best_params, best_r2, file=text_file)
    text_file.close()
    print("The final values: \nThe stream temp: ",best_stream, "\nand the EH value: ", best_EH_param, "\nthe aic value: ",
          last_EH_aic_val, "\nfinally, the bic value: ",last_EH_bic_val, best_r2, "R-squared", best_params)
    print("-----------------------\n-----------------------")


# In[37]:

def cubic(x, a, b, c, d):
    cubed = a*(x**3)
    squared = b*(x**2)
    model = cubed + squared + (c*x) + d
    
    return model

x_cubic1 = np.linspace(new_df["exp_temp"].min(),new_df["exp_temp"].max(),len(new_df["exp_temp"]))

cModel = Model(cubic)

for name, group in grouped2: 
    try:
        x_cubic = np.linspace(group["exp_temp"].min(),group["exp_temp"].max(),len(group["exp_temp"]))
        data_c = group.mass_resp.values
        trying_cubic = cModel.fit(data_c, x = x_cubic, a = -1.1, b = 0.001, c = 5, d = 0.03)
           
        fname = "../Results/Plot_cubic" + "-" + name + ".pdf"
        plt.plot(group["exp_temp"], group["mass_resp"], 'bo')
        #plt.plot(x_cubic, trying_cubic.init_fit, 'k--')
        plt.plot(x_cubic, trying_cubic.best_fit, 'r-')
        plt.savefig(fname)
        plt.show()
        #print(trying_cubic.residual)
        #print(trying_cubic.values)
        print((1 - trying_cubic.residual.var()/np.var(data_c))) 
        print(trying_cubic.best_values)
        print("Stream temp was: ", name)
        print("The aic was: ", trying_cubic.aic, "\nand the bic was: ", trying_cubic.bic)
        print("------------------------\n------------------------")
    except:
        print("This didn't work")



# In[ ]:




# In[ ]:




# # Now with feeding data
# 

# ## Importing df

# In[9]:


filename2 = '../Data/snail_feeding_EG.csv'
try:
    df2 = pd.read_csv(filename2, sep =',')
    print("working from within Code directory!")
except FileNotFoundError: 
    df2 = pd.read_csv(filename2[3:], sep = ",")
    print("Working outside the Code directory!")


new_df2 = df2[["stream_temp", "exp_temp", "mass","feeding"]]




# In[11]:

# y = t - t0/ k t t0   t0 normally mean of t approx
workingdf2 = new_df2.assign(Exp_Temp_K = new_df2["exp_temp"] + 273.15)
workingdf2 = workingdf2.assign(feeding_new = lambda x: abs(x.feeding))
workingdf2 = workingdf2.assign(log_feeding = lambda x: np.log(x.feeding_new))
workingdf2 = workingdf2.assign(mass_g = lambda x: x["mass"]/1000)
workingdf2 = workingdf2.assign(x1 = lambda x: ((x["Exp_Temp_K"] - 290.65)/(k*x["Exp_Temp_K"]*290.65)))
workingdf2 = workingdf2.assign(x2 = lambda x: (1/(k * x["Exp_Temp_K"]) ))
workingdf2 = workingdf2.assign(log_mass_feed = lambda x: np.log(x["feeding_new"] * (x["mass"]**(-3./4))))
workingdf2 = workingdf2.assign(lnmass = lambda x: np.log(x["mass"]))
workingdf2 = workingdf2.assign(feed_mass = lambda x: x["feeding_new"] * (x["mass"]**(-3./4)))
workingdf2 = workingdf2.dropna()
new_df2 = workingdf2
workingdf2 = workingdf2[(workingdf2["exp_temp"] <= 30)]
workingdf2 = workingdf2[(workingdf2["feeding"] > 0)]
workingdf2 = workingdf2.assign(new_feed = lambda x: x.feeding_new * (x["mass"]**(-3./4)))
workingdf2

#M = workingdf2["mass_g"]
#T = workingdf2["Exp_Temp_K"] 
#b = 0.75
#power = (k * T)
#workingdf = workingdf.loc[(workingdf["exp_temp"] < 31) & (workingdf["exp_temp"] > 14)]


# In[24]:

plotting = sns.lmplot("Exp_Temp_K","feed_mass", data = workingdf2, x_jitter = True)
plt.show()

plt.scatter("Exp_Temp_K","feed_mass", data = workingdf2)
plt.show()


# ## Trying T - t0/ TT0K

# In[25]:

print("Statsmodel.Formula.Api Method")
model6 = smf.ols(formula='log_feeding ~ x1', data=workingdf2).fit()
print(model6.params)
model6.summary()
print("\nThe aic of this model is: ", model6.aic, "\nand the bic is: ", model6.bic)


# In[26]:

#sns.stripplot(x='x1', y='log_resp', data= workingdf, jitter=True) 
plt.scatter("x1", "log_feeding", data=workingdf2,  marker='x')
plt.plot(workingdf2["x1"], model6.params[0] + (workingdf2["x1"]*model6.params[1]), color='red')
plt.ylabel('Log feeding rate')
plt.xlabel('t - t0/ k t t0')
plt.show()

p = sns.lmplot(x = "exp_temp", y = "log_feeding", data= workingdf2, x_jitter= 0.3)


# In[27]:

y11 = (workingdf2["log_feeding"]).values.reshape(-1,1)
x11 = (workingdf2["x1"]).values.reshape(-1,1)

print("Sci-Kit Learn Method")
model7 = LR()
model7.fit(x11, y11)
print(model7.coef_[0][0])
print(model7.intercept_[0])


# ## 1/kt

# In[28]:

print("Statsmodel.Formula.Api Method")
model8 = smf.ols(formula='log_feeding ~ x2', data=workingdf2).fit()
print(model8.params)
model8.summary()
print("\nThe aic of this model is: ", model8.aic, "\nand the bic is: ", model8.bic)

#sns.stripplot(x='x1', y='log_resp', data= workingdf, jitter=True) 
plt.scatter("x2", "log_feeding", data=workingdf2,  marker='x')
plt.plot(workingdf2["x2"], model8.params[0] + workingdf2["x2"]*model8.params[1], color='red')
plt.ylabel('Log Feeding rate')
plt.xlabel('1/KT')
plt.show()


# ## x2 on log_resp_mass

# ln(resp * mass ^ -3/4) = ln(B0) - E (1/kT)

# In[29]:

print("Statsmodel.Formula.Api Method")
model9 = smf.ols(formula='log_mass_feed ~ x2', data=workingdf2).fit()
print(model9.params)
model9.summary()
print("\nThe aic of this model is: ", model9.aic, "\nand the bic is: ", model9.bic)


# In[30]:

#sns.stripplot(x='x1', y='log_resp', data= workingdf, jitter=True) 
plt.scatter("x2", "log_mass_feed", data=workingdf2,  marker='x')
plt.plot(workingdf2["x2"], model9.params[0] + workingdf2["x2"]*model9.params[1], color='red')
plt.ylabel('Log Mass Feeding rate')
plt.xlabel('1/KT')
plt.show()


# # ln(mass) by ln(I e ^ (E/kt))
# 

# In[31]:

def f(row):
    if row['exp_temp'] < 14:
        val = 1
    elif row['exp_temp'] < 21:
        val = 2
    else:
        val = 3
    return val

workingdf2 = workingdf2.assign(lnIEkt = lambda x: np.log((x.feeding_new) * np.exp(model9.params[1]/(k *workingdf2["Exp_Temp_K"]))))
lnm, lnE = workingdf2["lnmass"].values.reshape(-1,1) , workingdf2["lnIEkt"].values.reshape(-1,1)
workingdf2["Temps"] = workingdf2.apply(f, axis = 1)
workingdf2




# In[32]:

print("Statsmodel.Formula.Api Method")
model10 = smf.ols(formula='lnIEkt ~ lnmass', data=workingdf2).fit()
print(model10.params)
model10.summary()
print("\nThe aic of this model is: ", model10.aic, "\nand the bic is: ", model10.bic)

plt.scatter("lnmass", "lnIEkt", data=workingdf2,  marker='x')
plt.plot(lnm, model10.params[0] + lnm*model10.params[1], color='red')
plt.ylabel('Ln(IeEkt)')
plt.xlabel('ln(mass)')
plt.show()


# # Groupby

# In[33]:


grouped_feed = workingdf2.groupby("stream_temp")
workingdf2


# ## Feeding

# In[34]:

for name, group in grouped_feed:
    #print("Statsmodel.Formula.Api Method")
    modelgroup = smf.ols(formula='log_mass_feed ~ x2', data=group).fit()
    y = modelgroup.params[0] + (modelgroup.params[1] * group.x2)
    print("\n", modelgroup.summary())
    print("\n" ,modelgroup.params)
    print("\nStream Temp: ",name)
    print("\nThe aic of this model is: ", modelgroup.aic, "\nand the bic is: ", modelgroup.bic)
    group.plot.scatter(x = "x2", y = "log_mass_feed", marker = "x", title = name)
    plt.plot(group.x2, y, "r" )
    plt.show()


# In[35]:

for name, group in grouped_feed:
    #print("Statsmodel.Formula.Api Method")
    modelgroup = smf.ols(formula='feeding_new ~ exp_temp', data=group).fit()
    y = modelgroup.params[0] + (modelgroup.params[1] * group.exp_temp)
    print("\n", modelgroup.summary())
    print("\n" ,modelgroup.params)
    print("\nStream Temp: ",name)
    print("\nThe aic of this model is: ", modelgroup.aic, "\nand the bic is: ", modelgroup.bic)
    group.plot.scatter(x = "exp_temp", y = "feeding_new", marker = "x", title = name)
    plt.plot(group.exp_temp, y, "r" )
    plt.show()
    
 


# In[36]:


for name, group in grouped_feed:
 #print("Statsmodel.Formula.Api Method")
 modelgroup = smf.ols(formula='log_mass_feed ~ exp_temp', data=group).fit()
 y = modelgroup.params[0] + (modelgroup.params[1] * group.exp_temp)
 print("\n", modelgroup.summary())
 print("\n" ,modelgroup.params)
 print("\nStream Temp: ",name)
 print("\nThe aic of this model is: ", modelgroup.aic, "\nand the bic is: ", modelgroup.bic)
 group.plot.scatter(x = "exp_temp", y = "log_mass_feed", marker = "x", title = name)
 plt.plot(group.exp_temp, y, "r" )
 plt.show()    


# # Energetic Efficiency:
# 
# y = wF/ vI

# In[42]:

w = 0.45
v = 3


I5 = np.exp(model3.params[0] + (model3.params[1] * (1/(k * 278))))
I8 = np.exp(model3.params[0] + (model3.params[1] * (1/(k*(8.5 + 273.15) ))))
I13 = np.exp(model3.params[0] + (model3.params[1] * (1/(k*(13.1 + 273.15) ))))
I18 = np.exp(model3.params[0] + (model3.params[1] * (1/(k*(18 + 273.15) ))))
I20 = np.exp(model3.params[0] + (model3.params[1] * (1/(k*(20 + 273.15) ))))
I27 = np.exp(model3.params[0] + (model3.params[1] * (1/(k*(27.5 + 273.15) ))))
print(I5)

def f(row):
    if row['exp_temp'] == 5.2:
        val = ((w * row["feeding_new"])/(v * I5))
    elif row['exp_temp'] == 8.5:
        val = ((w * row["feeding_new"])/(v * I8))
    elif row["exp_temp"] == 13.1:
        val = ((w * row["feeding_new"])/(v * I13))
    elif row["exp_temp"] == 18.0:
        val = ((w * row["feeding_new"])/(v * I18))
    elif row["exp_temp"] == 20.0:
        val = ((w * row["feeding_new"])/(v * I20))
    else: 
        val = ((w * row["feeding_new"])/(v * I27))        
    return val

workingdf2["En_Eff"] = workingdf2.apply(f, axis = 1)
workingdf2 = workingdf2.assign(Log_Eneff = lambda x: np.log(x["En_Eff"]))
workingdf2["Log_Eneff_Mass"] = np.log(workingdf2["En_Eff"] * (workingdf2["mass"]**-3./4))
workingdf2["En_Mass"] = workingdf2["En_Eff"] * (workingdf2["mass"]**3/4)
print(workingdf2)
grouped_feed = workingdf2.groupby("stream_temp")


# In[43]:

print("Statsmodel.Formula.Api Method")
model11 = smf.ols(formula='Log_Eneff ~ x2', data=workingdf2).fit()
print(model11.params)
model11.summary()
print("\nThe aic of this model is: ", model11.aic, "\nand the bic is: ", model11.bic)

plt.scatter("x2", "Log_Eneff", data=workingdf2,  marker='x')
plt.plot(workingdf2["x2"], model11.params[0] + (workingdf2["x2"]*model11.params[1]), color='red')
plt.ylabel('Logged Energetic Efficiency')
plt.xlabel('1/KT')
plt.show()

print("Statsmodel.Formula.Api Method")
model12 = smf.ols(formula='Log_Eneff_Mass ~ x2', data=workingdf2).fit()
print(model12.params)
model12.summary()
print("\nThe aic of this model is: ", model12.aic, "\nand the bic is: ", model12.bic)

plt.scatter("x2", "Log_Eneff_Mass", data=workingdf2,  marker='x')
plt.plot(workingdf2["x2"], model12.params[0] + (workingdf2["x2"]*model12.params[1]), color='red')
plt.ylabel('Logged Energetic Efficiency and Mass')
plt.xlabel('1/KT')
plt.show()





# In[44]:

for name, group in grouped_feed:
    #print("Statsmodel.Formula.Api Method")
    modelgroup = smf.ols(formula='En_Eff ~ exp_temp', data=group).fit()
    y = modelgroup.params[0] + (modelgroup.params[1] * group.exp_temp)
    print("\n", modelgroup.summary())
    print("\n" ,modelgroup.params)
    print("\nStream Temp: ",name)
    print("\nThe aic of this model is: ", modelgroup.aic, "\nand the bic is: ", modelgroup.bic)
    group.plot.scatter(x = "exp_temp", y = "En_Eff", marker = "x", title = name)
    plt.plot(group.exp_temp, y, "r" )
    
plt.show()


# # Saving dataframes for R

# In[47]:


def stream_fact(row):
    if row["stream_temp"] == 9.6:
        val = "cold"
    elif row["stream_temp"] == 14.4:
        val = "tepid"
    else:
        val = "warm"
    return val



workingdf2["stream_temp_fact"] = workingdf2.apply(stream_fact, axis = 1)
workingdf2["stream_temp"]
workingdf2["stream_temp_fact"]


# In[48]:

new_df.to_csv("../Data/Respiration_data.csv")
workingdf2.to_csv("../Data/Feeding_data.csv")


# In[ ]:

subprocess.Popen("/usr/lib/R/bin/Rscript --verbose R_plotting.r > ../Results/R_plotting.Rout 2> ../Results/R_plotting_errFile.Rout",shell=True).wait()


# In[ ]:




# In[ ]:

workingdf2


# In[ ]:

E = 0.8
K = k
x = 5
Th = 303
B0 = 3.23


# In[ ]:

exp1 = ((-E)/K) * (1/x - 1/283.15)


# In[ ]:

exp2 = (Eh/K) * (1/Th - 1/x)
   
model = (B0 * np.exp(exp1))/(1 + np.exp(exp2))


# In[ ]:

new_df


# In[ ]:




# In[ ]:




# In[ ]:




# In[ ]:




# In[ ]:




# In[ ]:




# In[ ]:




# In[ ]:




# In[ ]:




# In[ ]:




# In[ ]:



