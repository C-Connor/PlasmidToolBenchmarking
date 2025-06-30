// Run all plasmid tools

include { RUN_MOBSUITE } from '../modules/MOB-Suite'
include { RUN_PLASCOPE } from '../modules/PlaScope'
include { RUN_PLASMER } from '../modules/Plasmer'
include { RUN_PLASMIDHUNTER } from '../modules/PlasmidHunter'
include { RUN_PLATON } from '../modules/Platon'
include { RUN_PLASMIDSPADES } from '../modules/SPAdes'
include { CONTIG_SPLIT } from '../modules/ContigSplit'

workflow RunTools {
    take:
    sample_reads
    sample_spades
    sample_completeAss

    main:
    //read input
    RUN_PLASCOPE(
        sample_reads,
        params.plascopedb,
        params.plascopedb_name
        ) //needs db

    RUN_PLASMIDSPADES(
        sample_reads
    ) //no db

    //assembly input
    //mobsuite
    RUN_MOBSUITE(
        sample_spades
    )

    //plasmer
    RUN_PLASMER(
        sample_spades,
        params.plasmerdb
    )

    //plasmidhunter
    RUN_PLASMIDHUNTER(
        sample_spades
    )


    //platon
    RUN_PLATON(
        sample_spades,
        params.platondb
    )

    emit:
    RUN_PLASCOPE.out.plascopePlasmids
    RUN_PLASMIDSPADES.out.plasmidspadesPlasmids
    RUN_MOBSUITE.out.mobPlasmids
    RUN_PLASMER.out.plasmerPlasmids
    RUN_PLASMIDHUNTER.out.plasmidhunterPlasmids
    RUN_PLATON.out.platonPlasmids
}