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
<dt id="SVcalling.annotateDH.memory"><a href="#SVcalling.annotateDH.memory">SVcalling.annotateDH.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"15G"</code><br />
    The memory required to run the programs.
</dd>
<dt id="SVcalling.annotateDH.timeMinutes"><a href="#SVcalling.annotateDH.timeMinutes">SVcalling.annotateDH.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1440</code><br />
    The maximum duration (in minutes) the tool is allowed to run.
</dd>
<dt id="SVcalling.clever.memory"><a href="#SVcalling.clever.memory">SVcalling.clever.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"55G"</code><br />
    The memory required to run the programs.
</dd>
<dt id="SVcalling.clever.threads"><a href="#SVcalling.clever.threads">SVcalling.clever.threads</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>10</code><br />
    The the number of threads required to run a program.
</dd>
<dt id="SVcalling.clever.timeMinutes"><a href="#SVcalling.clever.timeMinutes">SVcalling.clever.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>480</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SVcalling.delly.memory"><a href="#SVcalling.delly.memory">SVcalling.delly.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"15G"</code><br />
    The memory required to run the programs.
</dd>
<dt id="SVcalling.delly.timeMinutes"><a href="#SVcalling.delly.timeMinutes">SVcalling.delly.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>300</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SVcalling.delly2vcf.exclude"><a href="#SVcalling.delly2vcf.exclude">SVcalling.delly2vcf.exclude</a></dt>
<dd>
    <i>String? </i><br />
    Exclude sites for which the expression is true (see man page for details).
</dd>
<dt id="SVcalling.delly2vcf.excludeUncalled"><a href="#SVcalling.delly2vcf.excludeUncalled">SVcalling.delly2vcf.excludeUncalled</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Exclude sites without a called genotype (see man page for details).
</dd>
<dt id="SVcalling.delly2vcf.include"><a href="#SVcalling.delly2vcf.include">SVcalling.delly2vcf.include</a></dt>
<dd>
    <i>String? </i><br />
    Select sites for which the expression is true (see man page for details).
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
    <i>Map[String,String] </i><i>&mdash; Default:</i> <code>{"bcftools": "quay.io/biocontainers/bcftools:1.10.2--h4f4756c_2", "clever": "quay.io/biocontainers/clever-toolkit:2.4--py36hcfe0e84_6", "delly": "quay.io/biocontainers/delly:0.8.1--h4037b6b_1", "manta": "quay.io/biocontainers/manta:1.4.0--py27_1", "picard": "quay.io/biocontainers/picard:2.23.2--0", "samtools": "quay.io/biocontainers/samtools:1.10--h9402c20_2", "survivor": "quay.io/biocontainers/survivor:1.0.6--h6bb024c_0", "smoove": "quay.io/biocontainers/smoove:0.2.5--0", "duphold": "quay.io/biocontainers/duphold:0.2.1--h516909a_1"}</code><br />
    A map describing the docker image used for the tasks.
</dd>
<dt id="SVcalling.excludeFpDupDel"><a href="#SVcalling.excludeFpDupDel">SVcalling.excludeFpDupDel</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Option to exclude false positive duplications and deletions according to DUPHOLD.
</dd>
<dt id="SVcalling.excludeMisHomRef"><a href="#SVcalling.excludeMisHomRef">SVcalling.excludeMisHomRef</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Option to exclude missing and homozygous reference genotypes.
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
    The memory required to run the programs.
</dd>
<dt id="SVcalling.mateclever.threads"><a href="#SVcalling.mateclever.threads">SVcalling.mateclever.threads</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>10</code><br />
    The the number of threads required to run a program.
</dd>
<dt id="SVcalling.mateclever.timeMinutes"><a href="#SVcalling.mateclever.timeMinutes">SVcalling.mateclever.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>600</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SVcalling.newId"><a href="#SVcalling.newId">SVcalling.newId</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"\'%CHROM\\_%POS\'"</code><br />
    Assign ID on the fly (e.g. --set-id +'%CHROM\_%POS').
</dd>
<dt id="SVcalling.removeFpDupDel.exclude"><a href="#SVcalling.removeFpDupDel.exclude">SVcalling.removeFpDupDel.exclude</a></dt>
<dd>
    <i>String? </i><br />
    Exclude sites for which the expression is true (see man page for details).
