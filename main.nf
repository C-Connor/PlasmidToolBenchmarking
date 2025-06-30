
include { RunTools } from './workflows/RunAllPlasmidTools'
include { ProcessRuns } from './workflows/ProcessRuns'
include { BlastAndCollate } from './workflows/BlastAndCollate'

sample_reads = Channel
		.fromPath(params.input_file)
		.splitCsv ( sep:'\t', header:['id','fastq1','fastq2','spadeAss','completeAss'] )
		.map { row ->
			[row.id, 
			[file(row.fastq1, checkIfExists: true), file(row.fastq2, checkIfExists: true)],
			//file(row.spadeAss, checkIfExists: true),
			//file(row.completeAss, checkIfExists: true)
			]
		}

sample_spades = Channel
		.fromPath(params.input_file)
		.splitCsv ( sep:'\t', header:['id','fastq1','fastq2','spadeAss','completeAss'] )
		.map { row ->
			[row.id, 
			//[file(row.fastq1, checkIfExists: true), file(row.fastq2, checkIfExists: true)],
			file(row.spadeAss, checkIfExists: true),
			//file(row.completeAss, checkIfExists: true)
			]
		}

sample_completeAss = Channel
		.fromPath(params.input_file)
		.splitCsv ( sep:'\t', header:['id','fastq1','fastq2','spadeAss','completeAss'] )
		.map { row ->
			[row.id, 
			//[file(row.fastq1, checkIfExists: true), file(row.fastq2, checkIfExists: true)],
			//file(row.spadeAss, checkIfExists: true),
			file(row.completeAss, checkIfExists: true)
			]
		}

workflow {
	RunTools(
		sample_reads,
		sample_spades,
		sample_completeAss
		)

	ProcessRuns(
		sample_completeAss,
		sample_spades,
		RunTools.out
		)
		
	BlastAndCollate(
		sample_spades,
		sample_completeAss,
		ProcessRuns.out.quastresults,
		ProcessRuns.out.denovoassemblers,
		ProcessRuns.out.binaryclassifiers
		)
}