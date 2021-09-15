Changelog
==========

<!--

Newest changes should be on top.

This document is user facing. Please word the changes in such a way
that users understand how the changes affect the new version.
-->

version 1.2.0
---------------------
+ DELLY: Update docker image.
+ Remove GRIDSS from the pipeline.
+ Exclude GRIDSS from SURVIVOR merging: SVs were only defined as BNDs in GRIDSS.
+ Optional filtering of missing and hom-ref genotypes. 
+ Optional filtering of FP deletions and duplications.
+ Add DUPHOLD: annotate SVs with depth values.
+ Make bcftools indexing optional.
+ Structural-variantcalling pipeline: add sorting and change id.
+ Added GRIDSS sv caller

version 1.1.0
---------------------
+ Bcftools samtools and picard images are updated to newer versions.
+ Bcftools view now converts delly vcf to a gzipped version.
+ Tasks were updated to contain the `time_minutes` runtime attribute and
  associated `timeMinutes` input, describing the maximum time the task will
  take to run.

version 1.0.0
-----------------
+ Add WDL task for smoove SV-caller.
+ Created a structural variant-calling pipeline.
