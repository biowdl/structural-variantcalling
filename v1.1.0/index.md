---
layout: default
title: Structural-Variantcalling
---

This pipeline merges the SV predictions from Delly, Manta, Mateclever, and Smoove using SURVIVOR merge. 

This pipeline is part of [BioWDL](https://biowdl.github.io/)
developed by the SASC team at [Leiden University Medical Center](https://www.lumc.nl/).

## Usage
You can run the pipeline using
[Cromwell](http://cromwell.readthedocs.io/en/stable/):
```bash
java -jar cromwell-<version>.jar run -i inputs.json structural-variantcalling.wdl
```

### Inputs
Inputs are provided through a JSON file. The minimally required inputs are
described below, but additional inputs are available.
A template containing all possible inputs can be generated using
Womtool as described in the
[WOMtool documentation](https://cromwell.readthedocs.io/en/stable/WOMtool/).
For overviews of all available inputs, see [this page](./inputs.html)

```json
{
  "SVcalling.outputDir": "The directory the output should be written to.",
  "SVcalling.referenceFasta": "The reference fasta file",
  "SVcalling.referenceFastaFai": "Fasta index (.fai) file of the reference",
  "SVcalling.referenceFastaDict": "Sequence dictionary (.dict) file of the reference",
  "SVcalling.bamFile": "sorted BAM file",
  "SVcalling.bamIndex": "BAM index(.bai) file",
  "SVcalling.bwaIndex": "Struct containing the BWA reference files",
  "SVcalling.sample": "The name of the sample"
}
```

#### Example
The following is an example of what an inputs JSON might look like:
```json
{
  "SVcalling.bamIndex": "tests/data/ref_with_svs.bai",
  "SVcalling.sample": "sample",
  "SVcalling.referenceFastaFai": "tests/data/reference/reference.fasta.fai",
  "SVcalling.referenceFasta": "tests/data/reference/reference.fasta",
  "SVcalling.bamFile": "tests/data/ref_with_svs.bam",
  "SVcalling.referenceFastaDict": "tests/data/reference/reference.dict",
  "SVcalling.bwaIndex": {
    "fastaFile": "tests/data/reference/bwa/reference.fasta",
    "indexFiles": [
        "tests/data/reference/bwa/reference.fasta.sa",
        "tests/data/reference/bwa/reference.fasta.amb",
        "tests/data/reference/bwa/reference.fasta.ann",
        "tests/data/reference/bwa/reference.fasta.bwt",
        "tests/data/reference/bwa/reference.fasta.pac"
    ]
  }
}
```

### Dependency requirements and tool versions
Biowdl pipelines use docker images to ensure  reproducibility. This
means that biowdl pipelines will run on any system that has docker
installed. Alternatively they can be run with singularity.

For more advanced configuration of docker or singularity please check
the [cromwell documentation on containers](
https://cromwell.readthedocs.io/en/stable/tutorials/Containers/).

Images from [biocontainers](https://biocontainers.pro) are preferred for
biowdl pipelines. The list of default images for this pipeline can be
found in the default for the `dockerImages` input.

### Output
This pipeline produces VCF files from Delly, Manta, and Mateclever, as well as the merged VCF file from SURVIVOR. 

## Contact
<p>
  <!-- Obscure e-mail address for spammers -->
For any questions about running this pipeline and feature request (such as
adding additional tools and options), please use the
<a href='https://github.com/biowdl/structural-variantcalling/issues'>github issue tracker</a>
or contact the SASC team directly at: 
<a href='&#109;&#97;&#105;&#108;&#116;&#111;&#58;&#115;&#97;&#115;&#99;&#64;&#108;&#117;&#109;&#99;&#46;&#110;&#108;'>
&#115;&#97;&#115;&#99;&#64;&#108;&#117;&#109;&#99;&#46;&#110;&#108;</a>.
</p>
