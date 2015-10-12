# coding=gbk
import pandas as pd
import numpy as np
import os
import os.path
import shutil
import glob

def create_dict(fn):
    dict = {}
    with open(fn) as f:

            for each_line in f:
                try:
                    (abbr, description) = each_line.split('=')
                    str(abbr).strip()
                    dict[str(abbr).strip()] = 0
                except ValueError:
                    pass
    return dict

def find_allfiles(dir,suffix):
    li = []
    for root,dirs,files in os.walk(dir):
        for file in files:
            #print(root + os.sep + file)
            if file.split('.')[-1] == suffix :
                li.append(file)
    return li

#删除无关行的同时需要更新字典
def delet_clx(dir, outputdir, list_filenames, li, flag = 0):
    #count_tmp = 0   #判断一个文件里是否有重复列
    for fn in list_filenames:
        try:
            df = pd.read_csv(dir+fn, error_bad_lines=False, sep=',') #添加error_bad_lines=False参数后，'N1_0708.csv'会删掉几行(有多余的fields)
            #count_tmp += 1
            for cl in df.columns:
                if cl not in li:
                    del(df[cl])
                elif flag == 0:
                    dict[cl] += 1
                    #if dict[cl] > count_tmp:
                    #    print(fn)
            if df.columns.size > flag:
                df.to_csv(outputdir + fn, encoding='utf-8', index=False)
            else:
                list_filenames_tmp.append(fn)
        except IOError:
            pass
"""
def fill_missing_data(dir, list_filenames):

    l_list = []

    for fn in list_filenames:
        try :
            df = pd.read_csv(dir+fn, sep=',')
            for i in range(0, df.shape[0]):
                for j in range(4, df.shape[1], 3):
                    if(pd.isnull(df.iloc[i, j])):
                        if(j> 6):
                            df.iloc[i, j] = df.iloc[i, j-3] #求均值可能更合理
                            df.iloc[i, j+1] = df.iloc[i, j-3+1]
                            df.iloc[i, j+2] = df.iloc[i, j-3+2]
                        elif(pd.notnull(df.iloc[i, j+3])):
                            df.iloc[i, j] = df.iloc[i, j+3] #求均值可能更合理
                            df.iloc[i, j+1] = df.iloc[i, j+3+1]
                            df.iloc[i, j+2] = df.iloc[i, j+3+2]
                        else:
                            #i1_0910.csv line 360
                            l_list.append(i)
                            break

            for i in l_list:
                df = df.drop(i)
            l_list.clear()
            df.to_csv(dir + fn, encoding='utf-8', index=False)


        except IOError:
            pass
"""
def files_contact(dir):
    df = pd.DataFrame()
    for fn in glob.glob(dir+'*.csv'):
        df = df.append(pd.read_csv(fn, sep =','))
    return df


rootdir = '../data/'
tmpdir = rootdir+'tmp/'
resdir = rootdir+'res/'
try:
    shutil.rmtree(resdir)
    shutil.rmtree(tmpdir)
except IOError:
    pass

if not os.path.isdir(tmpdir):
    os.makedirs(tmpdir)
if not os.path.isdir(resdir):
    os.makedirs(resdir)

dict = create_dict(rootdir+'processed_data/dict.txt')
list_filenames_tmp = []
list_filenames = find_allfiles(rootdir+'raw/', 'csv')
delet_clx(rootdir+'raw/', tmpdir, list_filenames, dict.keys())

for fn in list_filenames_tmp:
    if fn in list_filenames:
        list_filenames.remove(fn)

d =sorted(dict.items(),key=lambda dict:dict[1],reverse=True)
li =[]
for (k,v) in dict.items():
    #if v >= list_filenames.__len__():
    if v >= 78:   #依据下面d的结果，手动折中选择78
        li.append(k)

delet_clx(tmpdir, resdir, list_filenames, li, li.__len__()-1)

#fill_missing_data(resdir, list_filenames)
#I1_0910.csv 360行全为nan
df_tmp = pd.read_csv(resdir+'I1_0910.csv', sep=',')
df_tmp = df_tmp.drop(360)
df_tmp.to_csv(resdir+'I1_0910.csv', encoding='utf-8', index=False)

df = files_contact(resdir)
df_team_names = df.loc[:,('HomeTeam','AwayTeam')]
df_team_names = pd.get_dummies(df_team_names)
df_goals = df.loc[:,('FTHG','FTAG','HTHG','HTAG')]
df = df.drop(['HomeTeam','AwayTeam','FTHG','FTAG','HTHG','HTAG'],axis=1)

list=[]
df = df.T
for i in range(0, df.shape[0],3):
    list.append('a')
    list.append('b')
    list.append('c')
df['name']=pd.Series(list, index=df.index)
df=df.groupby('name').transform(lambda x:x.fillna(x.mean()))
df = df.T

df_t = pd.concat([df_team_names, df_goals,df],axis=1)

df_t.to_csv(rootdir+'result.csv', encoding='utf-8', index=False)
shutil.rmtree(resdir)
shutil.rmtree(tmpdir)

print('DONE')





"""
rootdir = '../data/'
resdir = rootdir+'res/'
df = pd.read_csv(resdir+'fillna_tmp.csv', sep=',')
l = ['FTHG','FTAG','HTHG','HTAG','Bb1X2','BbMxH','BbAvH','BbMxD','BbAvD','BbMxA','BbAvA','BbOU','BbMx>2.5','BbAv>2.5','BbMx<2.5','BbAv<2.5','BbAH','BbAHh','BbMxAHH','BbAvAHH','BbMxAHA','BbAvAHA']
for i in l:
    del(df[i])

list=[]
df = df.T
df.iloc[0,0] = np.nan

for i in range(0, df.shape[0],3):
    list.append('a')
    list.append('b')
    list.append('c')
df['name']=pd.Series(list, index=df.index)
df.groupby('name').transform(lambda x:x.fillna(x.mean()))

print(df)
"""

