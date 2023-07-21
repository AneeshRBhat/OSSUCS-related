# -*- coding: utf-8 -*-
"""
Created on Mon May 29 22:25:04 2023

@author: Aneesh R Bhat
"""

import urllib.request, urllib.parse, urllib.error
from bs4 import BeautifulSoup

url = 'http://py4e-data.dr-chuck.net/comments_1819210.html'
html = urllib.request.urlopen(url).read()
soup = BeautifulSoup(html, 'html.parser')

tags = soup('span')

num_sum = 0
for tag in tags:
    num_sum += int(tag.contents[0])

print(num_sum)
