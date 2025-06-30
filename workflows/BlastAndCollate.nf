include { BLASTCONTIGS } from '../modules/BlastContigs'
include { COLLATE as COLLATE_ALL_BLAST } from '../modules/Collate'
include { COLLATE as COLLATE_ALL_CONTIGS } from '../modules/Collate'
include { COLLATE as COLLATE_ALL_QUAST } from '../modules/Collate'
include { COLLATE_QUAST;COLLATE_CONTIGRESULTS } from '../modules/Collate'

workflow BlastAndCollate {
    take:
    spades 
    complete
    quasts 
    denovo 
    binclassifiers

    main:
    // just for de novo assemblyer, binary classifiers have similar results in contigResults.tsv
    blastresults = BLASTCONTIGS(
        spades.map { id, file -> tuple(id, file, 'SPAdes') }
            .mix(denovo)
            .combine(complete,by:0)
    ) 
    // separate out SPAdes blast results to combine with binary classifer contigResults.tsv
    blastresults
        .filter { id, file, tool -> tool == 'SPAdes'} // tuple val(id), val(tool), path("${id}_${tool}.blasthits")
        .set { spadesblastresults }
    
    //drop id and tool from blast results output, just merge all files together
    COLLATE_ALL_BLAST(
        "AllDeNovoToolsBlastResults.tsv", // output name
        blastresults
            .map { id, file, tool -> file }
            .collect()
    )

    // merge contigResults.tsv files 
    // need to match up by sample to merge by columns
    // need to collect all results
    COLLATE_CONTIGRESULTS(
        binclassifiers // tuple(id, results, 'MOBSUITE')
            .groupTuple()
            .mix(spadesblastresults) // takes tuple (id, spadesresults, 'SPAdes')
            .groupTuple() // makes [ id, [spades.blast, [tool1.blast, tool2.blast]], spades, [tool1, tool2]] ] 
            .map { id, contigresults, tools -> 
                    def spades_file = contigresults[0]
                    def other_files = contigresults[1]
                    def all_files = [spades_file] + other_files  // spades.blast first
                    return [id, all_files, tools]
                }
    )
    
    // take output of COLLATE_CONTIGRESULTS and merge all with COLLATE
    COLLATE_ALL_CONTIGS('AllBinaryClassifierContigPredictions.tsv',COLLATE_CONTIGRESULTS.out.contigresults.collect())

    // collect all quasts from a tool into a list, then combine in python
    COLLATE_QUAST(quasts) //takes tuple ('tool','results list')

    COLLATE_ALL_QUAST(
        "AllSamplesQuastResults.tsv", // output name
        COLLATE_QUAST.out.collect()
    )
}