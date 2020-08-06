---
layout: default
title: "Inputs: SVcalling"
---

# Inputs for SVcalling

The following is an overview of all available inputs in
SVcalling.


## Required inputs
<dl>
<dt id="SVcalling.bamFile"><a href="#SVcalling.bamFile">SVcalling.bamFile</a></dt>
<dd>
    <i>File </i><br />
    sorted BAM file
</dd>
<dt id="SVcalling.bamIndex"><a href="#SVcalling.bamIndex">SVcalling.bamIndex</a></dt>
<dd>
    <i>File </i><br />
    BAM index(.bai) file
</dd>
<dt id="SVcalling.bwaIndex"><a href="#SVcalling.bwaIndex">SVcalling.bwaIndex</a></dt>
<dd>
    <i>struct(fastaFile : File, indexFiles : Array[File]) </i><br />
    Struct containing the BWA reference files
</dd>
<dt id="SVcalling.manta.cores"><a href="#SVcalling.manta.cores">SVcalling.manta.cores</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1</code><br />
    The the number of cores required to run a program
</dd>
<dt id="SVcalling.manta.memoryGb"><a href="#SVcalling.manta.memoryGb">SVcalling.manta.memoryGb</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>4</code><br />
    The memory required to run the manta
</dd>
<dt id="SVcalling.referenceFasta"><a href="#SVcalling.referenceFasta">SVcalling.referenceFasta</a></dt>
<dd>
    <i>File </i><br />
    The reference fasta file
</dd>
<dt id="SVcalling.referenceFastaDict"><a href="#SVcalling.referenceFastaDict">SVcalling.referenceFastaDict</a></dt>
<dd>
    <i>File </i><br />
    Sequence dictionary (.dict) file of the reference
</dd>
<dt id="SVcalling.referenceFastaFai"><a href="#SVcalling.referenceFastaFai">SVcalling.referenceFastaFai</a></dt>
<dd>
    <i>File </i><br />
    Fasta index (.fai) file of the reference
</dd>
<dt id="SVcalling.sample"><a href="#SVcalling.sample">SVcalling.sample</a></dt>
<dd>
    <i>String </i><br />
    The name of the sample
</dd>
</dl>

## Other common inputs
<dl>
<dt id="SVcalling.manta.callRegions"><a href="#SVcalling.manta.callRegions">SVcalling.manta.callRegions</a></dt>
<dd>
    <i>File? </i><br />
    The bed file which indicates the regions to operate on.
</dd>
<dt id="SVcalling.manta.callRegionsIndex"><a href="#SVcalling.manta.callRegionsIndex">SVcalling.manta.callRegionsIndex</a></dt>
<dd>
    <i>File? </i><br />
    The index of the bed file which indicates the regions to operate on.
</dd>
<dt id="SVcalling.manta.exome"><a href="#SVcalling.manta.exome">SVcalling.manta.exome</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Whether or not the data is from exome sequencing.
</dd>
<dt id="SVcalling.outputDir"><a href="#SVcalling.outputDir">SVcalling.outputDir</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"."</code><br />
    The directory the output should be written to.
</dd>
</dl>

## Advanced inputs
<details>
<summary> Show/Hide </summary>
<dl>
<dt id="SVcalling.clever.memory"><a href="#SVcalling.clever.memory">SVcalling.clever.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"55G"</code><br />
    The memory required to run the programs
</dd>
<dt id="SVcalling.clever.threads"><a href="#SVcalling.clever.threads">SVcalling.clever.threads</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>10</code><br />
    The the number of threads required to run a program
</dd>
<dt id="SVcalling.clever.timeMinutes"><a href="#SVcalling.clever.timeMinutes">SVcalling.clever.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>480</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SVcalling.delly.memory"><a href="#SVcalling.delly.memory">SVcalling.delly.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"15G"</code><br />
    The memory required to run the programs
</dd>
<dt id="SVcalling.delly.timeMinutes"><a href="#SVcalling.delly.timeMinutes">SVcalling.delly.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>300</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SVcalling.delly2vcf.compressionLevel"><a href="#SVcalling.delly2vcf.compressionLevel">SVcalling.delly2vcf.compressionLevel</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1</code><br />
    Compression level from 0 (uncompressed) to 9 (best).
</dd>
<dt id="SVcalling.delly2vcf.memory"><a href="#SVcalling.delly2vcf.memory">SVcalling.delly2vcf.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"256M"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="SVcalling.delly2vcf.timeMinutes"><a href="#SVcalling.delly2vcf.timeMinutes">SVcalling.delly2vcf.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1 + ceil(size(inputFile,"G"))</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SVcalling.dockerImages"><a href="#SVcalling.dockerImages">SVcalling.dockerImages</a></dt>
<dd>
    <i>Map[String,String] </i><i>&mdash; Default:</i> <code>{"bcftools": "quay.io/biocontainers/bcftools:1.10.2--h4f4756c_2", "clever": "quay.io/biocontainers/clever-toolkit:2.4--py36hcfe0e84_6", "delly": "quay.io/biocontainers/delly:0.8.1--h4037b6b_1", "manta": "quay.io/biocontainers/manta:1.4.0--py27_1", "picard": "quay.io/biocontainers/picard:2.23.2--0", "samtools": "quay.io/biocontainers/samtools:1.10--h9402c20_2", "survivor": "quay.io/biocontainers/survivor:1.0.6--h6bb024c_0", "smoove": "quay.io/biocontainers/smoove:0.2.5--0"}</code><br />
    A map describing the docker image used for the tasks.
