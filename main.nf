
include { RunTools } from './workflows/RunAllPlasmidTools'
include { ProcessRuns } from './workflows/ProcessRuns'
include { BlastAndCollate } from './workflows/BlastAndCollate'
include { MakeShortAssemblies } from './workflows/MakeShortAssemblies'
include { TypingDeadendMetrics } from './workflows/TypingDeadendMetrics'

sample_reads = Channel
		.fromPath(params.input_file)
		.splitCsv ( sep:'\t', header:['id','fastq1','fastq2','completeAss'] )
		.map { row ->
			[row.id, 
			[file(row.fastq1, checkIfExists: true), file(row.fastq2, checkIfExists: true)],
			//file(row.completeAss, checkIfExists: true)
			]
		}

sample_completeAss = Channel
		.fromPath(params.input_file)
		.splitCsv ( sep:'\t', header:['id','fastq1','fastq2','completeAss'] )
		.map { row ->
			[row.id, 
			//[file(row.fastq1, checkIfExists: true), file(row.fastq2, checkIfExists: true)],
			file(row.completeAss, checkIfExists: true)
			]
		}

workflow {
	MakeShortAssemblies(sample_reads)

	TypingDeadendMetrics(
		sample_reads,
		sample_completeAss,
		MakeShortAssemblies.out.gfa,
		MakeShortAssemblies.out.contigs
	)

	RunTools(
		sample_reads,
		MakeShortAssemblies.out.contigs,
		MakeShortAssemblies.out.gfa,
		sample_completeAss
		)

	ProcessRuns(
		sample_completeAss,
		MakeShortAssemblies.out.contigs,
		RunTools.out //problem?
		)
		
	BlastAndCollate(
		MakeShortAssemblies.out.contigs,
		sample_completeAss,
		ProcessRuns.out.quastresults,
		ProcessRuns.out.denovo,
		ProcessRuns.out.binaryclassifiers
		)

	publish:
	contigs = MakeShortAssemblies.out.contigs
    merge_results_publish = RunTools.out.merge_results_publish
    //combinedquast = BlastAndCollate.out.combinedquast
    //binarycontigs = BlastAndCollate.out.binarycontigs
    //combinedquast = BlastAndCollate.out.combinedquast
    blast_publish_files = BlastAndCollate.out.blast_publish_files
    typing_publish_files = TypingDeadendMetrics.out.typing_publish_files
}
output {
	//add timestamping here instead?
	contigs {
		path { id, contigs -> "ShortReadOnlyAssemblies/${params.SRassembler}/${id}/" }
	}
	merge_results_publish {
		path { id, files -> "ToolOutputs/${params.SRassembler}_input/${id}/" }
	}
	blast_publish_files {
		path { "AllSampleResults/${params.SRassembler}_input/" }
	}
	typing_publish_files {
		path { "AllSampleResults/${params.SRassembler}_input/MetricsAndTyping/" }
	}
}