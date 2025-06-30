
include { PROCESS_PLASCOPE_RESULTS } from '../modules/PlaScope'
include { PROCESS_PLASMIDSPADES_RESULTS } from '../modules/SPAdes'
include { PROCESS_MOBSUITE_RESULTS } from '../modules/MOB-Suite'
include { PROCESS_PLASMER_RESULTS } from '../modules/Plasmer'
include { PROCESS_PLASMIDHUNTER_RESULTS } from '../modules/PlasmidHunter'
include { PROCESS_PLATON_RESULTS } from '../modules/Platon'
include { CONTIG_SPLIT } from '../modules/ContigSplit'

workflow ProcessRuns {
    take:
    completeAss // channel: [id, file-completeAss]
    spadesAss // channel: [id, file-spadesAss]
    plascopePlasmids // RUN_PLASCOPE.out.plascopePlasmids
    plasmidspadesPlasmids // RUN_PLASMIDSPADES.out.plasmidspadesPlasmids
    mobPlasmids // RUN_MOBSUITE.out.mobPlasmids
    plasmerPlasmids // RUN_PLASMER.out.plasmerPlasmids
    plasmidhunterPlasmids // RUN_PLASMIDHUNTER.out.plasmidhunterPlasmids
    platonPlasmids // RUN_PLATON.out.platonPlasmids

    main:
    CONTIG_SPLIT(completeAss)
    
    //plascope
    PROCESS_PLASCOPE_RESULTS(
        plascopePlasmids.join(CONTIG_SPLIT.out.splitContigs)
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

    //emit all quast results
    PROCESS_PLASCOPE_RESULTS.out.quastresults.collect().map { results -> tuple('PlaScope', results) }.set{ plascopequastresults }
    PROCESS_PLASMIDSPADES_RESULTS.out.quastresults.collect().map { results -> tuple('PlasmidSPAdes', results) }.set{ plasmidspadesquastresults }
    PROCESS_MOBSUITE_RESULTS.out.quastresults.collect().map { results -> tuple('MOBSuite', results) }.set{ mobquastresults }
    PROCESS_PLASMER_RESULTS.out.quastresults.collect().map { results -> tuple('Plasmer', results) }.set{ plasmerquastresults }
    PROCESS_PLASMIDHUNTER_RESULTS.out.quastresults.collect().map { results -> tuple('PlasmidHunter', results) }.set{ plasmidhunterquastresults }
    PROCESS_PLATON_RESULTS.out.quastresults.collect().map { results -> tuple('Platon', results) }.set{ platonquastresults }

    //emit plasmid fastas for de novo assemblers for blasting
    PROCESS_PLASCOPE_RESULTS.out.plasmidfasta.map { id, results -> tuple(id, results, 'PlaScope') }.set{ plascopefasta }
    PROCESS_PLASMIDSPADES_RESULTS.out.plasmidfasta.map { id, results -> tuple(id, results, 'PlasmidSPAdes') }.set{ plasmidspadesfasta }
    //PROCESS_MOBSUITE_RESULTS.out.plasmidfasta.map { id, results -> tuple(id, results, 'MOBSUITE') }.set{ mobsuitefasta }
    //PROCESS_PLASMER_RESULTS.out.plasmidfasta.map { id, results -> tuple(id, results, 'Plasmer') }.set{ plasmerfasta }
    //PROCESS_PLASMIDHUNTER_RESULTS.out.plasmidfasta.map { id, results -> tuple(id, results, 'PlasmidHunter') }.set{ plasmidhunterfasta }
    //PROCESS_PLATON_RESULTS.out.plasmidfasta.map { id, results -> tuple(id, results, 'Platon') }.set{ platonfasta }
    
    // emit contigResults.tsv files for binary classifiers
    //PROCESS_PLASCOPE_RESULTS.out.contigresults.map { id, results -> tuple(id, results, 'PlaScope') }.set{ plascopecontigresults }
    //PROCESS_PLASMIDSPADES_RESULTS.out.contigresults.map { id, results -> tuple(id, results, 'PlasmidSPAdes') }.set{ plasmidspadescontigresults }
    PROCESS_MOBSUITE_RESULTS.out.contigresults.map { id, results -> tuple(id, results, 'MOBSUITE') }.set{ mobsuitecontigresults }
    PROCESS_PLASMER_RESULTS.out.contigresults.map { id, results -> tuple(id, results, 'Plasmer') }.set{ plasmercontigresults }
    PROCESS_PLASMIDHUNTER_RESULTS.out.contigresults.map { id, results -> tuple(id, results, 'PlasmidHunter') }.set{ plasmidhuntercontigresults }
    PROCESS_PLATON_RESULTS.out.contigresults.map { id, results -> tuple(id, results, 'Platon') }.set{ platoncontigresults }
    
    emit: 
    quastresults = plascopequastresults.mix(plasmidspadesquastresults,mobquastresults,plasmerquastresults,plasmidhunterquastresults,platonquastresults)
    denovoassemblers = plascopefasta.mix(plasmidspadesfasta) //,mobsuitefasta, plasmerfasta, plasmidhunterfasta, platonfasta)
    binaryclassifiers = mobsuitecontigresults.mix(plasmercontigresults, plasmidhuntercontigresults, platoncontigresults) //, plascopefasta, plasmidspadesfasta)

}