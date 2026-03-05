process RUN_HYASP {
    conda params.hyasp_env
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(assemblygfa)
    path(db)

    output:
    tuple val(id), path('HyAsp'), emit: hyaspPlasmids
    
    script:
    """
    hyasp map $db gcm.csv -g $assemblygfa
    hyasp filter $db gcm.csv filtered_gcm.csv
    hyasp find $assemblygfa $db filtered_gcm.csv HyAsp
    """
}

process PROCESS_HYASP_RESULTS {
    //conda params.hyasp_env
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(hyaspresults), path(splitCompleteAss)
    
    output:
    path("${id}_quast"), emit: quastresults, optional: true
    //tuple val(id), path("${id}_Hyasp_contigResults.tsv"), emit: contigresults, optional: true
    tuple val(id), path("${id}_plasmidcontigs.fasta"), emit: plasmidfasta, optional: true

    script:
    """
    if [ -s ${hyaspresults}/putative_plasmids.fasta ] 
    then
        cp ${hyaspresults}/putative_plasmids.fasta ${id}_plasmidcontigs.fasta
        for f in ${splitCompleteAss}/*.fasta ; do quast --threads 1 -r \$f -o quast/\${f%.fasta} ${id}_plasmidcontigs.fasta ; done 
        mv quast/${splitCompleteAss}/* quast/
        rm -rf quast/${splitCompleteAss}
        mv quast ${id}_quast
    fi
    """
}