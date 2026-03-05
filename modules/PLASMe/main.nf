process RUN_PLASME {
    conda './condaenvs/PLASMe.yml'
    cache 'lenient'
    label 'process_8'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(spadesAss)
    //path(db_dir)
    
    
    output:
    tuple val(id), path("${id}_PLASMe.plasmid.fasta"), emit: PLASMePlasmids, optional: true

    script:

    """
    python ${projectDir}/assets/PLASMe/PLASMe.py \
        ${spadesAss} \
        ${id}_PLASMe.plasmid.fasta \
        -d ${params.plasmedb} \
        -t 8
    """
}

process PROCESS_PLASME_RESULTS {
    //conda './condaenvs/PLASMe.yml'
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(PLASMeresults), path(splitCompleteAss)
    
    output:
    path("${id}_quast"), emit: quastresults, optional: true
    tuple val(id), path("${id}_PLASMe_contigResults.tsv"), emit: contigresults //, optional: true
    tuple val(id), path("${PLASMeresults}"), emit: plasmidfasta, optional: true

    script:
    """
    if [ -s ${PLASMeresults} ]
    then
        for f in ${splitCompleteAss}/*.fasta ; do quast --threads 1 -r \$f -o quast/\${f%.fasta} ${PLASMeresults} ; done 
        mv quast/${splitCompleteAss}/* quast/
        rm -rf quast/${splitCompleteAss}
        mv quast ${id}_quast
        grep "^>" ${PLASMeresults} | sed -e "s/^>//" | sed "s/\$/\tplasmid/" > temp.tsv
        cat temp.tsv | sed 1i"SpadesContigID\tPLASMePrediction\n" > ${id}_PLASMe_contigResults.tsv
    fi
    """
}