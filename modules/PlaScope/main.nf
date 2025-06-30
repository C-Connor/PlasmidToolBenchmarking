process RUN_PLASCOPE {
    conda './condaenvs/PlaScope.yml'
    label 'process_8'
    tag "${id}"
    //errorStrategy 'ignore'

    publishDir "results/${id}/${id}_PlaScope", \
            mode: params.publishdirmode

    input:
    tuple val(id), path(reads)
    path(db_dir)
    val(db_name)
    
    output:
    tuple val(id), path("${id}_PlaScope"), emit: plascopePlasmids

    script:
    """
    plaScope.sh \
        -t 8 \
        -1 ${reads[0]} \
        -2 ${reads[1]} \
        -o temp_Results \
        --db_dir ${db_dir} \
        --db_name ${db_name} \
        --sample ${id} 
    
    mv temp_Results/${id}_PlaScope .
    """
}

process PROCESS_PLASCOPE_RESULTS {
    //conda './condaenvs/PlaScope.yml'
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'

    publishDir "results/${id}/${id}_PlaScope",
        pattern: "${id}_quast",
        mode: params.publishdirmode
    //publishDir "results/${id}/${id}_PlaScope", \
    //    pattern: "PlaScope_contigResults.tsv",
    //    mode: 'copy',
    //    saveAs: { filename -> "${id}_PlaScope_contigResults.tsv"}

    input:
    tuple val(id), path(plascoperesults), path(splitCompleteAss)
    
    output:
    path("${id}_quast"), emit: quastresults, optional: true
    //tuple val(id), path("PlaScope_contigResults.tsv"), optional: true
    tuple val(id), path("${id}_plasmid.fasta"), emit: plasmidfasta, optional: true

    when:

    script:
    // resultdir/PlaScope_predictions/${id}_plasmid.fasta
    // test if empty
    // don't make contigResults file as contig IDs will not match up, generates new spades assembly
    """
    if [ -s ${plascoperesults}/PlaScope_predictions/${id}_plasmid.fasta ] 
    then
        mv ${plascoperesults}/PlaScope_predictions/${id}_plasmid.fasta .
        for f in ${splitCompleteAss}/*.fasta ; do quast -r \$f -o quast/\${f%.fasta} ${id}_plasmid.fasta ; done 
        mv quast/${splitCompleteAss}/* quast/
        rm -rf quast/${splitCompleteAss}
        mv quast ${id}_quast
    fi
    """
}