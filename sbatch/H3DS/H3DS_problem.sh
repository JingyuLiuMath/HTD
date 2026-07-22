#!/bin/bash

#SBATCH --job-name=H3DS_PROBLEM
#SBATCH --output=H3DS_PROBLEM_%j.out
#SBATCH --error=H3DS_PROBLEM_%j.err
#SBATCH --time=18:00:00


module unload MATLAB
module load MATLAB/R2023b
matlab -r 'cd /home/jyliu/HTLR; htlr_startup; cd /home/jyliu/HTLR/experiments/H3DS; exp_H3DS_Problem;'
