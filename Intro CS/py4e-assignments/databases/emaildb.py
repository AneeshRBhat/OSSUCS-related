# -*- coding: utf-8 -*-
"""
Created on Thu Jun  8 14:11:55 2023

@author: Aneesh R Bhat
"""

import sqlite3 as sql

conn = sql.connect('emaildb.sqlite')
cur = conn.cursor()

cur.execute('DROP TABLE IF EXISTS Counts')

cur.execute('''
CREATE TABLE Counts (org TEXT, count INTEGER)''')

fname = 'mbox.txt'

fh = open(fname)

for line in fh:
    if not line.startswith('From: '): continue
    pieces = line.split()
    email = pieces[1]
    org = email[email.find('@')+1:]
    cur.execute('SELECT count from Counts WHERE org = ?', (org,))
    row = cur.fetchone()
    if row == None:
        cur.execute('INSERT INTO Counts(org, count) VALUES (?, 1)', (org, ))
    else:
        cur.execute('''UPDATE Counts SET count = count + 1 WHERE org = ?''', (org,))
    
conn.commit()

sqlstr = 'SELECT org, count FROM Counts ORDER BY count DESC LIMIT 10'

for row in cur.execute(sqlstr):
    print(str(row[0]), row[1])
    
cur.close()
