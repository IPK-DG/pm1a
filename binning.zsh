#count unique (-q20) and non-duplicated primary alignments (-F 3332, see https://broadinstitute.github.io/picard/explain-flags.html) in 1 Mb bins
#${bam:r} syntax is specific to the Z shell: http://zsh.sourceforge.net/Doc/Release/Expansion.html#Modifiers 
bam='Sample_CS_Axminster_7A/Sample_CS_Axminster_7A.bam'
samtools view -q 20 -F 3332 $bam | cut -f 3,4 | awk '{print $1 "\t" int($2 / 1000000) * 1000000}' \
 | uniq -c > ${bam:r}_1Mb_read_count.txt
