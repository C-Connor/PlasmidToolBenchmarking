process RUN_GENOMAD {
    conda './condaenvs/geNomad.yml'
    cache 'lenient'
    label 'process_8'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(spadesAss)
    path(db)
    
    output:
    tuple val(id), path("geNomad"), emit: geNomadPlasmids

    script:
    """
    genomad end-to-end \
    --threads 8 \
    ${spadesAss} \
    geNomad \
    ${db}
    """
}

process PROCESS_GENOMAD_RESULTS {
    //conda './condaenvs/MOB_Suite.yml'
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(geNomadresults), path(splitCompleteAss)
    
    output:
    path("${id}_quast"), emit:quastresults, optional: true
    tuple val(id), path("${id}_geNomad_contigResults.tsv"), emit: contigresults //, optional: true
    tuple val(id), path("${id}_geNomadPlasmids.fasta"), emit: plasmidfasta, optional: true

    when:

    script:
    """
    if [ -s ${geNomadresults}/${id}_*_summary/${id}_*_plasmid.fna ] 
    then
        cp ${geNomadresults}/${id}_*_summary/${id}_*_plasmid.fna .
        for f in ${splitCompleteAss}/*.fasta ; do quast --threads 1 -r \$f -o quast/\${f%.fasta} ${id}_*_plasmid.fna ; done 
        mv quast/${splitCompleteAss}/* quast/
        rm -rf quast/${splitCompleteAss}
        mv quast ${id}_quast
    fi
    if [ -s ${geNomadresults}/${id}_*_summary/${id}_*_plasmid_summary.tsv ]
    then
        printf "SpadesContigID\tgeNomadPrediction\n" > ${id}_geNomad_contigResults.tsv
        cut -f 1 ${geNomadresults}/${id}_*_summary/${id}_*_plasmid_summary.tsv | tail  -n +2 | sed 's/\$/\tplasmid/' >> ${id}_geNomad_contigResults.tsv
    else
        printf "SpadesContigID\tgeNomadPrediction\n" > ${id}_geNomad_contigResults.tsv
    fi
    """
}