</dd>
<dt id="SVcalling.FilterShortReadsBam.memory"><a href="#SVcalling.FilterShortReadsBam.memory">SVcalling.FilterShortReadsBam.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"1G"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="SVcalling.FilterShortReadsBam.timeMinutes"><a href="#SVcalling.FilterShortReadsBam.timeMinutes">SVcalling.FilterShortReadsBam.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1 + ceil((size(bamFile,"G") * 8))</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SVcalling.manta.timeMinutes"><a href="#SVcalling.manta.timeMinutes">SVcalling.manta.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>60</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SVcalling.mateclever.cleverMaxDelLength"><a href="#SVcalling.mateclever.cleverMaxDelLength">SVcalling.mateclever.cleverMaxDelLength</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>100000</code><br />
    The maximum deletion length to look for in Clever predictions.
</dd>
<dt id="SVcalling.mateclever.maxLengthDiff"><a href="#SVcalling.mateclever.maxLengthDiff">SVcalling.mateclever.maxLengthDiff</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>30</code><br />
    The maximum length difference between split-read and read-pair deletion to be considered identical.
</dd>
<dt id="SVcalling.mateclever.maxOffset"><a href="#SVcalling.mateclever.maxOffset">SVcalling.mateclever.maxOffset</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>150</code><br />
    The maximum center distance between split-read and read-pair deletion to be considered identical.
</dd>
<dt id="SVcalling.mateclever.memory"><a href="#SVcalling.mateclever.memory">SVcalling.mateclever.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"15G"</code><br />
    The memory required to run the programs
</dd>
<dt id="SVcalling.mateclever.threads"><a href="#SVcalling.mateclever.threads">SVcalling.mateclever.threads</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>10</code><br />
    The the number of threads required to run a program
</dd>
<dt id="SVcalling.mateclever.timeMinutes"><a href="#SVcalling.mateclever.timeMinutes">SVcalling.mateclever.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>600</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SVcalling.renameSample.javaXmx"><a href="#SVcalling.renameSample.javaXmx">SVcalling.renameSample.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"8G"</code><br />
    The max. memory allocated for JAVA
</dd>
<dt id="SVcalling.renameSample.memory"><a href="#SVcalling.renameSample.memory">SVcalling.renameSample.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"9G"</code><br />
    The memory required to run the programs
</dd>
<dt id="SVcalling.renameSample.timeMinutes"><a href="#SVcalling.renameSample.timeMinutes">SVcalling.renameSample.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1 + ceil((size(inputVcf,"G") * 2))</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SVcalling.smoove.memory"><a href="#SVcalling.smoove.memory">SVcalling.smoove.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"15G"</code><br />
    The memory required to run the programs.
</dd>
<dt id="SVcalling.smoove.timeMinutes"><a href="#SVcalling.smoove.timeMinutes">SVcalling.smoove.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1440</code><br />
    The maximum duration (in minutes) the tool is allowed to run.
</dd>
<dt id="SVcalling.survivor.breakpointDistance"><a href="#SVcalling.survivor.breakpointDistance">SVcalling.survivor.breakpointDistance</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1000</code><br />
    The distance between pairwise breakpoints between SVs
</dd>
<dt id="SVcalling.survivor.distanceBySvSize"><a href="#SVcalling.survivor.distanceBySvSize">SVcalling.survivor.distanceBySvSize</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>0</code><br />
    A boolean to predict the pairwise distance between the SVs based on their size
</dd>
<dt id="SVcalling.survivor.memory"><a href="#SVcalling.survivor.memory">SVcalling.survivor.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"24G"</code><br />
    The memory required to run the programs
</dd>
<dt id="SVcalling.survivor.minSize"><a href="#SVcalling.survivor.minSize">SVcalling.survivor.minSize</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>30</code><br />
    The mimimum size of SV to be merged
</dd>
<dt id="SVcalling.survivor.strandType"><a href="#SVcalling.survivor.strandType">SVcalling.survivor.strandType</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1</code><br />
    A boolean to include strand type of an SV to be merged
</dd>
<dt id="SVcalling.survivor.suppVecs"><a href="#SVcalling.survivor.suppVecs">SVcalling.survivor.suppVecs</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>2</code><br />
    The minimum number of SV callers to support the merging
</dd>
<dt id="SVcalling.survivor.svType"><a href="#SVcalling.survivor.svType">SVcalling.survivor.svType</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1</code><br />
    A boolean to include the type SV to be merged
</dd>
<dt id="SVcalling.survivor.timeMinutes"><a href="#SVcalling.survivor.timeMinutes">SVcalling.survivor.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>60</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
</dl>
</details>



## Other inputs
<details>
<summary> Show/Hide </summary>
<dl>
<dt id="SVcalling.delly2vcf.outputType"><a href="#SVcalling.delly2vcf.outputType">SVcalling.delly2vcf.outputType</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"z"</code><br />
    Output type: v=vcf, z=vcf.gz, b=bcf, u=uncompressed bcf
</dd>
</dl>
</details>


