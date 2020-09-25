#!/bin/bash
module add python_cpu/3.7.4
~/.local/bin/snakemake --jobs 500 -rp  --latency-wait 40 --keep-going --rerun-incomplete --cluster-config cluster.json --cluster "bsub -J {cluster.jobname} -n {cluster.ncore} -W {cluster.jobtime} -oo {cluster.logi} -R  \"rusage[mem={cluster.memo}, scratch={cluster.scratch}]\"    "


