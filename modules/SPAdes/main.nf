process RUN_SPADES {
    conda './condaenvs/SPAdes.yml'
    cache 'lenient'
    label 'process_8'
    tag "${id}"
    //errorStrategy 'ignore'

    when:
    //not sure this is the best way
    !params.SRassembler || params.SRassembler?.toLowerCase() == 'spades'

    input:
    tuple val(id), path(reads)

    output:
    tuple val(id), path("${id}_SPAdescontigs.fasta"), emit: spades_contigs
    tuple val(id), path("${id}_SPAdes.gfa"), emit: spades_gfa
    
    script:
    """
    spades.py \
        --isolate \
        -o spades_out \
        -1 ${reads[0]} \
        -2 ${reads[1]} \
       --threads 8 \
       && \
       cp spades_out/contigs.fasta ${id}_SPAdescontigs.fasta && \
       cp spades_out/assembly_graph_after_simplification.gfa ${id}_SPAdes.gfa
    """
}

process RUN_PLASMIDSPADES {
    conda './condaenvs/SPAdes.yml'
    cache 'lenient'
    label 'process_8'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(reads)
    
    output:
    tuple val(id), path('plaspades'), emit: plasmidspadesPlasmids

    script:
    """
    spades.py --plasmid \
        -t 8 \
        -1 ${reads[0]} \
        -2 ${reads[1]} \
        -o plaspades
    """
}

process PROCESS_PLASMIDSPADES_RESULTS {
    //conda './condaenvs/SPAdes.yml'
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(plasmidspadesresults), path(splitCompleteAss)
    
    output:
    path("${id}_quast"), emit: quastresults, optional: true
    //tuple val(id), path("PlasmidSPAdes_contigResults.tsv"), optional: true
    tuple val(id), path("${id}_plasmidcontigs.fasta"), emit: plasmidfasta, optional: true

    script:
    // test if empty
    // don't make contigResults file as contig IDs will not match up, generates new spades assembly
    """
    if [ -s ${plasmidspadesresults}/contigs.fasta ] 
    then
        cp ${plasmidspadesresults}/contigs.fasta ${id}_plasmidcontigs.fasta
        for f in ${splitCompleteAss}/*.fasta ; do quast --threads 1 -r \$f -o quast/\${f%.fasta} ${id}_plasmidcontigs.fasta ; done 
        mv quast/${splitCompleteAss}/* quast/
        rm -rf quast/${splitCompleteAss}
        mv quast ${id}_quast
    fi
    """
}