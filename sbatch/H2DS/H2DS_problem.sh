#!/bin/bash

#SBATCH --job-name=H2DS_PROBLEM
#SBATCH --output=H2DS_PROBLEM_%j.out
#SBATCH --error=H2DS_PROBLEM_%j.err
#SBATCH --time=18:00:00


module unload MATLAB
module load MATLAB/R2023b
matlab -r 'cd /home/jyliu/HTLR; htlr_startup; cd /home/jyliu/HTLR/experiments/H2DS; exp_H2DS_Problem;'
