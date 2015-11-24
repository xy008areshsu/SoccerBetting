# coding=gbk
import pandas as pd
import numpy as np
import os
import os.path
import shutil
import glob

rootdir = '../data/'


df_result = pd.read_csv(rootdir+'result.csv', sep=',')
"""求赔率平均值"""
df = df_result.iloc[:,20:41]
list=[]
df = df.T
for i in range(0, df.shape[0],3):
    list.append('a')
    list.append('b')
    list.append('c')
df['name']=pd.Series(list, index=df.index)
grouped =df.groupby('name')
grouped =grouped.mean().T

#赔率差值
threshold = 1

df_result.loc[(((grouped["a"]-grouped["c"])>=threshold)==True) & ((df_result["FTHG"]>df_result["FTAG"])==True), 'upsetx']= 1
df_result.loc[(((grouped["a"]-grouped["c"])<=-threshold)==True) & ((df_result["FTHG"]<df_result["FTAG"])==True), 'upsetx']= 1
df_result.loc[(((grouped["a"]-grouped["c"])>=threshold)==True) & ((df_result["FTHG"]==df_result["FTAG"])==True), 'upsetx']= 1
df_result.loc[(((grouped["a"]-grouped["c"])<=-threshold)==True) & ((df_result["FTHG"]==df_result["FTAG"])==True), 'upsetx']= 1
df_result['upsetx']=df_result['upsetx'].fillna(0)

df_result.to_csv(rootdir+'result.csv', encoding='utf-8', index=False)


