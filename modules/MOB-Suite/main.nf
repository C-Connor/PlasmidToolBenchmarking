process RUN_MOBSUITE {
    conda './condaenvs/MOB_Suite.yml'
    cache 'lenient'
    label 'process_8'
    tag "${id}"
    //errorStrategy 'ignore'

    publishDir "results/${id}/${id}_MOBSUITE", \
            pattern: "*mobrecon*",
            mode: params.publishdirmode,
            saveAs: { filename -> "${id}_mobrecon"}

    input:
    tuple val(id), path(spadesAss)
    
    output:
    tuple val(id), path("${id}_mobrecon"), emit: mobPlasmids
    //tuple val(id), path("${id}_mobrecon/contig_report.txt"), emit: mobContigReport, optional: true //tsv with contig classifications

    script:
    """
    mob_recon \
        --infile ${spadesAss} \
        --outdir ${id}_mobrecon
    """
}

process PROCESS_MOBSUITE_RESULTS {
    //conda './condaenvs/MOB_Suite.yml'
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'

    publishDir "results/${id}/${id}_MOBSUITE",
        pattern: "${id}_quast",
        mode: params.publishdirmode

    publishDir "results/${id}/${id}_MOBSUITE",
        pattern: "${id}_MOBSUITE_contigResults.tsv",
        mode: params.publishdirmode

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
        for f in ${splitCompleteAss}/*.fasta ; do quast -r \$f -o quast/\${f%.fasta} ${id}_allMOBplasmids.fasta ; done 
        mv quast/${splitCompleteAss}/* quast/
        rm -rf quast/${splitCompleteAss}
        mv quast/ ${id}_quast/
    fi
    printf "SpadesContigID\tMOBPrediction\n" > ${id}_MOBSUITE_contigResults.tsv
    cat ${mobresults}/contig_report.txt | csvtk -t cut -f 5,2 | csvtk del-header >> ${id}_MOBSUITE_contigResults.tsv
    """
}