#data.table > 1.12 was used
library(data.table)

###
### Plot SNP counts in 5 Mb bins
###

#load chromosome lengths, name of loaded object: chrlen
load('161010_CS_v1.0_pseudomolecules_lengths.Rdata')

#load normalized VCF file, only chromosome 7A 
fread('grep chr7A 200326_Axminster_7A_samtools_normalized.tsv')->w
setnames(w, c("chr", "pos", "ref_allele", "alt_allele", "snp_quality", "sample", "gt", "dp", "dv"))

#count non-reference variants with at least 2x coverage in 5 Mb bins
w[dp >= 2 & gt != 0, .N, key=.(chr, bin = pos %/% 5e6 * 5e6)]->y
#merge chromosome lengths to plot 21 chromosomes one after the other
chrlen[, .(chr=agp_chr, off=plot_offset)][y, on="chr"]->y
y[, ppos := off + bin]

#plot a PDF
pdf("200326_CS_Axminster_7A_SNP_counts_along_the_chromosomes.pdf", height=7, width=12)
par(mar=c(5,5,3,1))
y[, plot(bin/1e6, log='', pch=19, N/1e3, las=1, bty='l', col=1, ylab="SNP count per 5 Mb bin (x 1000)", xlab="")]
  title(xpd=NA, xlab="position in IWGSC RefSeqV1 7A (Mb)", line=3)
dev.off()

###
### Plot mapped read counts in 1 Mb bins
###

#load chromosome lengths, name of loaded object: chrlen
load('161010_CS_v1.0_pseudomolecules_lengths.Rdata')

#load read count table
f <- '/filer-dg/agruppen/DG/mascher/cs_axminster_7A_mapping_190301/Sample_CS_Axminster_7A/Sample_CS_Axminster_7A_1Mb_read_count.txt'
data.table(read.table(head=F, f))->a
setnames(a, c("count", "agp_chr", "bin"))
#merge chromosome lengths to plot 21 chromosomes one after the other
chrlen[, .(agp_chr, off=plot_offset)][a, on="agp_chr"]->a
a[, ppos := off + bin]
#exclude sequence not anchored to chromosomes
a[agp_chr != "chrUn"]->a

#plot a high-resolution (600 dpi) PNG file
png("200324_CS_Axminster_7A_mapped_reads_in_1Mb_bins.png", res=600, height=12*200, width=36*200)
par(mar=c(0,5,1,0.5))
par(oma=c(5,0,0,0))
a[, plot(ppos, pch=20, count/1000, las=1, bty='l', col="#00000011", ylab="uniquely mapped reads (x 1000)", xaxt='n', xlab="")]
#lines between chromosomes, there is 100 Mb = 2 * 5e7 white space between chromosomes as specified in chrlen
abline(col="blue", lwd=2, v=chrlen[, plot_offset - 5e7])
#add Loess smoothing
a[, lines(lwd=2, col='red', lowess(f=0.1, ppos, count/1000)), by=agp_chr]
#x axis labels
chrlen[chr %in% 1:21][, axis(1, plot_offset + length/2, alphachr, tick=F, xpd=NA)]
title(xpd=NA, xlab="position in  IWGSC RefSeq V1 reference genome", xpd=NA)
dev.off()
