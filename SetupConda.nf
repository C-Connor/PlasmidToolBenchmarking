include { RunTools } from './workflows/RunAllPlasmidTools'


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
        .first()

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
        .first()

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
        .first()

workflow {
	RunTools(
		sample_reads,
		sample_spades,
		sample_completeAss
		)
}