---
layout: default
title: "Inputs: SomaticSvCalling"
---

# Inputs for SomaticSvCalling

The following is an overview of all available inputs in
SomaticSvCalling.


## Required inputs
<dl>
<dt id="SomaticSvCalling.bwaIndex"><a href="#SomaticSvCalling.bwaIndex">SomaticSvCalling.bwaIndex</a></dt>
<dd>
    <i>BwaIndex </i><br />
    The BWA index for the reference genome.
</dd>
<dt id="SomaticSvCalling.normalBamIndexes"><a href="#SomaticSvCalling.normalBamIndexes">SomaticSvCalling.normalBamIndexes</a></dt>
<dd>
    <i>Array[File] </i><br />
    The indexes for the normal BAM files in the same order as the BAM files.
</dd>
<dt id="SomaticSvCalling.normalBams"><a href="#SomaticSvCalling.normalBams">SomaticSvCalling.normalBams</a></dt>
<dd>
    <i>Array[File] </i><br />
    The BAM files for the normal samples in the same order as IDs.
</dd>
<dt id="SomaticSvCalling.normalIds"><a href="#SomaticSvCalling.normalIds">SomaticSvCalling.normalIds</a></dt>
<dd>
    <i>Array[String] </i><br />
    The IDs of the normal samples in the same order as the BAM files.
</dd>
<dt id="SomaticSvCalling.pairs"><a href="#SomaticSvCalling.pairs">SomaticSvCalling.pairs</a></dt>
<dd>
    <i>Array[Pair[String,String]] </i><br />
    The tumor-normal pairs. The left element is the ID for the tumor and the right element is the ID for the associated normal.
</dd>
<dt id="SomaticSvCalling.referenceFasta"><a href="#SomaticSvCalling.referenceFasta">SomaticSvCalling.referenceFasta</a></dt>
<dd>
    <i>File </i><br />
    The FASTA file for the reference genome.
</dd>
<dt id="SomaticSvCalling.referenceFastaFai"><a href="#SomaticSvCalling.referenceFastaFai">SomaticSvCalling.referenceFastaFai</a></dt>
<dd>
    <i>File </i><br />
    The index for the reference genomes FASTA file.
</dd>
<dt id="SomaticSvCalling.tumorBamIndexes"><a href="#SomaticSvCalling.tumorBamIndexes">SomaticSvCalling.tumorBamIndexes</a></dt>
<dd>
    <i>Array[File] </i><br />
    The indexes for the tumor BAM files in the same order as the BAM files.
</dd>
<dt id="SomaticSvCalling.tumorBams"><a href="#SomaticSvCalling.tumorBams">SomaticSvCalling.tumorBams</a></dt>
<dd>
    <i>Array[File] </i><br />
    The BAM files for the tumor samples in the same order as IDs.
</dd>
<dt id="SomaticSvCalling.tumorIds"><a href="#SomaticSvCalling.tumorIds">SomaticSvCalling.tumorIds</a></dt>
<dd>
    <i>Array[String] </i><br />
    The IDs of the tumor samples in the same order as the BAM files.
</dd>
</dl>

## Other common inputs
<dl>
<dt id="SomaticSvCalling.gridssPonBed"><a href="#SomaticSvCalling.gridssPonBed">SomaticSvCalling.gridssPonBed</a></dt>
<dd>
    <i>File? </i><br />
    A premade PON single breakend BED file for GRIDSS.
</dd>
<dt id="SomaticSvCalling.gridssPonBedpe"><a href="#SomaticSvCalling.gridssPonBedpe">SomaticSvCalling.gridssPonBedpe</a></dt>
<dd>
    <i>File? </i><br />
    A premade PON breakpoint BEDPE file for GRIDSS.
</dd>
<dt id="SomaticSvCalling.mantaSomatic.callRegions"><a href="#SomaticSvCalling.mantaSomatic.callRegions">SomaticSvCalling.mantaSomatic.callRegions</a></dt>
<dd>
    <i>File? </i><br />
    The bed file which indicates the regions to operate on.
</dd>
<dt id="SomaticSvCalling.mantaSomatic.callRegionsIndex"><a href="#SomaticSvCalling.mantaSomatic.callRegionsIndex">SomaticSvCalling.mantaSomatic.callRegionsIndex</a></dt>
<dd>
    <i>File? </i><br />
    The index of the bed file which indicates the regions to operate on.
