process BLASTCONTIGS {
    //conda 'blast==2.16.0 datamash==1.9'
    cache 'lenient'
    label 'process_1'
    tag "${id}"
    //errorStrategy 'ignore'

    input:
    tuple val(id),
        path(query, stageAs: "query.fasta"),
        val(tool), // query is sr assembly contigs, subject is complete assembly
        val(prediction),
        path(subject, stageAs:  "completeGenome.fasta")
    
    
    output:
    //csv file, row is sr assembly contigs, col 1 is match to complete assembly, extra cols on identity, gaps etc.
    //tuple val(id), val(tool), path("${id}_${tool}.blastresults"), emit:blasthits
    tuple val(id), path("${id}_${tool}_${prediction}.blastresults"), val(tool), emit:blasthits

    script:
    // remove -qcov_hsp_perc ? 
    // Removes hits when contig breaks don't line up i.e. start of plasmid in complete assembly is in middle of tool assembly
    // also remove datamash after sort?         | datamash -g 1 collapse 2,3,4,5,6,7 \
    """
    blastn \
        -num_threads 1 \
        -dust no \
        -perc_identity 80 \
        -evalue 1E-20 \
        -culling_limit 1 \
        -max_target_seqs 10000 \
        -outfmt '6 qseqid qlen sseqid slen length pident qcovhsp' \
        -subject completeGenome.fasta \
        -query query.fasta \
        | sort -n -k 1 \
        > blasthits
    
    cat blasthits | sed 's/^/${tool}\t${prediction}\t${id}\t/' > blastresults
    cat blastresults | sed 1i"PlasmidTool\tPrediction\tSampleID\tQueryID\tQueryLength\tSubjectID\tSubjectLength\tAlignmentLength\tIdentity\tQCovHSP\n" > ${id}_${tool}_${prediction}.blastresults
    """
}