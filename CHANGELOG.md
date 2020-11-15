Changelog
==========

<!--

Newest changes should be on top.

This document is user facing. Please word the changes in such a way
that users understand how the changes affect the new version.
-->

version 1.2.0-develop
---------------------
+ Specify tempdir for BCFtools sorting.
+ Exclude GRIDSS from merging.
+ Update Delly docker image
+ Make bcftools indexing optional
+ Structural-variantcalling pipeline: add sorting and change id
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
+ Add WDL task for smoove SV-caller
+ Created a structural variant-calling pipeline
