# coding=gbk
import pandas as pd
import numpy as np
import os
import os.path
import shutil

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

#ɾ���޹��е�ͬʱ��Ҫ�����ֵ�
def delet_clx(dir, outputdir, list_filenames, li, flag = 0):
    #count_tmp = 0   #�ж�һ���ļ����Ƿ����ظ���
    for fn in list_filenames:
        try:
            df = pd.read_csv(dir+fn, sep=',')
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

def fill_missing_data(dir, list_filenames):

    l_list = []

    for fn in list_filenames:
        try :
            df = pd.read_csv(dir+fn, sep=',')
            for i in range(0, df.shape[0]):
                for j in range(4, df.shape[1], 3):
                    if(pd.isnull(df.iloc[i, j])):
                        if(j> 6):
                            df.iloc[i, j] = df.iloc[i, j-3] #���ֵ���ܸ�����
                            df.iloc[i, j+1] = df.iloc[i, j-3+1]
                            df.iloc[i, j+2] = df.iloc[i, j-3+2]
                        elif(pd.notnull(df.iloc[i, j+3])):
                            df.iloc[i, j] = df.iloc[i, j+3] #���ֵ���ܸ�����
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
list_filenames = find_allfiles(rootdir+'processed_data/', 'csv')
delet_clx(rootdir+'processed_data/', tmpdir, list_filenames, dict.keys())

for fn in list_filenames_tmp:
    if fn in list_filenames:
        list_filenames.remove(fn)

d =sorted(dict.items(),key=lambda dict:dict[1],reverse=True)
li =[]
for (k,v) in dict.items():
    #if v >= list_filenames.__len__():
    if v >= 78:   #��������d�Ľ�����ֶ�����ѡ��78
        li.append(k)

delet_clx(tmpdir, resdir, list_filenames, li, li.__len__()-1)

fill_missing_data(resdir, list_filenames)
print('DONE')



