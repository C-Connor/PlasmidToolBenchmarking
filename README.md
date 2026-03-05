# Plasmid Tool Benchmarking Analysis

Code for benchmarking several plasmid detection tools associated with publication xxx.

The pipeline runs samples through all the plasmid tools, extracts the sequences that the tool reports as plasmid, and compares them to the complete genome for accuracy. To perform the comparison we use both Blastn and Quast. Quast can report assembly errors and other metrics but was difficult to extract exactly which plasmid sequences were being matched to which contigs in the reference genome, an easier approach was to use Blastn. For Quast we use the plasmid only contigs from the complete genomes as a 'reference genome'. For the Blastn analysis we use the complete reference genomes as the 'subject' and the plasmid predictions as the 'query'. Blast hits are restricted to high matches with `-perc_identity 80 -qcov_hsp_perc 80 -evalue 1E-20` (the same parameters used for Abricate). From the Blast results we can count true positive, true negatives, false postives and false negatives.

## Data Input

The pipeline relies on the complete assemblies having chromosome and plasmid contigs identified, the fasta header lines are suffixed with either `__chr` or `__pl[0-9]`. The pipeline will generate the short read only assemblies required by the plasmid identification tools. The default assembler is SPAdes but this can be changed to Unicycler using `--SRassembler unicycler`. 

The pipeline expects a tab separated input file with columns:
1. Sample identifier
2. Path to forwards / R1 read
3. Path to reverse / R2 read
4. Path to complete / hybrid assembly

Each row is a different sample, with no header row. See below for commands on how to generate this file.

## Data Output

The pipeline will symlink result files into `results`. The short read only assemblies will go into `ShortReadOnlyAssemblies/<spades or unicycler>` depending on which assembler was chosen. The raw outputs from the tools are in `ToolOutputs/<spaades or unicycler>`.

The condensed results from blast and quast are in `results/AllSampleResults/<spades or unicycler>`. There are 3 tsv files described below and a `MetricsAndTyping` directory that contains condensed results from the typing tools, described below. 

Result files that are affected by a different choice of short read only assembler (e.g. input assembly statistics) are date stamped to avoid overwriting previous results. Files that are not affected (e.g. AMR detection from hybrid assemblies) are not datestamped, and should be identical between all runs.

### 1. AllBinaryClassifierContigPredictions.tsv

This contains some blast data for the short read only contig against the complete assembly, and the predictions from the binary classifiers. SampleID is the identifier for the individual sample, QueryID is the contig identifier from the short read only assembly, and SubjectID is the contig identifier from the complete assembly.

| SampleID  |   QueryID                             |   QueryLength  |   SubjectID     |   SubjectLength  |   AlignmentLength  |   Identity  |   QCovHSP  |   PlatonPrediction  |   PlasmidHunterPrediction  |   PlasmerPrediction  |   MOBPrediction  |
|-----------|---------------------------------------|----------------|-----------------|------------------|--------------------|-------------|------------|---------------------|----------------------------|----------------------|------------------|
|   sample1 |   NODE_100_length_160_cov_92.848485   |   160          |   sample1__chr  |   5123193        |   160              |   100.0     |   100      |                     |                            |   shorter_than_500   |   chromosome     |
|   sample2 |   NODE_101_length_154_cov_156.222222  |   154          |   sample1__chr  |   5123193        |   154              |   100.0     |   100      |                     |                            |   shorter_than_500   |   chromosome     |

### 2. AllDeNovoToolsBlastResults.tsv

This contains the blast results of the de novo assembler plasmid contigs against the complete genome. The results from the short read only assembly blast back to the complete assembly are included here for reference with the PlasmidTool name of SPAdes (different from PlasmidSPAdes)

|   PlasmidTool  |   SampleID  |   QueryID                             |   QueryLength  |   SubjectID     |   SubjectLength  |   AlignmentLength  |   Identity  |   QCovHSP  |
|----------------|-------------|---------------------------------------|----------------|-----------------|------------------|--------------------|-------------|------------|
|   PlaScope       |   sample1   |   NODE_23_length_19341_cov_42.265223   |   19341          |   sample1__pl_1  |   5123193        |   160              |   100.0     |   100      |
|   PlasmidSPAdes       |   sample1   |   NODE_10_length_1445_cov_126.680577_component_6  |   154          |   sample1__pl_2  |   5123193        |   154              |   100.0     |   100      |
|   SPAdes       |   sample1   |   NODE_101_length_154_cov_156.222222  |   154          |   sample1__chr  |   5123193        |   154              |   100.0     |   100      |

