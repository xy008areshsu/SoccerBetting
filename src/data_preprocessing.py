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

#删除无关行的同时需要更新字典
def delet_clx(dir, outputdir, list_filenames, li, flag = 0):
    #count_tmp = 0   #判断一个文件里是否有重复列
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

rootdir = '..\\data\\'
tmpdir = rootdir+'tmp\\'
resdir = rootdir+'res\\'
try:
    shutil.rmtree(resdir)
    shutil.rmtree(tmpdir)
except IOError:
    pass

if not os.path.isdir(tmpdir):
    os.makedirs(tmpdir)
if not os.path.isdir(resdir):
    os.makedirs(resdir)

dict = create_dict(rootdir+'processed_data\\dict.txt')
list_filenames_tmp = []
list_filenames = find_allfiles(rootdir+'processed_data\\', 'csv')
delet_clx(rootdir+'processed_data\\', tmpdir, list_filenames, dict.keys())

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
print('DONE')



