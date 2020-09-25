#!/usr/bin/env bash

module load jdk


REF=$1
sample_file=$2
Chr=$3
gvcf_dir=$4
existing_db=$5
#output
db_dir=$6



GATK4=/cluster/home/nkadri/PROGRAMS/GATK4.1.8.1/gatk-4.1.8.1/gatk

cp $sample_file $TMPDIR
cd $TMPDIR
#cp the data base !
cp -r ${existing_db} MYDB
echo contents of the dir
ls -lrt

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
    --genomicsdb-update-workspace-path MYDB \
    -L ${Chr} \
    --reader-threads 1 \
    -R ${REF}

mv MYDB ${db_dir}


