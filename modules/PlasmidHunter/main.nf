process RUN_PLASMIDHUNTER {
    conda './condaenvs/PlasmidHunter.yml'
    cache 'lenient'
    label 'process_8'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(spadesAss)
    
    
    output:
    tuple val(id), path("PlasmidHunter"), emit: plasmidhunterPlasmids

    script:
    """
    plasmidhunter \
        --infile ${spadesAss} \
        --cpu 8 \
        --outdir PlasmidHunter
    """
}

process PROCESS_PLASMIDHUNTER_RESULTS {
    //conda './condaenvs/PlasmiHunter.yml'
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(results), path(splitCompleteAss), path(spadesAss)
    
    output:
    path("${id}_quast"), emit: quastresults, optional: true
    tuple val(id), path("${id}_PlasmidHunter_contigResults.tsv"), emit: contigresults //, optional: true
    tuple val(id), path("${id}_plasmidcontigs.fasta"), emit: plasmidfasta, optional: true

    when:

    script:
    //predictions.tsv always exists
    """
    cat ${results}/predictions.tsv | csvtk --num-cpus 1 -t filter2 -f '\$2 == 1.0' | csvtk --num-cpus 1 -t cut -f 1 | csvtk --num-cpus 1 -t del-header > plasmid_contigIDs.list
    if [ -s plasmid_contigIDs.list ] ; then
        seqkit --threads 1 grep -f plasmid_contigIDs.list ${spadesAss} > ${id}_plasmidcontigs.fasta
        for f in ${splitCompleteAss}/*.fasta ; do quast --threads 1 -r \$f -o quast/\${f%.fasta} ${id}_plasmidcontigs.fasta ; done 
        mv quast/${splitCompleteAss}/* quast/
        rm -rf quast/${splitCompleteAss}
        mv quast ${id}_quast
    fi
    
    cat ${results}/predictions.tsv |\
    csvtk --num-cpus 1 -t mutate2 -n PlasmidHunterPreds -e '\$2 == 1.0 ? "plasmid" : "chromosome"' |\
    csvtk --num-cpus 1 -t cut -f 1,5 |\
    csvtk --num-cpus 1 del-header |\
    csvtk --num-cpus 1 -t add-header -n SpadesContigID,PlasmidHunterPrediction > ${id}_PlasmidHunter_contigResults.tsv
    """
}