process RUN_PLASCOPE_READS {
    conda './condaenvs/PlaScope.yml'
    label 'process_8'
    tag "${id}"
    cache 'lenient'
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(reads)
    path(db_dir)
    val(db_name)
    
    output:
    tuple val(id), path("PlaScope_reads"), emit: plascopePlasmidsreads

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
    cp -r temp_Results/${id}_PlaScope PlaScope_reads
    """
}

process RUN_PLASCOPE_ASSEMBLY {
    conda './condaenvs/PlaScope.yml'
    label 'process_8'
    tag "${id}"
    cache 'lenient'
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(assembly)
    path(db_dir)
    val(db_name)
    
    output:
    tuple val(id), path("PlaScope_assembly"), emit: plascopePlasmidsassembly

    script:
    """
    plaScope.sh \
        -t 8 \
        --fasta ${assembly} \
        -o temp_Results \
        --db_dir ${db_dir} \
        --db_name ${db_name} \
        --sample ${id} 
    cp -r temp_Results/${id}_PlaScope PlaScope_assembly
    """
}

process PROCESS_PLASCOPEREADS_RESULTS {
    //conda './condaenvs/PlaScope.yml'
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(plascoperesults), path(splitCompleteAss)
    
    output:
    path("${id}_quast"), emit: quastresults, optional: true
    //tuple val(id), path("PlaScope_contigResults.tsv"), optional: true
    tuple val(id), path("${id}_plasmid.fasta"), emit: plasmidfasta, optional: true
    tuple val(id), path("${id}_chromosome.fasta"), emit: chromfasta, optional: true

    script:
    // resultdir/PlaScope_predictions/${id}_plasmid.fasta
    // test if empty
    // don't make contigResults file as contig IDs will not match up, generates new spades assembly
    """
    if [ -s ${plascoperesults}/PlaScope_predictions/${id}_plasmid.fasta ] 
    then
        cp ${plascoperesults}/PlaScope_predictions/${id}_plasmid.fasta .
        for f in ${splitCompleteAss}/*.fasta ; do quast --threads 1 -r \$f -o quast/\${f%.fasta} ${id}_plasmid.fasta ; done 
        mv quast/${splitCompleteAss}/* quast/
        rm -rf quast/${splitCompleteAss}
        mv quast ${id}_quast
    fi
    if [ -s ${plascoperesults}/PlaScope_predictions/${id}_chromosome.fasta ] 
    then
        cp ${plascoperesults}/PlaScope_predictions/${id}_chromosome.fasta .
    fi
    """
}

process PROCESS_PLASCOPEASSEMBLY_RESULTS {
    //conda './condaenvs/PlaScope.yml'
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(plascoperesults), path(splitCompleteAss)
    
    output:
    path("${id}_quast"), emit: quastresults, optional: true
    tuple val(id), path("${id}_PlaScopeAssembly_contigResults.tsv"), emit: contigresults, optional: true
    tuple val(id), path("${id}_plasmid.fasta"), emit: plasmidfasta, optional: true

    script:
    // resultdir/PlaScope_predictions/${id}_plasmid.fasta
    // need to make empty contig results file if plasmid.fasta doesn't exist?
    """
    if [ -s ${plascoperesults}/PlaScope_predictions/${id}_plasmid.fasta ] 
    then
        cp ${plascoperesults}/PlaScope_predictions/${id}_plasmid.fasta .
        for f in ${splitCompleteAss}/*.fasta ; do quast --threads 1 -r \$f -o quast/\${f%.fasta} ${id}_plasmid.fasta ; done 
        mv quast/${splitCompleteAss}/* quast/
        rm -rf quast/${splitCompleteAss}
        mv quast ${id}_quast
        grep "^>" ${id}_plasmid.fasta | sed -e "s/^>//" | sed "s/\$/\tplasmid/" > temp.tsv
    fi
    if [ -s ${plascoperesults}/PlaScope_predictions/${id}_chromosome.fasta ] 
    then
        cp ${plascoperesults}/PlaScope_predictions/${id}_chromosome.fasta .
        grep "^>" ${id}_chromosome.fasta | sed -e "s/^>//" | sed "s/\$/\tchromosome/" >> temp.tsv
    fi
    if [ -s temp.tsv ]
    then
        cat temp.tsv | sed 1i"SpadesContigID\tPlaScopeAssemblyPrediction\n" > ${id}_PlaScopeAssembly_contigResults.tsv
    fi
    """
}