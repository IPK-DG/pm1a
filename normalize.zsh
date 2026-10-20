#convert a VCF in a tabular file in 3rd normal form (3NF) according to Codd (https://en.wikipedia.org/wiki/Third_normal_form)
#3NF is also referred to as "long format": http://www.cookbook-r.com/Manipulating_data/Converting_data_between_wide_and_long_format/
vcf='200326_Axminster_7A_samtools.vcf.gz'
zcat $vcf | ./normalize.awk > ${vcf:r:r}_normalized.tsv 
