# -*- coding: utf-8 -*-
"""
Created on Sun Jun  4 22:22:55 2023

@author: Aneesh R Bhat
"""

import urllib.request, urllib.parse, urllib.error
import json

apikey = 42
serviceurl = 'http://py4e-data.dr-chuck.net/json?'

address = 'Beloit College'

parms = dict()
parms['address'] = address
parms['key'] = apikey

url = serviceurl + urllib.parse.urlencode(parms)

data = urllib.request.urlopen(url).read().decode()

parsed_json = json.loads(data)
results = parsed_json['results'][0]

print(results['place_id'])
