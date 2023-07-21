# -*- coding: utf-8 -*-
"""
Created on Mon May 29 22:25:04 2023

@author: Aneesh R Bhat
"""

import urllib.request, urllib.parse, urllib.error
from bs4 import BeautifulSoup

url = 'http://py4e-data.dr-chuck.net/known_by_Eiddon.html'

for i in range(7):
    html = urllib.request.urlopen(url).read()
    soup = BeautifulSoup(html, 'html.parser')
    tags = soup('a')
    url = tags[17].get('href', None)

print(tags[17].contents[0])