### 3. AllSamplesQuastResults.tsv

Contains the collated quast results for all tools and all samples. Quast was run with multiple reference genomes provided, once with each individual plasmid from each complete genome, once with all the plasmid contigs combined into one file and once against the chromosome of each sample. The type of reference file used for Quast is in "QuastType". 

| Assembly | <-- Quast Output Columns --> | QuastReferenceSequence | ToolName | QuastType |
|----------| ---------------------|------------------------|----------|-----------|
| sample1.plasmer.predPlasmids | Quast Numbers | sample1__chr | Plasmer | Chromosome |
| sample2.plasmer.predPlasmids | Quast Numbers | sample_1__pl_1 | Plasmer | IndividualPlasmids |
| sample2.plasmid | Quast Numbers | sample_2__allPlasmids | PlasmidSPAdes | CombinedPlasmids |


### Typing and Metrics

The pipeline will also run a number of other tools to provide metrics for input assembly quality and isolate typing. The results from these tools can be found in `results/AllSampleResults/<input_ assembler>_input/Typing`.

Analysis included:
1. AMR prediction from [Kleborate](https://github.com/klebgenomics/Kleborate)
2. Count of dead-ends in assembly graph from [GFA-dead-end-counter](https://github.com/rrwick/GFA-dead-end-counter)
3. Sequencing coverage of plasmid and chromosome from [Minimap2](https://github.com/lh3/minimap2)
4. Count of contig sizes in hybrid and short read only assemblies, using [SeqKit](https://bioinf.shenwei.me/seqkit/)
5. K-mer sharing between plasmids and chromosome using [Mash](https://github.com/marbl/Mash)

# Reproducing analysis

To run this pipeline follow the steps:
1. clone this repo
2. install tools HyAsp and PLASMe manually
3. download plasmid tool databases
4. create conda environment for the nextflow pipeline
5. run setup pipeline to create tool conda envs and database download
6. run full pipeline

Tool conda environments are specified in `condaenvs/` in individual yaml files
Nextflow handles the creation and activation of the conda environments, where possible. They will be created during the SetupConda.nf execution. The environments are stored in `condaenvs/`.

The `nextflow.config` file contains specificationfor maximum CPUs and RAM that the pipeline can use. Adjust these as necessary. For consistency each tool is allocated 8 CPUs for processing, even if the tool does not support multi-threading.

## Clone repository 

Clone this repo with `git clone github.com/C-Connor/PlasmidToolBenchMarking`

## Install tools manually

Unfortunately the tools HyAsp and PLASMe do not work well with Nextflows conda environment management and need to be installed manually.

### HyAsp

```bash
conda create --prefix <your full path to >/PlasmidToolBenchMarking/Nextflow/assets/hyasp_env
conda activate <your full path to >/PlasmidToolBenchMarking/Nextflow/assets/hyasp_env
conda install python blast fastqc sickle-trim cutadapt trim-galore unicycler
cd <your full path to >/PlasmidToolBenchMarking/Nextflow/assets
git clone https://github.com/cchauve/hyasp.git
cd hyasp
python setup.py sdist
pip install dist/hyasp-1.0.0.tar.gz
```

## Download databases for tools

Several of the tools require additional databses to run. Put database files for tools in `assets/` directory. If you'd like to store the databases elsewhere, or already have them downloaded, you can provide the paths in the `nextflow.config` file. 

### Plasmer
```bash
cd assets/
mkdir Plasmer_DB
cd Plasmer_DB
wget https://zenodo.org/records/7030675/files/customizedKraken2DB.tar.xz
wget https://zenodo.org/records/7030675/files/plasmerMainDB.tar.xz
for f in *.tar.xz ; do tar -xf $f ; done
```

### PlaScope
```bash
cd assets/
wget https://zenodo.org/records/1311647/files/Klebsiella_PlaScope.tar.gz
tar -xzf Klebsiella_PlaScope.tar.gz
```

### Platon
```bash
cd assets/
wget https://zenodo.org/record/4066768/files/db.tar.gz
tar -xzf db.tar.gz
mv db Platon_db
```

### PlasmidHunter

PlasmidHunter also requires a database but is coded so that the database downloads itself and an alternative path to the database cannot be provided. The database will be downloaded during the pipeline conda env setup

### HyAsp

```bash
cd assets/hyasp/databases
hyasp create ncbi_database_genes.fasta -p plasmids.csv -b ncbi_blacklist.txt -d -l 500 -m 100 -v
```

### PLASMe

The conda installation for PLASMe can be managed through Nextflow, the database download and formatting needs to be done manually. The database also need to be uncompressed through the PLASMe script, attempting this manually results in a Zip bomb warning.

```bash
cd assets/
git clone https://github.com/HubertTang/PLASMe.git
cd PLASMe
conda env create --prefix <your full path to >/PlasmidToolBenchMarking/Nextflow/assets/PLASMe --file plasme.yaml

#get db
wget https://zenodo.org/record/8046934/files/DB.zip
conda activate <your full path to >/PlasmidToolBenchMarking/Nextflow/assets/PLASMe
#unzip and format db with PLASMe
python PLASMe.py test.fasta test.plasme.fna -c 0.6 -i 0.6 -p 0.5 -t 8
```


## Create conda env for overall pipeline

This creates the environment for launching the nextflow pipeline. The environment contains nextflow and several small tools for processing tool outputs such as blast and csvtk.

```bash
conda env create -f condaenvs/PlasmidBenchMarkingNF.yml
conda activate PlasmidBenchMarkingNF
```

## Add GFA-dead-end-counter binary to `bin/`

This repo contains the binary for linux systems, if you are not running this pipeline on a linux system please replace it with the appropriate binary from [here](https://github.com/rrwick/GFA-dead-end-counter/releases). The binary should be located in `bin/` and be executable.

## Check that python scripts are executable

There are 3 python scripts included in `bin/` which collate the tools results. Check that these are executable otherwise pipeline will throw an error.

## Make input files

The pipeline expects a tab separated input file with columns:
1. Sample identifier
2. Path to forwards / R1 read
3. Path to reverse / R2 read
4. Path to complete / hybrid assembly

Each row is a different sample, with no header row.

Example:

|    |   |   |   |
|----|---|---|---|
| sample1   | /path/to/sample1_r1.fastq.gz | /path/to/sample1_r2.fastq.gz | /path/to/sample2_complete.fasta |
| sample2   | /path/to/sample2_r1.fastq.gz | /path/to/sample2_r2.fastq.gz | /path/to/sample2_complete.fasta |


If the files are consistently named then the input can be made with the commands:
```bash
cd reads_directory/
for f in *.fastq.gz ; do echo ${f%_[1-2]*.fastq.gz} ; done | sort | uniq > ../id.list
cd ..
realpath reads_directory/*_1.fastq.gz > 1.list
realpath reads_directory/*_2.fastq.gz > 2.list
realpath complete_genomes_directory/*.fasta > complete.list
paste id.list 1.list 2.list complete.list > input.tab
```

## Run the SetupConda.nf pipeline

As PlasmidHunter needs to download it's own database, run the SetupConda.nf pipeline to create all the conda envs and download the plasmidhunter database. The pipeline just takes the first sample from the input.tab file and runs all the tools without any processing.
This may take sometime as the pipeline needs to create 6 conda environments and download a database.

```bash
conda activate PlasmidBenchMarkingNF #if environment not already active
nextflow run SetupConda.nf 
```

## Run the full pipeline

If the SetupConda.nf pipeline completed successfully you can run the full pipeline. Important to include the `-with-trace` to capture compute resource usage statistics.

```bash
conda activate PlasmidBenchMarkingNF #if environment not already active
nextflow run main.nf --input_file input.tab -profile lcl -with-trace -with-report
```

This will run all the tools and collate all the results into a directory called `results/AllSampleResults/<input assembler>_input`. Compute resources used will be in a `trace-xxx.txt` file. Results for individual samples are organised in `results/ToolOutputs/<input assembler>_input/<sample identifier>/<toolname>`. The short read assemblies made by the pipeline can be found in `results/ShortReadOnlyAssemblies/<input assembler>/<sample id>`

The pipeline appears to use fewer CPUs than specified as 8 CPUs are allocated to all tool runs despite some not supporting multi-threading.