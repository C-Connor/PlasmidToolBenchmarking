include { RUN_KLEBORATE; COLLECT_KLEBORATE } from '../modules/Kleborate'
include { RUN_DEADEND; COLLECT_DEADEND } from '../modules/Deadend'
include { 
    CALCULATE_COVERAGE; 
    COLLATE_COVERAGE; 
    RUN_QUAST; 
    //COLLATE_QUAST; 
    CONTIG_SIZE; 
    COLLATE_SIZE;
    MASH;
    COLLATE_MASH 
    } from '../modules/Metrics'
include { CONTIG_SPLIT } from '../modules/ContigSplit'
include { COLLATE; COLLATE_QUAST } from '../modules/Collate'

workflow TypingDeadendMetrics {
    take:
    reads
    sample_completeAss
    sr_gfa
    sr_contigs

    main:
    //split complete contigs into plasmids and chromosome
    CONTIG_SPLIT(sample_completeAss)

    //assembly metrics - need count of contig sizes
    //add labels 
    labelled_complete = sample_completeAss.map{
        id, file -> tuple(id, file, "CompleteAssembly")
    }
    labelled_sronly = sr_contigs.map{
        id, file -> tuple(id, file, "SROnlyAssembly")
    }

    //run quast on sr only assemblies, using complete genomes as reference sequences
    //re-use python scripts to include extra columns
    RUN_QUAST(
        sr_contigs.join(CONTIG_SPLIT.out.splitContigs)
    ).collect().map{ results -> tuple("${params.SRassembler}", results)} | COLLATE_QUAST 
    //need to merge all quast results into one file
    COLLATE(
        "AllInputAssemblyQuastResults_${params.timestamp}.tsv", // output name
        COLLATE_QUAST.out.collect()
    )

    //calculate sequencing coverage
    CALCULATE_COVERAGE(reads.join(sample_completeAss)).collect() | COLLATE_COVERAGE 

    //kleborate - get hAMRornization output for gene locations
    RUN_KLEBORATE(sample_completeAss).map {
        id, file -> file
    }.collect() | COLLECT_KLEBORATE

    //deadend counts
	RUN_DEADEND(sr_gfa).map{
        id, file -> file
    }.collect() | COLLECT_DEADEND

    //contig sizes for sr only and hybrid assemblies
    CONTIG_SIZE(
        labelled_complete.mix(labelled_sronly)
    ).collect() | COLLATE_SIZE

    //mash distance between chromosome and plasmids for complete assemblies
    MASH(
        CONTIG_SPLIT.out.splitContigs
    ).collect() | COLLATE_MASH

    typing_publish_files = COLLATE_COVERAGE.out.mix(
        COLLECT_KLEBORATE.out.klebtyping,
        COLLECT_KLEBORATE.out.klebamr,
        COLLECT_DEADEND.out,
        COLLATE_SIZE.out,
        COLLATE_MASH.out,
        COLLATE.out
    )//.map{ filename -> "${params.timestamp}_${filename}"} 

    emit:
    typing_publish_files
}