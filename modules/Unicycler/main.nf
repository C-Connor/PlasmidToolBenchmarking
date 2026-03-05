process RUN_UNICYCLER {
    conda './condaenvs/Unicycler.yml'
    cache 'lenient'
    label 'process_8'
    tag "${id}"
    //errorStrategy 'ignore'

    when:
    //not sure if this is the best way
    params.SRassembler?.toLowerCase() == 'unicycler'

    input:
    tuple val(id), path(reads)

    output:
    //needs to use same order as output from SPAdes
    tuple val(id), path("${id}_Unicyclercontigs.fasta"), emit: unicycler_contigs
    tuple val(id), path("${id}_Unicycler.gfa"), emit: unicycler_gfa
    
    script:
    //replace [space] with _ in unicycler fasta headers so string matching works later
    """
    unicycler \
        -o unicycler_out \
        -1 ${reads[0]} \
        -2 ${reads[1]} \
        --mode normal \
       --threads 8
       cat unicycler_out/assembly.fasta | seqkit replace -p ' ' -r '_' > ${id}_Unicyclercontigs.fasta
       cp unicycler_out/assembly.gfa ${id}_Unicycler.gfa
       
    """
}