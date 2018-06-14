baseCommand: []
class: CommandLineTool
cwlVersion: v1.0
id: rna2dnalign
inputs:
  bams:
    doc: compressed tarball (*.tar.gz) containing  a .bam & corresponding .bai for
      Normal exome (Nex), normal transcriptome (Ntr), Tumor exome (Tex) and tumor
      transcriptome (Ttr)
    inputBinding:
      position: 1
      prefix: --bams
    type: File
  vcfs:
    doc: compressed tarball (*tar.gz) containing variant files (.vcf) for Normal exome
      (Nex), normal transcriptome (Ntr), Tumor exome (Tex) and tumor transcriptome
      (Ttr)
    inputBinding:
      position: 2
      prefix: --vcfs
    type: File
label: RNA2DNAlign
outputs:
  event_summaries:
    doc: tarball containing event summaries and read-counts for analysis
    outputBinding:
      glob: event_summaries/*
    type: File
requirements:
- class: DockerRequirement
  dockerOutputDirectory: /data/out
  dockerPull: pfda2dockstore/rna2dnalign:6
s:author:
  class: s:Person
  s:name: keylie gibson
