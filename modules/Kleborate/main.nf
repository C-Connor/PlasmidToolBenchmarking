process RUN_KLEBORATE {
    conda './condaenvs/Kleborate.yml'
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(contigs)

    output:
    tuple val(id), path("${id}_Kleborate")
    
    script:
    //rename important output file? -> klebsiella_pneumo_complex_output.txt
    """
    kleborate \
        -a $contigs \
        -o ${id}_Kleborate \
        -p kpsc \
        --trim_headers
    """
}

process COLLECT_KLEBORATE {
    //conda './condaenvs/Kleborate.yml'
    cache 'lenient'
    label 'process_1'
    //tag "${id}"
    //errorStrategy 'ignore'

    input:
    path(files)

    output:
    path("AllKleborateTyping.tsv"), emit: klebtyping
    path("AllKleborateAMR.tsv"), emit: klebamr
    
    script:
    //not very robust
    //doesn't need timestamping, only typing closed assemblies
    """
    csvtk --num-cpus 1 -t concat *_Kleborate/klebsiella_pneumo_complex_output.txt > AllKleborateTyping.tsv
    csvtk --num-cpus 1 -t concat *_Kleborate/klebsiella_pneumo_complex_hAMRonization_output.txt > AllKleborateAMR.tsv
    """
}