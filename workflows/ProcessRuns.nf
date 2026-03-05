
include { PROCESS_PLASCOPEREADS_RESULTS; PROCESS_PLASCOPEASSEMBLY_RESULTS } from '../modules/PlaScope'
include { PROCESS_PLASMIDSPADES_RESULTS } from '../modules/SPAdes'
include { PROCESS_MOBSUITE_RESULTS } from '../modules/MOB-Suite'
include { PROCESS_PLASMER_RESULTS } from '../modules/Plasmer'
include { PROCESS_PLASMIDHUNTER_RESULTS } from '../modules/PlasmidHunter'
include { PROCESS_PLATON_RESULTS } from '../modules/Platon'
include { PROCESS_HYASP_RESULTS } from '../modules/Hyasp'
include { PROCESS_PLASME_RESULTS } from '../modules/PLASMe'
include { CONTIG_SPLIT } from '../modules/ContigSplit'

workflow ProcessRuns {
    take:
    completeAss // channel: [id, file-completeAss]
    spadesAss // channel: [id, file-spadesAss]
    plascopePlasmidsreads // RUN_PLASCOPE.out.plascopePlasmidsreads
    plascopePlasmidsassembly // RUN_PLASCOPE.out.plascopePlasmidsassembly
    plasmidspadesPlasmids // RUN_PLASMIDSPADES.out.plasmidspadesPlasmids
    mobPlasmids // RUN_MOBSUITE.out.mobPlasmids
    plasmerPlasmids // RUN_PLASMER.out.plasmerPlasmids
    plasmidhunterPlasmids // RUN_PLASMIDHUNTER.out.plasmidhunterPlasmids
    platonPlasmids // RUN_PLATON.out.platonPlasmids
    hyaspPlasmids // RUN_HYASP.out.hyaspPlasmids
    PLASMePlasmids
    merge_results_publish //not used

    main:
    CONTIG_SPLIT(completeAss)
    
    //plascope
    PROCESS_PLASCOPEREADS_RESULTS(
        plascopePlasmidsreads.join(CONTIG_SPLIT.out.splitContigs)
    )
    PROCESS_PLASCOPEASSEMBLY_RESULTS(
        plascopePlasmidsassembly.join(CONTIG_SPLIT.out.splitContigs)
    )

    //plasmidspades
    PROCESS_PLASMIDSPADES_RESULTS(
        plasmidspadesPlasmids.join(CONTIG_SPLIT.out.splitContigs)
    )

    //mobsuite
    PROCESS_MOBSUITE_RESULTS(
        mobPlasmids.join(CONTIG_SPLIT.out.splitContigs)
    )

    //plasmer
    PROCESS_PLASMER_RESULTS(
        plasmerPlasmids.join(CONTIG_SPLIT.out.splitContigs)
    )

    //plasmidhunter
    PROCESS_PLASMIDHUNTER_RESULTS(
        plasmidhunterPlasmids.join(CONTIG_SPLIT.out.splitContigs).join(spadesAss)
    )

    //platon
    PROCESS_PLATON_RESULTS(
        platonPlasmids.join(CONTIG_SPLIT.out.splitContigs)
    )

    //hyasp - works from assembly graph so difficult to match back to short read contigs precisely
    PROCESS_HYASP_RESULTS(
        hyaspPlasmids.join(CONTIG_SPLIT.out.splitContigs)
    )

    //PLASMe
    PROCESS_PLASME_RESULTS(
        PLASMePlasmids.join(CONTIG_SPLIT.out.splitContigs)
    )

    //emit all quast results
    PROCESS_PLASCOPEREADS_RESULTS.out.quastresults.collect().map { results -> tuple('PlaScope_reads', results) }.set{ plascopeReadsquastresults }
    PROCESS_PLASCOPEASSEMBLY_RESULTS.out.quastresults.collect().map { results -> tuple('PlaScope_assembly', results) }.set{ plascopeAssemblyquastresults }
    PROCESS_PLASMIDSPADES_RESULTS.out.quastresults.collect().map { results -> tuple('PlasmidSPAdes', results) }.set{ plasmidspadesquastresults }
    PROCESS_MOBSUITE_RESULTS.out.quastresults.collect().map { results -> tuple('MOBSuite', results) }.set{ mobquastresults }
    PROCESS_PLASMER_RESULTS.out.quastresults.collect().map { results -> tuple('Plasmer', results) }.set{ plasmerquastresults }
    PROCESS_PLASMIDHUNTER_RESULTS.out.quastresults.collect().map { results -> tuple('PlasmidHunter', results) }.set{ plasmidhunterquastresults }
    PROCESS_PLATON_RESULTS.out.quastresults.collect().map { results -> tuple('Platon', results) }.set{ platonquastresults }
    PROCESS_HYASP_RESULTS.out.quastresults.collect().map { results -> tuple('HyAsp', results) }.set{ hyaspquastresults }
    PROCESS_PLASME_RESULTS.out.quastresults.collect().map { results -> tuple('PLASMe', results) }.set{ PLASMequastresults }

    //emit plasmid fastas for de novo assemblers for blasting 
    PROCESS_PLASCOPEREADS_RESULTS.out.plasmidfasta.map { id, results -> tuple(id, results, 'PlaScope_reads', 'plasmid') }.set{ plascopeReadsfasta }
    PROCESS_PLASMIDSPADES_RESULTS.out.plasmidfasta.map { id, results -> tuple(id, results, 'PlasmidSPAdes', 'plasmid') }.set{ plasmidspadesfasta }
    //PROCESS_MOBSUITE_RESULTS.out.plasmidfasta.map { id, results -> tuple(id, results, 'MOBSUITE') }.set{ mobsuitefasta }
    //PROCESS_PLASMER_RESULTS.out.plasmidfasta.map { id, results -> tuple(id, results, 'Plasmer') }.set{ plasmerfasta }
    //PROCESS_PLASMIDHUNTER_RESULTS.out.plasmidfasta.map { id, results -> tuple(id, results, 'PlasmidHunter') }.set{ plasmidhunterfasta }
    //PROCESS_PLATON_RESULTS.out.plasmidfasta.map { id, results -> tuple(id, results, 'Platon') }.set{ platonfasta }
    PROCESS_HYASP_RESULTS.out.plasmidfasta.map { id, results -> tuple(id, results, 'HyAsp', 'plasmid') }.set{ hyaspfasta }

    //emit chromosome predictions for de novo assemblers - only produced by PlaScope_Reads
    PROCESS_PLASCOPEREADS_RESULTS.out.chromfasta.map { id, results -> tuple( id, results, 'PlaScope_reads', 'chromosome') }.set{ plascopeReadsfasta_chrom }
    
    // emit contigResults.tsv files for binary classifiers
    PROCESS_PLASCOPEASSEMBLY_RESULTS.out.contigresults.map { id, results -> tuple(id, results, 'PlaScope_assembly') }.set{ plascopeAssemblycontigresults }
    //PROCESS_PLASMIDSPADES_RESULTS.out.contigresults.map { id, results -> tuple(id, results, 'PlasmidSPAdes') }.set{ plasmidspadescontigresults }
    PROCESS_MOBSUITE_RESULTS.out.contigresults.map { id, results -> tuple(id, results, 'MOBSUITE') }.set{ mobsuitecontigresults }
    PROCESS_PLASMER_RESULTS.out.contigresults.map { id, results -> tuple(id, results, 'Plasmer') }.set{ plasmercontigresults }
    PROCESS_PLASMIDHUNTER_RESULTS.out.contigresults.map { id, results -> tuple(id, results, 'PlasmidHunter') }.set{ plasmidhuntercontigresults }
    PROCESS_PLATON_RESULTS.out.contigresults.map { id, results -> tuple(id, results, 'Platon') }.set{ platoncontigresults }
    //hyasp - uses assembly graph so contig ID's don't match
    PROCESS_PLASME_RESULTS.out.contigresults.map { id, results -> tuple(id, results, 'PLASMe') }.set{ PLASMecontigresults }

    emit: 
    quastresults = plascopeReadsquastresults.mix(
        plascopeAssemblyquastresults, 
        plasmidspadesquastresults, 
        mobquastresults, 
        plasmerquastresults, 
        plasmidhunterquastresults, 
        platonquastresults,
        hyaspquastresults,
        PLASMequastresults
        )

    denovo = plascopeReadsfasta.mix(
        plasmidspadesfasta,
        hyaspfasta,
        plascopeReadsfasta_chrom
        ) //,mobsuitefasta, plasmerfasta, plasmidhunterfasta, platonfasta)

    binaryclassifiers = plascopeAssemblycontigresults.mix(
        mobsuitecontigresults, 
        plasmercontigresults, 
        plasmidhuntercontigresults, 
        platoncontigresults,
        PLASMecontigresults
        ) //, plascopefasta, plasmidspadesfasta)
}