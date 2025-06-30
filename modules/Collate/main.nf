process COLLATE {
    // merge all blasthits from a tool in python
    // when collating blasthits need to account for multiple matches, matches are collapsed into , separated values
    cache 'lenient'
    label 'process_1'
    tag "${outname}"

    publishDir "results/AllSamples/",
        mode: params.publishdirmode 
    
    input:
    val(outname)
    path(files)

    output:
    path("${outname}")

    script:
    """
    collate.py ${outname} ${files.join(' ')}
    """
}

//    head -n 1 ${files[0]} > ${outname}
//    for f in ${files.join(' ')}; do
//        tail -n +2 "\$f"
//    done >> ${outname}

process COLLATE_QUAST {
    // merge all quast results from a tool into a list, then combine in python
    cache 'lenient'
    label 'process_1'
    tag "${tool}"

    //publishDir "results/AllSamples/",
    //    mode: params.publishdirmode

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

    publishDir "results/${id}",
        mode: params.publishdirmode

    input:
    tuple val(id), path(contig_files), val(tool)

    output:
    path("${id}_AllContigPredictions.tsv"), emit: contigresults //to collate for all samples

    script:
    //def spades_tool = tool_names[0]
    //def other_tools = tool_names[1]
    def spades_blast = contig_files[0]
    def tool_results = contig_files[1..-1].join(' ')

    // collate_contigresults.py $spades_file $tool_results_joined
    """
    collate_contigResults.py ${id} ${spades_blast} ${tool_results}
    """
}