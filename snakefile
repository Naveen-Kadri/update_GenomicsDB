REF="/cluster/work/pausch/inputs/ref/BTA/UCD1.2/ARS-UCD1.2_Btau5.0.1Y.fa"
genomicsDB_dir="/cluster/work/pausch/temp_scratch/naveen/Genomics_db/"
chromosomes=range (9,30)
gvcf_dir="/cluster/work/pausch/temp_scratch/naveen/gvcf"
sample_file="/cluster/work/pausch/naveen/VARCAL_2020_08/JOINTGENOTYPING/BUILDDB/sample.txt"

nbatches=20
batches=range (1, nbatches+1)
maxi=max(batches)
#batches=glob_wildcards("sample_batch_{batch}.txt").batch
#int_batches = [int(batch) for batch in batches]
#maxi=max (int_batches)
##print (maxi)



rule all:
    input:
        expand(genomicsDB_dir + "CHR{chr}_v{batch}", batch=[1, maxi], chr=chromosomes)
        
rule split_samples:
    input:
        sample_file=sample_file
    output:
        out_files=expand ("sample_batch_${batch}.txt", batch=batches)    
    params:
        nbatches=nbatches
    script:
        "split_samples.R"

        
rule create_genomicsDB:
    input:
        sample_file="sample_batch_1.txt"
    params:
        ref=REF,
        chr="{chr}",
        gvcf_dir=gvcf_dir,
    output:
        out_dir=directory(genomicsDB_dir + "CHR{chr}_v1")
    shell:
       "sh create_DB.sh {params.ref}  {input.sample_file} {params.chr} {params.gvcf_dir} {output.out_dir}"



#first element is the sample file the second is the existing db
def list_inputs (wildcards):
    pnr=int(wildcards.batch) -1
    return ([f"sample_batch_{wildcards.batch}.txt", f"{genomicsDB_dir}CHR{wildcards.chr}_v{pnr}"])

rule update_genomicsDB:
    input:
        list_inputs
    params:
        ref=REF,
        gvcf_dir=gvcf_dir,
        chr="{chr}"
    output:
        out_dir=directory(genomicsDB_dir + "CHR{chr}_v{batch}")
    shell:
        "sh update_DB.sh {params.ref}  {input[0]} {params.chr}  {params.gvcf_dir}  {input[1]} {output.out_dir}"



