#! /usr/bin/env python3
import sys
import pandas as pd
from pathlib import Path

tool = sys.argv[1]
files = sys.argv[2:]

listofPlasmids = []
listofChrom = []
listofCombinedPlasmids = []
listofComplete = []

for f in files:
        id = f.split('_quast')[0]
        plasmidquasts = [x for x in Path(f"{f}/").glob(f"*__pl_[0-9]*")]
        if plasmidquasts:
                for plasmid in Path(f"{f}/").glob(f"*__pl_[0-9]*"):
                        transResults = pd.read_csv(f"{plasmid}/transposed_report.tsv",sep="\t")
                        transResults['QuastReferenceSequence'] = str(Path(plasmid).name)
                        listofPlasmids.append(transResults)
                combinedplasresults = pd.read_csv(f"{f}/{id}__allPlasmids/transposed_report.tsv",sep='\t')
                combinedplasresults['QuastReferenceSequence'] = f"{id}__allPlasmids"
                listofCombinedPlasmids.append(combinedplasresults)
        chromresults = pd.read_csv(f"{f}/{id}__chr/transposed_report.tsv",sep='\t')
        chromresults['QuastReferenceSequence'] = f"{id}__chr"
        listofChrom.append(chromresults)
        completeresults = pd.read_csv(f"{f}/{id}__completeAssembly/transposed_report.tsv",sep='\t')
        completeresults['QuastReferenceSequence'] = f"{id}__completeAssembly"
        listofComplete.append(completeresults)


#assume that at least one sample has plasmid results in listofPlasmids and listofCombinedPlasmids
allPlasmidResults = pd.concat([x for x in listofPlasmids])
allChromResults = pd.concat([x for x in listofChrom])
allCombinedPlasmidResults = pd.concat([x for x in listofCombinedPlasmids])
allCompleteResults = pd.concat([x for x in listofComplete])

allPlasmidResults['ToolName'] = tool
allChromResults['ToolName'] = tool
allCombinedPlasmidResults['ToolName'] = tool
allCompleteResults['ToolName'] = tool

allPlasmidResults['QuastType'] = 'IndividualPlasmids'
allChromResults['QuastType'] = 'Chromosome'
allCombinedPlasmidResults['QuastType'] = 'CombinedPlasmids'
allCompleteResults['QuastType'] = 'ChromosomeAndPlasmid'

allPlasmidResults.to_csv(f"{tool}_AllSamplesQuast_plasmids.tsv",sep="\t",index=False)
allChromResults.to_csv(f"{tool}_AllSamplesQuast_chrom.tsv",sep="\t",index=False)
allCombinedPlasmidResults.to_csv(f"{tool}_AllSamplesQuast_combinedplasmids.tsv",sep="\t",index=False)
allCompleteResults.to_csv(f"{tool}_AllSamplesQuast_completeAssembly.tsv",sep="\t",index=False)