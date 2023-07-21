# -*- coding: utf-8 -*-
"""
Created on Sun Jun  4 22:11:07 2023

@author: Aneesh R Bhat
"""

import urllib.request, urllib.parse, urllib.error
import json

url = 'http://py4e-data.dr-chuck.net/comments_1819213.json'

json_txt = urllib.request.urlopen(url).read().decode()

info = json.loads(json_txt)

comments = info['comments']
sums = 0
for item in comments:
    sums += item['count']
    
print(sums)