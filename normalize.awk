#!/bin/awk -f

BEGIN{
 OFS="\t"
 #genotype coding, assumes no phasing (i.e. 1/0 does not occur)
 h["1/1"]=2
 h["0/1"]=1
 h["0/0"]=0
}

/^#CHROM/ && !header {
 #read sample names
 for(i = 1; i <= NF; i++)
  s[i]=$i
 header=1
}

#discard indels, multi-allelic variants and gaps in reference
/INDEL/ || $4 == "N" || $5 ~ /,/ || /^#/ { 
 next
}


{
 for(i = 10; i <= NF; i++){
  split($i, a, ":")
  #assumes DP, DV and GT fields in fields 1, 3 and 4 respectively (GT:PL:DP:DV in the 9th columns for the VCF) 
  #does not report genotype with no read coverge (a[3] > 0)
  if(a[3] > 0)
   print $1, $2, $4, $5, $6, s[i], h[a[1]], a[3], a[4]
 }
}
