#!/usr/bin/env bash

module load jdk


REF=$1
sample_file=$2
Chr=$3
gvcf_dir=$4
db_dir=$5


# REF=/cluster/work/pausch/inputs/ref/BTA/UCD1.2/ARS-UCD1.2_Btau5.0.1Y.fa
# sample_file=/cluster/work/pausch/naveen/VARCAL_2020_08/JOINTGENOTYPING/sample_batch_1.txt
# Chr=25
# gvcf_dir=/cluster/work/pausch/temp_scratch/naveen/gvcf
# db_dir=/cluster/work/pausch/naveen/VARCAL_2020_08/JOINTGENOTYPING/XXX/




GATK4=/cluster/home/nkadri/PROGRAMS/GATK4.1.8.1/gatk-4.1.8.1/gatk

cp $sample_file $TMPDIR
cd $TMPDIR
export TILEDB_DISABLE_FILE_LOCKING=1
while read sample
do
    filename=${gvcf_dir}/${Chr}/${sample}_${Chr}.g.vcf.gz
    echo $filename
    cp ${filename}* .
    echo $sample `basename $filename` >>mymap
done <$sample_file

awk 'BEGIN{OFS="\t"}{print $1, $2}' mymap >tmp
mv tmp mymap


${GATK4} \
    GenomicsDBImport \
    --sample-name-map mymap \
    --genomicsdb-workspace-path MYDB \
    -L ${Chr} \
    --reader-threads 10\
    -R ${REF}

mv MYDB ${db_dir}

##batch-size 50
##consolidate
