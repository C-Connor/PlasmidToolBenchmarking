process BLASTCONTIGS {
    //conda 'blast==2.16.0 datamash==1.9'
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'

    publishDir "results/${id}/${id}_${tool}",
            mode: params.publishdirmode

    input:
    tuple val(id),
        path(query, stageAs: "plasmid.fasta"),
        val(tool), // query is spades assembly contigs, subject is complete assembly
        path(subject, stageAs:  "completeGenome.fasta")
    
    
    output:
    //csv file, row is spades assembly contigs, col 1 is match to complete assembly, extra cols on identity, gaps etc.
    //tuple val(id), val(tool), path("${id}_${tool}.blastresults"), emit:blasthits
    tuple val(id), path("${id}_${tool}.blastresults"), val(tool), emit:blasthits

    script:
    """
    mv plasmid.fasta ${id}_${tool}.plasmid.fasta
    mv completeGenome.fasta ${id}_completeGenome.fasta

    blastn \
        -dust no \
        -perc_identity 80 \
        -qcov_hsp_perc 80 \
        -evalue 1E-20 \
        -culling_limit 1 \
        -max_target_seqs 10000 \
        -outfmt '6 qseqid qlen sseqid slen length pident qcovhsp' \
        -subject "${id}_completeGenome.fasta" \
        -query ${id}_${tool}.plasmid.fasta \
        | sort -n -k 1 \
        | datamash -g 1 collapse 2,3,4,5,6,7 \
        > blasthits
    
    cat blasthits | sed 's/^/${tool}\t${id}\t/' > blastresults
    cat blastresults | sed 1i"PlasmidTool\tSampleID\tQueryID\tQueryLength\tSubjectID\tSubjectLength\tAlignmentLength\tIdentity\tQCovHSP\n" > ${id}_${tool}.blastresults

    """
}