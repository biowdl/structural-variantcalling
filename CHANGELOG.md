Changelog
==========

<!--

Newest changes should be on top.

This document is user facing. Please word the changes in such a way
that users understand how the changes affect the new version.
-->
version 1.3.0-dev
---------------------
+ Added a workflow for somatic SV calling using GRIDSS, delly and manta.
+ Clever is now disabled by default. It can be enabled by setting `SVcalling.runClever` to `true`.
+ Fixed a bug which led to the removal of all BND, INS and INV events if DUPHOLD was enabled.
+ Updated SURVIVOR version to 1.0.7.
+ Added a workaround for a bug in survivor which caused the END of events detected by CLEVER to be calculated
  incorrectly resulting in incorrect merging of events. 
+ The gridss outputs are now included in survivor as well.
+ Smoove can now be disabled, by setting `SVcalling.runSmoove` to `false`.
+ Added Gridss as SV caller.
+ Fix order of input VCF files when removing missing and homozygous reference genotypes.
+ Each SV type has now seperate temporary directory during sorting.
+ Both union and intersection from each SV types are generated. 
+ The pipeline now first seperate SVs by types before merging.
+ Duphold can now be run optionally to annotate and remove FP deletions and duplications.
+ Replace excludeFpDupDel-option with runDuphold-option: DupHold annotation and FP filtering are now optional together.
+ Update CLEVER dockerimage.
+ DELLY: Update docker image.

version 1.2.0
---------------------
+ Structural-variantcalling pipeline: Remove GRIDSS from the pipeline.
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
