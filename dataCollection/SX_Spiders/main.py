"""
    Data scraper using REQUESTS package; Not very effective;

    For demonstration, I modified the code to make it store in a .csv format;

    This code was tested in the Google Colab and then migrated here;
"""

import time
import pandas as pd
from spider import Spider

age = []
areaName = []
cardNumber = []
caseNumber = []
courtName = []
disruptTypeName = []
duty = []
gistID = []
gistUnit = []
iname = []
partyTypeName = []
performance = []
publishDate = []
sex = []
lastmod = []
version = []
regDate = []

sp = Spider()

for i in range(3):
    data = sp.get_data(i)
    for items in data:
        age.append(items["age"]),
        iname.append(items['iname']),
        cardNumber.append(items['cardNum']),
        caseNumber.append(items["caseCode"]),
        courtName.append(items['courtName']),
        disruptTypeName.append(items['disruptTypeName']),
        duty.append(items['duty']),
        gistID.append(items['gistId']),
        gistUnit.append(items['gistUnit']),
        partyTypeName.append(items['partyTypeName']),
        performance.append(items['performance']),
        publishDate.append(items['publishDate']),
        sex.append(items['sexy']),
        lastmod.append(items['lastmod']),
        version.append(items['_version']),
        regDate.append(items['regDate'])

    time.sleep(3)

detailed_data = pd.DataFrame(
    {
        'name': iname,
        'regDate': regDate,
        'age': age,
        'cardNumber': cardNumber,
        'caseNumber': caseNumber,
        'courtName': courtName,
        'disruptTypeName': disruptTypeName,
        'performance': performance,
        'gistID': gistID

    }
)

"""
    Some sample results for demo; 
"""

print(detailed_data)