</dd>
<dt id="SVcalling.removeFpDupDel.excludeUncalled"><a href="#SVcalling.removeFpDupDel.excludeUncalled">SVcalling.removeFpDupDel.excludeUncalled</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Exclude sites without a called genotype (see man page for details).
</dd>
<dt id="SVcalling.removeFpDupDel.memory"><a href="#SVcalling.removeFpDupDel.memory">SVcalling.removeFpDupDel.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"256M"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="SVcalling.removeFpDupDel.timeMinutes"><a href="#SVcalling.removeFpDupDel.timeMinutes">SVcalling.removeFpDupDel.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1 + ceil(size(inputFile,"G"))</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SVcalling.removeMisHomRR.include"><a href="#SVcalling.removeMisHomRR.include">SVcalling.removeMisHomRR.include</a></dt>
<dd>
    <i>String? </i><br />
    Select sites for which the expression is true (see man page for details).
</dd>
<dt id="SVcalling.removeMisHomRR.memory"><a href="#SVcalling.removeMisHomRR.memory">SVcalling.removeMisHomRR.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"256M"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="SVcalling.removeMisHomRR.timeMinutes"><a href="#SVcalling.removeMisHomRR.timeMinutes">SVcalling.removeMisHomRR.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1 + ceil(size(inputFile,"G"))</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SVcalling.renameSample.javaXmx"><a href="#SVcalling.renameSample.javaXmx">SVcalling.renameSample.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"8G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="SVcalling.renameSample.memory"><a href="#SVcalling.renameSample.memory">SVcalling.renameSample.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"9G"</code><br />
    The memory required to run the programs.
</dd>
<dt id="SVcalling.renameSample.timeMinutes"><a href="#SVcalling.renameSample.timeMinutes">SVcalling.renameSample.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1 + ceil((size(inputVcf,"G") * 2))</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SVcalling.setId.annsFile"><a href="#SVcalling.setId.annsFile">SVcalling.setId.annsFile</a></dt>
<dd>
    <i>File? </i><br />
    Bgzip-compressed and tabix-indexed file with annotations (see man page for details).
</dd>
<dt id="SVcalling.setId.collapse"><a href="#SVcalling.setId.collapse">SVcalling.setId.collapse</a></dt>
<dd>
    <i>String? </i><br />
    Treat as identical records with <snps|indels|both|all|some|none>, see man page for details.
</dd>
<dt id="SVcalling.setId.columns"><a href="#SVcalling.setId.columns">SVcalling.setId.columns</a></dt>
<dd>
    <i>Array[String] </i><i>&mdash; Default:</i> <code>[]</code><br />
    Comma-separated list of columns or tags to carry over from the annotation file (see man page for details).
</dd>
<dt id="SVcalling.setId.exclude"><a href="#SVcalling.setId.exclude">SVcalling.setId.exclude</a></dt>
<dd>
    <i>String? </i><br />
    Exclude sites for which the expression is true (see man page for details).
</dd>
<dt id="SVcalling.setId.force"><a href="#SVcalling.setId.force">SVcalling.setId.force</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Continue even when parsing errors, such as undefined tags, are encountered.
</dd>
<dt id="SVcalling.setId.headerLines"><a href="#SVcalling.setId.headerLines">SVcalling.setId.headerLines</a></dt>
<dd>
    <i>File? </i><br />
    Lines to append to the VCF header (see man page for details).
</dd>
<dt id="SVcalling.setId.include"><a href="#SVcalling.setId.include">SVcalling.setId.include</a></dt>
<dd>
    <i>String? </i><br />
    Select sites for which the expression is true (see man page for details).
</dd>
<dt id="SVcalling.setId.keepSites"><a href="#SVcalling.setId.keepSites">SVcalling.setId.keepSites</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Keep sites which do not pass -i and -e expressions instead of discarding them.
</dd>
<dt id="SVcalling.setId.markSites"><a href="#SVcalling.setId.markSites">SVcalling.setId.markSites</a></dt>
<dd>
    <i>String? </i><br />
    Annotate sites which are present ('+') or absent ('-') in the -a file with a new INFO/TAG flag.
