process RUN_MOBSUITE {
    conda './condaenvs/MOB_Suite.yml'
    cache 'lenient'
    label 'process_8'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(spadesAss)
    
    output:
    tuple val(id), path("mobrecon"), emit: mobPlasmids
    //tuple val(id), path("${id}_mobrecon/contig_report.txt"), emit: mobContigReport, optional: true //tsv with contig classifications

    script:
    """
    mob_recon \
        --infile ${spadesAss} \
        --outdir mobrecon
    """
}

process PROCESS_MOBSUITE_RESULTS {
    //conda './condaenvs/MOB_Suite.yml'
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(mobresults), path(splitCompleteAss)
    
    output:
    path("${id}_quast"), emit:quastresults, optional: true
    tuple val(id), path("${id}_MOBSUITE_contigResults.tsv"), emit: contigresults //, optional: true
    tuple val(id), path("${id}_allMOBplasmids.fasta"), emit: plasmidfasta, optional: true

    when:

    script:
    """
    files=\$(shopt -s nullglob dotglob; echo ${mobresults}/plasmid_*.fasta)
    if (( \${#files} )) 
    then
        cat ${mobresults}/plasmid_*.fasta > ${id}_allMOBplasmids.fasta
        for f in ${splitCompleteAss}/*.fasta ; do quast --threads 1 -r \$f -o quast/\${f%.fasta} ${id}_allMOBplasmids.fasta ; done 
        mv quast/${splitCompleteAss}/* quast/
        rm -rf quast/${splitCompleteAss}
        mv quast/ ${id}_quast/
    fi
    printf "SpadesContigID\tMOBPrediction\n" > ${id}_MOBSUITE_contigResults.tsv
    cat ${mobresults}/contig_report.txt | csvtk --num-cpus 1 -t cut -f 5,2 | csvtk --num-cpus 1 del-header >> ${id}_MOBSUITE_contigResults.tsv
    """
}