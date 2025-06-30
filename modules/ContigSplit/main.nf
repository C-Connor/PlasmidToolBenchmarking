process CONTIG_SPLIT {
    //conda 'blast==2.16.0 datamash==1.9'
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id), path(completeAss)
    
    output:
    tuple val(id), path("stdin.split/"), emit: splitContigs

    script:
    // split everything including chromosome
    """
    cat ${completeAss} | seqkit split -i
    cd stdin.split
    for f in *.fasta ; do mv \$f \${f#stdin.part_} ;  done
    cp ../${completeAss} ${id}__completeAssembly.fasta
    files=\$(shopt -s nullglob dotglob; echo *__pl_[0-9]*.fasta)
    if (( \${#files} )) 
    then
        cat \$files > ${id}__allPlasmids.fasta
    fi
    """
}
//    seqkit grep -r -p '.*__pl_.*' ${completeAss} > plasmidContigs.fa
//    if [ -s plasmidContigs.fa ] 
//    then
//        cat plasmidContigs.fa | seqkit split -i 
//    else
//        cat ${completeAss} | seqkit split -i
//    fi
//    cd stdin.split
//    for f in *.fasta ; do mv \$f \${f#stdin.part_} ;  done
//    cd ..