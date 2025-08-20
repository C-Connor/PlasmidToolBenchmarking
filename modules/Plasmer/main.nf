process RUN_PLASMER {
    conda './condaenvs/Plasmer.yml'
    cache 'lenient'
    label 'process_8'
    tag "${id}"
    //errorStrategy 'ignore'

    publishDir "results/${id}/${id}_Plasmer/",
            mode: params.publishdirmode,
            saveAs: { filename -> "${id}_Plasmer" }

    input:
    tuple val(id), path(spadesAss)
    path(db_dir)
    
    
    output:
    tuple val(id), path("Plasmer"), emit: plasmerPlasmids, optional: true

    script:
    """
    Plasmer \
        --threads 8 \
        --genome ${spadesAss} \
        --prefix ${id} \
        --outpath Plasmer \
        --db ${db_dir} 
    """
}

process PROCESS_PLASMER_RESULTS {
    //conda './condaenvs/Plasmer.yml'
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'

    publishDir "results/${id}/${id}_Plasmer", \
        pattern: "${id}_quast",
        mode: params.publishdirmode
    publishDir "results/${id}/${id}_Plasmer", \
        pattern: "${id}_Plasmer_contigResults.tsv",
        mode: params.publishdirmode

    input:
    tuple val(id), path(results), path(splitCompleteAss)
    
    output:
    path("${id}_quast"), emit: quastresults, optional: true
    tuple val(id), path("${id}_Plasmer_contigResults.tsv"), emit: contigresults //, optional: true
    tuple val(id), path("${id}.plasmer.predPlasmids.fa"), emit: plasmidfasta, optional: true

    when:

    script:
    """
    if [ -s ${results}/results/${id}.plasmer.predPlasmids.fa ] 
    then
        cp ${results}/results/${id}.plasmer.predPlasmids.fa .
        for f in ${splitCompleteAss}/*.fasta ; do quast -r \$f -o quast/\${f%.fasta} ${id}.plasmer.predPlasmids.fa ; done 
        mv quast/${splitCompleteAss}/* quast/
        rm -rf quast/${splitCompleteAss}
        mv quast ${id}_quast
    fi
    printf "SpadesContigID\tPlasmerPrediction\n" > ${id}_Plasmer_contigResults.tsv
    cat ${results}/results/${id}.plasmer.predClass.tsv >> ${id}_Plasmer_contigResults.tsv
    """
}