process COLLATE {
    // merge all blasthits from a tool in python
    // when collating blasthits need to account for multiple matches, matches are collapsed into , separated values
    cache 'lenient'
    label 'process_1'
    tag "${outname}"
    
    input:
    val(outname)
    path(files)

    output:
    path("${outname}")

    script:
    """
    collate.py temp.tsv ${files.join(' ')}
    cat temp.tsv | csvtk --num-cpus 1 -C "\$" -t mutate2 -n SRAssemblerUsed -e "'${params.SRassembler}'" > ${outname}
    """
}


process COLLATE_QUAST {
    // merge all quast results from a tool into a list, then combine in python
    cache 'lenient'
    label 'process_1'
    tag "${tool}"

    input:
    tuple val(tool), path(quastfiles)

    output:
    path("*_AllSamplesQuast_*.tsv")
    //path("${tool}_AllSamplesQuast_chrom.tsv")
    //path("${tool}_AllSamplesQuast_combinedplasmids.tsv")

    script:
    """
    collate_quast.py ${tool} ${quastfiles.join(' ')} 
    """
}

process COLLATE_CONTIGRESULTS {
    // merge all contigResults from a tool into a list, then combine in python
    cache 'lenient'
    label 'process_1'
    tag "${id}"

    input:
    tuple val(id), path(contig_files), val(tool)

    output:
    path("${id}_AllContigPredictions.tsv"), emit: contigresults //to collate for all samples

    script:
    """
    collate_contigResults.py ${id} *.blastresults *_contigResults.tsv
    """
}