</dd>
<dt id="SVcalling.setId.memory"><a href="#SVcalling.setId.memory">SVcalling.setId.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"256M"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="SVcalling.setId.noVersion"><a href="#SVcalling.setId.noVersion">SVcalling.setId.noVersion</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Do not append version and command line information to the output VCF header.
</dd>
<dt id="SVcalling.setId.regions"><a href="#SVcalling.setId.regions">SVcalling.setId.regions</a></dt>
<dd>
    <i>String? </i><br />
    Restrict to comma-separated list of regions.
</dd>
<dt id="SVcalling.setId.regionsFile"><a href="#SVcalling.setId.regionsFile">SVcalling.setId.regionsFile</a></dt>
<dd>
    <i>File? </i><br />
    Restrict to regions listed in a file.
</dd>
<dt id="SVcalling.setId.removeAnns"><a href="#SVcalling.setId.removeAnns">SVcalling.setId.removeAnns</a></dt>
<dd>
    <i>Array[String] </i><i>&mdash; Default:</i> <code>[]</code><br />
    List of annotations to remove (see man page for details).
</dd>
<dt id="SVcalling.setId.renameChrs"><a href="#SVcalling.setId.renameChrs">SVcalling.setId.renameChrs</a></dt>
<dd>
    <i>File? </i><br />
    rename chromosomes according to the map in file (see man page for details).
</dd>
<dt id="SVcalling.setId.samples"><a href="#SVcalling.setId.samples">SVcalling.setId.samples</a></dt>
<dd>
    <i>Array[String] </i><i>&mdash; Default:</i> <code>[]</code><br />
    List of samples for sample stats, "-" to include all samples.
</dd>
<dt id="SVcalling.setId.samplesFile"><a href="#SVcalling.setId.samplesFile">SVcalling.setId.samplesFile</a></dt>
<dd>
    <i>File? </i><br />
    File of samples to include.
</dd>
<dt id="SVcalling.setId.singleOverlaps"><a href="#SVcalling.setId.singleOverlaps">SVcalling.setId.singleOverlaps</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    keep memory requirements low with very large annotation files.
</dd>
<dt id="SVcalling.setId.threads"><a href="#SVcalling.setId.threads">SVcalling.setId.threads</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>0</code><br />
    Number of extra decompression threads [0].
</dd>
<dt id="SVcalling.setId.timeMinutes"><a href="#SVcalling.setId.timeMinutes">SVcalling.setId.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1 + ceil(size(inputFile,"G"))</code><br />
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
<dt id="SVcalling.sort.memory"><a href="#SVcalling.sort.memory">SVcalling.sort.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"256M"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="SVcalling.sort.timeMinutes"><a href="#SVcalling.sort.timeMinutes">SVcalling.sort.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1 + ceil(size(inputFile,"G"))</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
<dt id="SVcalling.survivor.breakpointDistance"><a href="#SVcalling.survivor.breakpointDistance">SVcalling.survivor.breakpointDistance</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1000</code><br />
    The distance between pairwise breakpoints between SVs.
</dd>
<dt id="SVcalling.survivor.distanceBySvSize"><a href="#SVcalling.survivor.distanceBySvSize">SVcalling.survivor.distanceBySvSize</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    A boolean to predict the pairwise distance between the SVs based on their size.
</dd>
<dt id="SVcalling.survivor.memory"><a href="#SVcalling.survivor.memory">SVcalling.survivor.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"24G"</code><br />
    The memory required to run the programs.
</dd>
<dt id="SVcalling.survivor.minSize"><a href="#SVcalling.survivor.minSize">SVcalling.survivor.minSize</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>30</code><br />
    The mimimum size of SV to be merged.
</dd>
<dt id="SVcalling.survivor.strandType"><a href="#SVcalling.survivor.strandType">SVcalling.survivor.strandType</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>true</code><br />
    A boolean to include strand type of an SV to be merged.
</dd>
<dt id="SVcalling.survivor.suppVecs"><a href="#SVcalling.survivor.suppVecs">SVcalling.survivor.suppVecs</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>2</code><br />
    The minimum number of SV callers to support the merging.
</dd>
<dt id="SVcalling.survivor.svType"><a href="#SVcalling.survivor.svType">SVcalling.survivor.svType</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>true</code><br />
    A boolean to include the type SV to be merged.
</dd>
<dt id="SVcalling.survivor.timeMinutes"><a href="#SVcalling.survivor.timeMinutes">SVcalling.survivor.timeMinutes</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>60</code><br />
    The maximum amount of time the job will run in minutes.
</dd>
</dl>
</details>




