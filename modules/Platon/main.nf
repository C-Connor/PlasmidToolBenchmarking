process RUN_PLATON {
    conda './condaenvs/Platon.yml'
    cache 'lenient'
    label 'process_8'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(spadesAss)
    path(db_dir)
    
    output:
    tuple val(id), path("Platon"), emit: platonPlasmids

    script:
    """
    platon \
        --threads 8 \
        --output Platon \
        --db ${db_dir} \
        --prefix ${id} \
        ${spadesAss}
    """
}

process PROCESS_PLATON_RESULTS {
    //conda './condaenvs/Platon.yml'
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'
    
    input:
    tuple val(id), path(results), path(splitCompleteAss)

    output:
    path("${id}_quast"), emit: quastresults, optional: true
    tuple val(id), path("${id}_Platon_contigResults.tsv"), emit: contigresults
    tuple val(id), path("${id}.plasmid.fasta"), emit: plasmidfasta, optional: true

    script:
    """
    cut -f 1 ${results}/${id}.tsv | tail  -n +2 > plasmidcontigs.list
    if [ -s plasmidcontigs.list ] ; then
        cp ${results}/${id}.plasmid.fasta .
        for f in ${splitCompleteAss}/*.fasta ; do quast --threads 1 -r \$f -o quast/\${f%.fasta} ${id}.plasmid.fasta ; done 
        mv quast/${splitCompleteAss}/* quast/
        rm -rf quast/${splitCompleteAss}
        mv quast/ ${id}_quast/
        printf "SpadesContigID\tPlatonPrediction\n" > ${id}_Platon_contigResults.tsv
        cat plasmidcontigs.list | sed 's/\$/\tplasmid/' >> ${id}_Platon_contigResults.tsv
        grep "^>" ${results}/${id}.chromosome.fasta | sed -e "s/^>//" | sed "s/\$/\tchromosome/" >> ${id}_Platon_contigResults.tsv
    else
        printf "SpadesContigID\tPlatonPrediction\n" > ${id}_Platon_contigResults.tsv
    fi
    """
}