# -*- coding: utf-8 -*-
"""
Created on Mon Jul 24 12:33:14 2017

@author: brettk
"""

import pandas as pd
import re
import numpy as np
import time

# STEP 1
# Drop non-useful columns
keep_col = ['drop]
chunksize = 10**5
start = time.time() 
for chunk in pd.read_csv("D:/Temp/alldata.csv", chunksize=chunksize, usecols=keep_col):
    chunk.to_csv('D:/Temp/alldata_test.csv', mode='a', index=False)
print("--- %s seconds ---" % (time.time() - start))


# Step 2: Further processing

# Load in postcodes (match to Zoopla data)
postcode_df = pd.read_csv("home/data.csv", usecols= ["pcds","laua","msoa11", "lat", "long","oseast1m","osnrth1m"])
postcode_df.head()
# Load the zoopla data in chunks
data = pd.read_csv("D:/Temp/alldata_test.csv", encoding='latin1', iterator='True', chunksize =100000)

# STAGE 1: CLEAN ADDRESS FIELDS, MERGE ON COLUMNS OF INTEREST FROM NSPL AND OUTPUT TO NEW FILE
#Start counter:
chunks = 0
start = time.time() 
start2 = time.time() 
#For each chunk in zoopla data
for chunk in data:
    #increment count
    chunks +=1
    
    start_chunk = time.time()
    
    #   Put postcode into one column
    chunk["postcode"] = chunk["outcode"].map(str) + " " + chunk["incode"].map(str)

    #SOME CLEANING OF DESCRIPTION    
    chunk["description_lower"] = chunk["description"].str.lower()
    #chunk["description_lower"] = chunk["description_lower"].apply(lambda x : x.encode('ascii', errors='ignore'))
        
    ##  Shouldn't really use regex to parse html, should use  parser, but this was done for quickness
    chunk['description_lower'] = chunk['description_lower'].str.replace('\n', ' ') # this one works
    chunk['description_lower'] = chunk['description_lower'].str.replace('&amp;pound;', '£')
    chunk['description_lower'] = chunk['description_lower'].str.replace('&amp;', '&')
    chunk['description_lower'] = chunk['description_lower'].str.replace('&amp;amp;', '&')
    chunk['description_lower'] = chunk['description_lower'].str.replace('&amp;quot;', '"') 
    chunk['description_lower'] = chunk['description_lower'].str.replace('&amp;nbsp;', ' ')
    chunk['description_lower'] = chunk['description_lower'].str.replace('&amp;#39;', "'")
    chunk['description_lower'] = chunk['description_lower'].str.replace('&#39;', "'")
    chunk['description_lower'] = chunk['description_lower'].str.replace('&#x2019;', "'")
    chunk['description_lower'] = chunk['description_lower'].str.replace('&nbsp;', "")
    chunk['description_lower'] = chunk['description_lower'].str.replace('&#231;', "c")
    chunk['description_lower'] = chunk['description_lower'].str.replace('&#x2018', "'")
    chunk['description_lower'] = chunk['description_lower'].str.replace('&#8217;', "'")
    chunk['description_lower'] = chunk['description_lower'].str.replace('&quot;', '"')
    chunk['description_lower'] = chunk['description_lower'].str.replace('&#x2013;', '') # meant to be a dash
    chunk['description_lower'] = chunk['description_lower'].str.replace('.&#13;&#10;', " ")
    
    chunk.drop(['description'], axis=1, inplace=True) 
    
    #merge zoopla chunk to postcode file
    match_df = pd.merge(chunk, postcode_df, left_on='postcode', right_on='pcds') 
    chunk.drop(['pcds'], axis=1, inplace=True) 
    #save joined data as 'i'.csv    
    #outname = "D:/Temp/" + str(i) + "_nspl_"+  "zoopla.csv"
    end = time.time() - start_chunk
    interim = (time.time() - start2)//60
    print("\n ****** \n This iteration :\t {} \n Time taken (Seconds):   \t {} \n Chunk number (out of 228): \t {}\n Interim time (Minutes): \t {} \n  ****** \n" .format(' ',end, chunks, interim))
    
    match_df.to_csv("D:/Temp/alldata_NSPL.csv", mode='a', index=False)
    end = (time.time() - start)//60
print("\n ****** \n Chunks Processed: \t {}\n Time elapsed (Minutes):  \t{}\n ****** \n".format(
            chunks, end))

test = pd.read_csv("D:/Temp/alldata_NSPL.csv", encoding='latin1', nrows=100)
test.head()   
print(list(test.columns))



data = pd.read_csv("D:/Temp/alldata_NSPL.csv", encoding='latin1', iterator='True', chunksize =100000)

# get descriptives
data.describe().append(data.isnull().sum().rename('isnull'))

