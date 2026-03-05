process CALCULATE_COVERAGE {
    conda './condaenvs/Coverage.yml'
    cache 'lenient'
    label 'process_8'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(reads), path(completeAss)
    
    
    output:
    path("${id}_coverage.tab")

    script:
    """
    minimap2 \
        -t 8 \
        -ax sr \
        $completeAss \
        ${reads[0]} \
        ${reads[1]} \
        | samtools sort \
        | samtools view -b \
        > aln.bam
    samtools coverage aln.bam | csvtk --num-cpus 8 -C "\$" -t mutate2 -n SampleID -e "'${id}'" > ${id}_coverage.tab
    """
}

process COLLATE_COVERAGE {
    conda './condaenvs/Coverage.yml'
    cache 'lenient'
    label 'process_1'
    //tag "${id}"
    //errorStrategy 'ignore'

    input:
    path(coveragefiles)
    
    output:
    path("AllCoverage.tsv")

    script:
    //doesn't need timestamp, only doing for complete assemblies
    """
    csvtk --num-cpus 1 -C "\$" -t concat ${coveragefiles.join(' ')} > AllCoverage.tsv
    """
}

process RUN_QUAST {
    //conda './condaenvs/.yml'
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(assembly), path(splitCompleteAss)
    
    
    output:
    path("${id}_quast")

    script:
    """
    for f in ${splitCompleteAss}/*.fasta ; do quast --threads 1 -r \$f -o quast/\${f%.fasta} ${assembly} ; done 
    mv quast/${splitCompleteAss}/* quast/
    rm -rf quast/${splitCompleteAss}
    mv quast/ ${id}_quast/
    """
}

//not used
process COLLATE_QUAST {
    //conda './condaenvs/.yml'
    cache 'lenient'
    label 'process_1'
    //tag "${id}"
    //errorStrategy 'ignore'

    input:
    path(quast)
    
    output:
    path("AllInputAssemblyQuastResults_${params.timestamp}.tsv")

    script:
    //quast is currently a directory
    """
    csvtk --num-cpus 1 -t concat *_quast/*/transposed_report.tsv > temp.tsv
    cat temp.tsv | csvtk --num-cpus 1 -C "\$" -t mutate2 -n AssemblyType -e "'${params.SRassembler}'" > AllInputAssemblyQuastResults_${params.timestamp}.tsv
    """
}

process CONTIG_SIZE {
    //conda './condaenvs/.yml'
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(assembly), val(type)
    
    output:
    path("${id}_${type}_contigSize.tab")

    script:
    """
    seqkit --threads 1 fx2tab --length --name --header-line $assembly \
    | csvtk --num-cpus 1 -C "\$" -t mutate2 -n SampleID -e "'$id'" \
    | csvtk --num-cpus 1 -C "\$" -t mutate2 -n AssemblyType -e "'$type'" > ${id}_${type}_contigSize.tab
    """
}

process COLLATE_SIZE {
    //conda './condaenvs/.yml'
    cache 'lenient'
    label 'process_1'
    //tag "${id}"
    //errorStrategy 'ignore'

    input:
    path(files)
    
    output:
    path("AllInputAssemblyContigSizes_${params.timestamp}.tsv")

    script:
    """
    csvtk --num-cpus 1 -C "\$" -t concat ${files.join(' ')} > AllInputAssemblyContigSizes_${params.timestamp}.tsv
    """
}

process MASH {
    //conda './condaenvs/Mash.yml'
    cache 'lenient'
    label 'process_1'
    tag "${id}"

    input:
    tuple val(id), path(splitass)

    output:
    path("${id}_mashdist.tsv")

    script:
    """
    cp stdin.split/*.fasta .
    for f in *.fasta ; do 
        mash sketch -p 1 -s 100000 \$f ;
    done
    mash dist -p 1 *chr.fasta.msh *.msh \
    | sed 1i"reference-ID\tquery-ID\tdistance\tp-value\tshared-hashes\n" \
    | csvtk --num-cpus 1 -C "\$" -t mutate2 -n SampleID -e "'$id'" \
    > ${id}_mashdist.tsv
    """
}

process COLLATE_MASH {
    //conda './condaenvs/Mash.yml'
    cache 'lenient'
    label 'process_1'
    //tag "${id}"

    input:
    path(files)

    output:
    path("AllMashDistances.tsv")

    script:
    """
    csvtk --num-cpus 1 -C "\$" -t concat ${files.join(' ')} > AllMashDistances.tsv
    """
}