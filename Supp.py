#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np


# In[2]:


import matplotlib.pyplot as plt
import seaborn as sns
get_ipython().run_line_magic('matplotlib', 'inline')


# In[3]:


train = pd.read_csv('titanic_train.csv')


# In[4]:


train.head()


# In[13]:


sns.countplot(x='Survived',data=train, hue='Pclass')


# In[28]:


plt.figure(figsize=(10,7))
sns.boxplot(x='Pclass',y='Age',data=train)


# In[29]:


train.groupby('Pclass').mean()['Age']


# In[30]:


def impute_age(cols):
    Age = cols[0]
    Pclass = cols[1]
    
    if pd.isnull(Age):
        
        if Pclass == 1:
            return 38
        elif Pclass == 2:
            return 30
        else:
            return 25
    else:
        return Age


# In[31]:


train['Age'] = train[['Age', 'Pclass']].apply(impute_age,axis=1)


# In[33]:


sns.heatmap(train.isnull(),yticklabels=False,cbar=False,cmap='viridis')

