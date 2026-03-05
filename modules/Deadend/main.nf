process RUN_DEADEND {
    //conda './condaenvs/SPAdes.yml'
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(assemblygfa)

    output:
    tuple val(id), path("${id}_deadends.tab"), emit: deadend_count
    
    script:
    """
    echo -e "SampleID\tDeadendCount" > ${id}_deadends.tab
    paste <(echo "${id}") <(deadends $assemblygfa) >> ${id}_deadends.tab
    """
}

process COLLECT_DEADEND {
    //conda './condaenvs/SPAdes.yml'
    cache 'lenient'
    label 'process_1'
    //tag "${id}"
    //errorStrategy 'ignore'

    input:
    path(files)

    output:
    path("AllDeadends_${params.timestamp}.tab")
    
    script:
    """
    csvtk --num-cpus 1 -t concat ${files.join(' ')} > AllDeadends_${params.timestamp}.tab
    """
}