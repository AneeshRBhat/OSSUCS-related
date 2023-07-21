# -*- coding: utf-8 -*-
"""
Created on Mon May 29 15:53:51 2023

@author: Aneesh R Bhat
"""

import re

handle = open('actual.txt')
numsum = 0
for line in handle:
    num_list_line = re.findall('[0-9]+', line)
    for num in num_list_line:
        numsum += int(num)
        
print(numsum)
