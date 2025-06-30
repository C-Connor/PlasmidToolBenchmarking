#! /usr/bin/env python

import sys
import pandas as pd
from functools import reduce

spadesblast = pd.read_csv(sys.argv[2],sep="\t")
spadesblast.drop("PlasmidTool",inplace=True,axis=1)

listOfContig = []
for file in sys.argv[3:]:
        toolContig = pd.read_csv(file,sep="\t")
        toolContig.rename(columns={"SpadesContigID":"QueryID"},inplace=True)
        listOfContig.append(toolContig)
#print(len(listOfContig))
#print(listOfContig.insert(0,spadesblast))
listOfContig.insert(0,spadesblast)
merged = reduce(
        lambda left,right: pd.merge(left,right,on="QueryID",how='left'),\
                listOfContig
        )
merged.to_csv(f"{sys.argv[1]}_AllContigPredictions.tsv",sep="\t",index=False)