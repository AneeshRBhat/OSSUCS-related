# -*- coding: utf-8 -*-

import numpy as np
import matplotlib

x = float(input('Enter a number '))
y = float(input('Enter another number '))

power = x**y
log2 = float(np.log2(x))

print("x raised to y:", power)
print("log2 of x", log2)