</dd>
<dt id="SomaticSvCalling.mantaSomatic.exome"><a href="#SomaticSvCalling.mantaSomatic.exome">SomaticSvCalling.mantaSomatic.exome</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Whether or not the data is from exome sequencing.
</dd>
<dt id="SomaticSvCalling.outputDir"><a href="#SomaticSvCalling.outputDir">SomaticSvCalling.outputDir</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"."</code><br />
    The directory the output should be written to.
</dd>
</dl>

## Advanced inputs
<details>
<summary> Show/Hide </summary>
<dl>
<dt id="SomaticSvCalling.dellyCall.dockerImage"><a href="#SomaticSvCalling.dellyCall.dockerImage">SomaticSvCalling.dellyCall.dockerImage</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"quay.io/biocontainers/delly:1.1.6--ha41ced6_0"</code><br />
    The docker image used for this task. Changing this may result in errors which the developers may choose not to address.
</dd>
<dt id="SomaticSvCalling.dellyCall.genotypeBcf"><a href="#SomaticSvCalling.dellyCall.genotypeBcf">SomaticSvCalling.dellyCall.genotypeBcf</a></dt>
<dd>
    <i>File? </i><br />
    A BCF with SVs to get genotyped in the samples.
</dd>
<dt id="SomaticSvCalling.dellyCall.genotypeBcfIndex"><a href="#SomaticSvCalling.dellyCall.genotypeBcfIndex">SomaticSvCalling.dellyCall.genotypeBcfIndex</a></dt>
<dd>
    <i>File? </i><br />
    The index for the genotype BCF file.
</dd>
<dt id="SomaticSvCalling.dellyCall.memory"><a href="#SomaticSvCalling.dellyCall.memory">SomaticSvCalling.dellyCall.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"15GiB"</code><br />
    The memory required to run the programs.
</dd>
<dt id="SomaticSvCalling.dellyCall.timeMinutes"><a href="#SomaticSvCalling.dellyCall.timeMinutes">SomaticSvCalling.dellyCall.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>300</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SomaticSvCalling.dellyGenotypeNormals.dockerImage"><a href="#SomaticSvCalling.dellyGenotypeNormals.dockerImage">SomaticSvCalling.dellyGenotypeNormals.dockerImage</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"quay.io/biocontainers/delly:1.1.6--ha41ced6_0"</code><br />
    The docker image used for this task. Changing this may result in errors which the developers may choose not to address.
</dd>
<dt id="SomaticSvCalling.dellyGenotypeNormals.memory"><a href="#SomaticSvCalling.dellyGenotypeNormals.memory">SomaticSvCalling.dellyGenotypeNormals.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"15GiB"</code><br />
    The memory required to run the programs.
</dd>
<dt id="SomaticSvCalling.dellyGenotypeNormals.timeMinutes"><a href="#SomaticSvCalling.dellyGenotypeNormals.timeMinutes">SomaticSvCalling.dellyGenotypeNormals.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>300</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SomaticSvCalling.dellyPonFilter.dockerImage"><a href="#SomaticSvCalling.dellyPonFilter.dockerImage">SomaticSvCalling.dellyPonFilter.dockerImage</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"quay.io/biocontainers/delly:1.1.6--ha41ced6_0"</code><br />
    The docker image used for this task. Changing this may result in errors which the developers may choose not to address.
</dd>
<dt id="SomaticSvCalling.dellyPonFilter.memory"><a href="#SomaticSvCalling.dellyPonFilter.memory">SomaticSvCalling.dellyPonFilter.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"15GiB"</code><br />
    The memory required to run the programs.
</dd>
<dt id="SomaticSvCalling.dellyPonFilter.timeMinutes"><a href="#SomaticSvCalling.dellyPonFilter.timeMinutes">SomaticSvCalling.dellyPonFilter.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>300</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SomaticSvCalling.dellySomaticFilter.dockerImage"><a href="#SomaticSvCalling.dellySomaticFilter.dockerImage">SomaticSvCalling.dellySomaticFilter.dockerImage</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"quay.io/biocontainers/delly:1.1.6--ha41ced6_0"</code><br />
    The docker image used for this task. Changing this may result in errors which the developers may choose not to address.
