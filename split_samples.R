sample_file <- snakemake@input[["sample_file"]]
samples  <- scan (sample_file,what="character")
n_batches <- snakemake@params[["nbatches"]]
batch_size  <-  ceiling(length (samples)/n_batches);batch_size 
out_files <- snakemake@output[["out_files"]]


n <- 1
batch  <- 0
while (n >0) {
    batch  <- batch+1
    mysamp <- samples [1:batch_size]
    mysamp  <- mysamp [!is.na (mysamp)]
    write.table (outfiles[batch], paste0("sample_batch_", batch, ".txt"),col.names=F,row.names=F,quote=F)
    samples<- samples [-c(1:batch_size)]
    
    n  <- length(samples)
    cat (batch, "\n")

}
