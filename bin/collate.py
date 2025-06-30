#! /usr/bin/env python

import sys
import pandas as pd

dflist = []
for file in sys.argv[2:]:
    try:
        df = pd.read_csv(file, sep="\t")
    except pd.errors.EmptyDataError:
        continue
    dflist.append(df)

out = pd.concat([x for x in dflist], ignore_index=True)

out.to_csv(sys.argv[1],sep="\t",index=False)
