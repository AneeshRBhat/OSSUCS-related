# -*- coding: utf-8 -*-
"""
Created on Thu Jun  8 21:36:08 2023

@author: Aneesh R Bhat
"""
import xml.etree.ElementTree as ET
import sqlite3 as sql
conn = sql.connect('trackdb.sqlite')
cur = conn.cursor()

cur.executescript('''
DROP TABLE IF EXISTS Artist;
DROP TABLE IF EXISTS Album;
DROP TABLE IF EXISTS Track;
DROP TABLE IF EXISTS Genre;
CREATE TABLE Artist (
    id  INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name    TEXT UNIQUE
);

CREATE TABLE Genre (
    id  INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name    TEXT UNIQUE
);

CREATE TABLE Album (
    id  INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    artist_id  INTEGER,
    title   TEXT UNIQUE
);

CREATE TABLE Track (
    id  INTEGER NOT NULL PRIMARY KEY 
        AUTOINCREMENT UNIQUE,
    title TEXT  UNIQUE,
    album_id  INTEGER,
    genre_id  INTEGER,
    len INTEGER, rating INTEGER, count INTEGER
);
''')


file = 'Library.xml'

def lookup (d, key):
    found = False
    for child in d:
        if found: return child.text
        if child.tag == 'key' and child.text == key :
            found = True
    return None
    
xml = ET.parse(file) 
all = xml.findall('dict/dict/dict')
print('dict count:', len(all))
for entry in all:
    if (lookup(entry, 'Track ID') is None): continue


    name = lookup(entry, 'Name')
    artist = lookup(entry, 'Artist')
    album = lookup(entry, 'Album')
    length = lookup(entry, 'Total Time')
    rating = lookup(entry, 'Rating')
    count = lookup(entry, 'Play Count')
    genre = lookup(entry, 'Genre')

    if name is None or artist is None or album is None or genre is None: 
        continue
    
    print(name, artist, album, count, rating, length, genre)
    
    cur.execute('''INSERT OR IGNORE INTO Artist(name) VALUES(?)''', (artist,) )
    cur.execute('Select id from Artist where name=?', (artist,))
    artist_id = cur.fetchone()[0]
    
    cur.execute('''INSERT OR IGNORE INTO Genre (name) 
        VALUES ( ? )''', (genre, ) )
    cur.execute('SELECT id FROM Genre WHERE name = ? ', (genre, ))
    genre_id = cur.fetchone()[0]

    cur.execute('''INSERT OR IGNORE INTO Album (title, artist_id) 
        VALUES ( ?, ? )''', ( album, artist_id ) )
    cur.execute('SELECT id FROM Album WHERE title = ? ', (album, ))
    album_id = cur.fetchone()[0]

    cur.execute('''INSERT OR REPLACE INTO Track
        (title, album_id, genre_id, len, rating, count) 
        VALUES ( ?, ?, ?, ?, ?, ?)''', 
        ( name, album_id, genre_id, length, rating, count ) )

conn.commit()
conn.close()
    
    

