// make assemblies from short reads

include { RUN_SPADES } from '../modules/SPAdes'
include { RUN_UNICYCLER } from '../modules/Unicycler'

workflow MakeShortAssemblies {
    // make short read only assemblies and quantify number of dead ends
    take:
    sample_reads

    main:
    //logic on which assembler to use is in the individual processes
    
    spades = RUN_SPADES(sample_reads)
    unicycler = RUN_UNICYCLER(sample_reads)

    contigs = spades.spades_contigs.mix(unicycler.unicycler_contigs)
    gfa = spades.spades_gfa.mix(unicycler.unicycler_gfa)

    emit:
    contigs // tuple val(id), path(contigs) - mix of spades and unicycler
    gfa // tuple val(id), path(gfa) - mix of spades and unicycler
}