</dd>
<dt id="SomaticSvCalling.dellySomaticFilter.memory"><a href="#SomaticSvCalling.dellySomaticFilter.memory">SomaticSvCalling.dellySomaticFilter.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"15GiB"</code><br />
    The memory required to run the programs.
</dd>
<dt id="SomaticSvCalling.dellySomaticFilter.timeMinutes"><a href="#SomaticSvCalling.dellySomaticFilter.timeMinutes">SomaticSvCalling.dellySomaticFilter.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>300</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SomaticSvCalling.filterGridssPon.dockerImage"><a href="#SomaticSvCalling.filterGridssPon.dockerImage">SomaticSvCalling.filterGridssPon.dockerImage</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"quay.io/biowdl/gridss:2.12.2"</code><br />
    The docker image used for this task. Changing this may result in errors which the developers may choose not to address.
</dd>
<dt id="SomaticSvCalling.filterGridssPon.memory"><a href="#SomaticSvCalling.filterGridssPon.memory">SomaticSvCalling.filterGridssPon.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"1GiB"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="SomaticSvCalling.filterGridssPon.minimumScore"><a href="#SomaticSvCalling.filterGridssPon.minimumScore">SomaticSvCalling.filterGridssPon.minimumScore</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>3</code><br />
    The minimum number normal samples an SV must have been found in to be kept.
</dd>
<dt id="SomaticSvCalling.filterGridssPon.timeMinutes"><a href="#SomaticSvCalling.filterGridssPon.timeMinutes">SomaticSvCalling.filterGridssPon.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>20</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SomaticSvCalling.generateGridssPon.dockerImage"><a href="#SomaticSvCalling.generateGridssPon.dockerImage">SomaticSvCalling.generateGridssPon.dockerImage</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"quay.io/biowdl/gridss:2.12.2"</code><br />
    The docker image used for this task. Changing this may result in errors which the developers may choose not to address.
</dd>
<dt id="SomaticSvCalling.generateGridssPon.javaXmx"><a href="#SomaticSvCalling.generateGridssPon.javaXmx">SomaticSvCalling.generateGridssPon.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"8G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="SomaticSvCalling.generateGridssPon.memory"><a href="#SomaticSvCalling.generateGridssPon.memory">SomaticSvCalling.generateGridssPon.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"9GiB"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="SomaticSvCalling.generateGridssPon.threads"><a href="#SomaticSvCalling.generateGridssPon.threads">SomaticSvCalling.generateGridssPon.threads</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>8</code><br />
    The number of the threads to use.
</dd>
<dt id="SomaticSvCalling.generateGridssPon.timeMinutes"><a href="#SomaticSvCalling.generateGridssPon.timeMinutes">SomaticSvCalling.generateGridssPon.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>120</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SomaticSvCalling.gridssSomaticFilter.dockerImage"><a href="#SomaticSvCalling.gridssSomaticFilter.dockerImage">SomaticSvCalling.gridssSomaticFilter.dockerImage</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"quay.io/biowdl/gridss:2.12.2"</code><br />
    The docker image used for this task. Changing this may result in errors which the developers may choose not to address.
</dd>
<dt id="SomaticSvCalling.gridssSomaticFilter.memory"><a href="#SomaticSvCalling.gridssSomaticFilter.memory">SomaticSvCalling.gridssSomaticFilter.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"16GiB"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="SomaticSvCalling.gridssSomaticFilter.timeMinutes"><a href="#SomaticSvCalling.gridssSomaticFilter.timeMinutes">SomaticSvCalling.gridssSomaticFilter.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>60</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SomaticSvCalling.groupedGridss.blacklistBed"><a href="#SomaticSvCalling.groupedGridss.blacklistBed">SomaticSvCalling.groupedGridss.blacklistBed</a></dt>
<dd>
    <i>File? </i><br />
    A bed file with blaclisted regins.
</dd>
<dt id="SomaticSvCalling.groupedGridss.dockerImage"><a href="#SomaticSvCalling.groupedGridss.dockerImage">SomaticSvCalling.groupedGridss.dockerImage</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"quay.io/biowdl/gridss:2.12.2"</code><br />
    The docker image used for this task. Changing this may result in errors which the developers may choose not to address.
