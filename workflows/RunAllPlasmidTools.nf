// Run all plasmid tools

include { RUN_MOBSUITE } from '../modules/MOB-Suite'
include { RUN_PLASCOPE_READS;RUN_PLASCOPE_ASSEMBLY } from '../modules/PlaScope'
include { RUN_PLASMER } from '../modules/Plasmer'
include { RUN_PLASMIDHUNTER } from '../modules/PlasmidHunter'
include { RUN_PLATON } from '../modules/Platon'
include { RUN_PLASMIDSPADES } from '../modules/SPAdes'
include { RUN_HYASP } from '../modules/Hyasp'
include { RUN_PLASME } from '../modules/PLASMe'
include { CONTIG_SPLIT } from '../modules/ContigSplit'

workflow RunTools {
    take:
    sample_reads
    sample_SRcontigs
    sample_SRgfa
    sample_completeAss

    main:
    //read input
    RUN_PLASCOPE_READS(
        sample_reads,
        params.plascopedb,
        params.plascopedb_name
        ) //needs db

    RUN_PLASMIDSPADES(
        sample_reads
    ) //no db

    //assembly input
    //plascope
    RUN_PLASCOPE_ASSEMBLY(
        sample_SRcontigs,
        params.plascopedb,
        params.plascopedb_name
    )
    //mobsuite
    RUN_MOBSUITE(
        sample_SRcontigs
    )

    //plasmer
    RUN_PLASMER(
        sample_SRcontigs,
        params.plasmerdb
    )

    //plasmidhunter
    RUN_PLASMIDHUNTER(
        sample_SRcontigs
    )

    //platon
    RUN_PLATON(
        sample_SRcontigs,
        params.platondb
    )

    //hyasp
    RUN_HYASP(
        sample_SRgfa,
        params.hyaspdb
    )

    //PLASMe
    RUN_PLASME(
        sample_SRcontigs
    )

    merge_results_publish = RUN_PLASCOPE_READS.out.plascopePlasmidsreads.mix(
        RUN_PLASCOPE_ASSEMBLY.out.plascopePlasmidsassembly,
        RUN_PLASMIDSPADES.out.plasmidspadesPlasmids,
        RUN_MOBSUITE.out.mobPlasmids,
        RUN_PLASMER.out.plasmerPlasmids,
        RUN_PLASMIDHUNTER.out.plasmidhunterPlasmids,
        RUN_PLATON.out.platonPlasmids,
        RUN_HYASP.out.hyaspPlasmids,
        RUN_PLASME.out.PLASMePlasmids
    ) // should be [[id, file]]

    emit:
    RUN_PLASCOPE_READS.out.plascopePlasmidsreads
    RUN_PLASCOPE_ASSEMBLY.out.plascopePlasmidsassembly
    RUN_PLASMIDSPADES.out.plasmidspadesPlasmids
    RUN_MOBSUITE.out.mobPlasmids
    RUN_PLASMER.out.plasmerPlasmids
    RUN_PLASMIDHUNTER.out.plasmidhunterPlasmids
    RUN_PLATON.out.platonPlasmids
    RUN_HYASP.out.hyaspPlasmids
    RUN_PLASME.out.PLASMePlasmids
    merge_results_publish
}