# -*- coding: utf-8 -*-
"""
Created on Sun Jun  4 21:42:25 2023

@author: Aneesh R Bhat
"""

import urllib.request, urllib.parse, urllib.error
import xml.etree.ElementTree as ET

url = input('Enter the url: ')

xml = urllib.request.urlopen(url, context='ctx').read().decode()

tree = ET.fromstring(xml)

counts = tree.findall('.//count')
sum = 0
for count in counts:
    sum += int(count.text)
    
print(sum)