</dd>
<dt id="SomaticSvCalling.groupedGridss.gridssProperties"><a href="#SomaticSvCalling.groupedGridss.gridssProperties">SomaticSvCalling.groupedGridss.gridssProperties</a></dt>
<dd>
    <i>File? </i><br />
    A properties file for gridss.
</dd>
<dt id="SomaticSvCalling.groupedGridss.jvmHeapSizeGb"><a href="#SomaticSvCalling.groupedGridss.jvmHeapSizeGb">SomaticSvCalling.groupedGridss.jvmHeapSizeGb</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>64</code><br />
    The size of JVM heap for assembly and variant calling
</dd>
<dt id="SomaticSvCalling.groupedGridss.nonJvmMemoryGb"><a href="#SomaticSvCalling.groupedGridss.nonJvmMemoryGb">SomaticSvCalling.groupedGridss.nonJvmMemoryGb</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>10</code><br />
    The amount of memory in Gb to be requested besides JVM memory.
</dd>
<dt id="SomaticSvCalling.groupedGridss.threads"><a href="#SomaticSvCalling.groupedGridss.threads">SomaticSvCalling.groupedGridss.threads</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>12</code><br />
    The number of the threads to use.
</dd>
<dt id="SomaticSvCalling.groupedGridss.timeMinutes"><a href="#SomaticSvCalling.groupedGridss.timeMinutes">SomaticSvCalling.groupedGridss.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>ceil((7200 / threads)) + 1800</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SomaticSvCalling.mantaSomatic.cores"><a href="#SomaticSvCalling.mantaSomatic.cores">SomaticSvCalling.mantaSomatic.cores</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1</code><br />
    The number of cores to use.
</dd>
<dt id="SomaticSvCalling.mantaSomatic.dockerImage"><a href="#SomaticSvCalling.mantaSomatic.dockerImage">SomaticSvCalling.mantaSomatic.dockerImage</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"quay.io/biocontainers/manta:1.4.0--py27_1"</code><br />
    The docker image used for this task. Changing this may result in errors which the developers may choose not to address.
</dd>
<dt id="SomaticSvCalling.mantaSomatic.memoryGb"><a href="#SomaticSvCalling.mantaSomatic.memoryGb">SomaticSvCalling.mantaSomatic.memoryGb</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>4</code><br />
    The amount of memory this job will use in Gigabytes.
</dd>
<dt id="SomaticSvCalling.mantaSomatic.timeMinutes"><a href="#SomaticSvCalling.mantaSomatic.timeMinutes">SomaticSvCalling.mantaSomatic.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>2880</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SomaticSvCalling.normalPosition.dockerImage"><a href="#SomaticSvCalling.normalPosition.dockerImage">SomaticSvCalling.normalPosition.dockerImage</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"python@sha256:e0f6a4df17d5707637fa3557ab266f44dddc46ebfc82b0f1dbe725103961da4e"</code><br />
    The docker image used for this task. Changing this may result in errors which the developers may choose not to address.
</dd>
<dt id="SomaticSvCalling.normalPositionGridss.dockerImage"><a href="#SomaticSvCalling.normalPositionGridss.dockerImage">SomaticSvCalling.normalPositionGridss.dockerImage</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"python@sha256:e0f6a4df17d5707637fa3557ab266f44dddc46ebfc82b0f1dbe725103961da4e"</code><br />
    The docker image used for this task. Changing this may result in errors which the developers may choose not to address.
</dd>
<dt id="SomaticSvCalling.tumorPosition.dockerImage"><a href="#SomaticSvCalling.tumorPosition.dockerImage">SomaticSvCalling.tumorPosition.dockerImage</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"python@sha256:e0f6a4df17d5707637fa3557ab266f44dddc46ebfc82b0f1dbe725103961da4e"</code><br />
    The docker image used for this task. Changing this may result in errors which the developers may choose not to address.
</dd>
<dt id="SomaticSvCalling.tumorPositionGridss.dockerImage"><a href="#SomaticSvCalling.tumorPositionGridss.dockerImage">SomaticSvCalling.tumorPositionGridss.dockerImage</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"python@sha256:e0f6a4df17d5707637fa3557ab266f44dddc46ebfc82b0f1dbe725103961da4e"</code><br />
    The docker image used for this task. Changing this may result in errors which the developers may choose not to address.
</dd>
</dl>
</details>




