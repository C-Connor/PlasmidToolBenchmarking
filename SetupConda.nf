//workflow that runs processes individually to test setups of conda envs as they frequently don't install properly - unsure why

process ENV_MOB {
    conda './condaenvs/MOB_Suite.yml'
    
    input:
    val x

    output: 
    val x

    script:
    """
    echo "MOB_Suite env ready"
    """
}

process ENV_PLASCOPE {
    conda './condaenvs/PlaScope.yml'
    
    input:
    val x

    output: 
    val x

    script:
    """
    echo "PlaScope env ready"
    """
}

process ENV_PLASMER {
    conda './condaenvs/Plasmer.yml'
    
    input:
    val x

    output: 
    val x

    script:
    """
    echo "Plasmer env ready"
    """
}

process ENV_PLASMIDHUNTER {
    conda './condaenvs/PlasmidHunter.yml'
    
    input:
    val x

    output: 
    val x

    script:
    //add test plasmidhunter run to download DB?
    """
    echo "PlasmidHunter env ready"
    """
}

process ENV_PLATON {
    conda './condaenvs/Platon.yml'
    
    input:
    val x

    output: 
    val x

    script:
    """
    echo "Platon env ready"
    """
}

process ENV_SPADES {
    conda './condaenvs/SPAdes.yml'
    
    input:
    val x

    output: 
    val x

    script:
    """
    echo "SPAdes env ready"
    """
}

//hyasp - skip

process ENV_KLEBORATE {
    conda './condaenvs/Kleborate.yml'
    
    input:
    val x

    output: 
    val x

    script:
    """
    echo "Kleborate env ready"
    """
}

process ENV_COVERAGE {
    conda './condaenvs/Coverage.yml'
    
    input:
    val x

    output: 
    val x

    script:
    """
    echo "Coverage env ready"
    """
}

process ENV_UNICYCLER {
    conda './condaenvs/Unicycler.yml'
    
    input:
    val x

    output: 
    val x

    script:
    """
    echo "Unicycler env ready"
    """
}

//process ENV_PLASME {
    // conda './condaenvs/PLASMe.yml'

    // input:
    // val x

    // output:
    // val x

    // script:
    // """
    // python ${projectDir}/assets/PLASMe/PLASMe.py \
    //     ${projectDir}/assets/PLASMe/test.fasta \
    //     test.plasme.fna \
    //     -c 0.6 \
    //     -i 0.6 \
    //     -p 0.5 \
    //     -t 8
    // """
//}

workflow {
    Channel
        .of(1)
        | ENV_MOB
        | ENV_PLASCOPE
        | ENV_PLASMER
        | ENV_PLASMIDHUNTER
        | ENV_PLATON
        | ENV_SPADES
        | ENV_KLEBORATE
        | ENV_COVERAGE
        | ENV_UNICYCLER
        //| ENV_PLASME
}