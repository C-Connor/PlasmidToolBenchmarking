include { BLASTCONTIGS } from '../modules/BlastContigs'
include { COLLATE as COLLATE_ALL_BLAST } from '../modules/Collate'
include { COLLATE as COLLATE_ALL_CONTIGS } from '../modules/Collate'
include { COLLATE as COLLATE_ALL_QUAST } from '../modules/Collate'
include { COLLATE_QUAST;COLLATE_CONTIGRESULTS } from '../modules/Collate'

workflow BlastAndCollate {
    take:
    srcontigs //tuple val(id), path("${id}_Unicyclercontigs.fasta")
    complete //tuple val(id), path("complete.fasta")
    quasts //[quastpaths], val("toolname")
    denovo //tuple val(id), [results], val("toolname"), val("chrom or plas")
    binclassifiers //tuple val(id), path, val("toolname")

    main:
    // just for de novo assembler and hyasp, binary classifiers have similar results in contigResults.tsv
    blastresults = BLASTCONTIGS(
        srcontigs.map { id, file -> tuple(id, file, 'SRonlyContigs', 'truth') }
            .mix(denovo)
            .combine(complete,by:0)
    ) 
    //blastresults.view() // tuple( id, blastresults file, tool name)
    // separate out short read only contigs blast results to combine with binary classifer contigResults.tsv
    blastresults
        .filter { id, file, tool -> tool == 'SRonlyContigs'} 
        .set { srblastresults }
    
    //drop id and tool from blast results output, just merge all files together
    COLLATE_ALL_BLAST(
        "AllDeNovoToolsBlastResults_${params.timestamp}.tsv", // output name
        blastresults
            .map { id, file, tool -> file }
            .collect()
    )

    // merge contigResults.tsv files 
    // need to match up by sample to merge by columns
    // need to collect all results
    COLLATE_CONTIGRESULTS(
        binclassifiers // tuple(id, results, 'MOBSUITE')
            .mix(srblastresults) // tuple (id, srresults, 'SRonlyContigs')
            .groupTuple() // makes [ id, [results...], [tools...]
    )
    
    // take output of COLLATE_CONTIGRESULTS and merge all with COLLATE
    COLLATE_ALL_CONTIGS("AllBinaryClassifierContigPredictions_${params.timestamp}.tsv",COLLATE_CONTIGRESULTS.out.contigresults.collect())

    // collect all quasts from a tool into a list, then combine in python
    COLLATE_QUAST(quasts) //takes tuple ('tool','results list')

    COLLATE_ALL_QUAST(
        "AllSamplesQuastResults_${params.timestamp}.tsv", // output name
        COLLATE_QUAST.out.collect()
    )

    blast_publish_files = COLLATE_ALL_BLAST.out.mix(
        COLLATE_ALL_CONTIGS.out,
        COLLATE_ALL_QUAST.out
    )//.map{ filename -> "${params.timestamp}_${filename}"}

    emit:
    blast_publish_files
}