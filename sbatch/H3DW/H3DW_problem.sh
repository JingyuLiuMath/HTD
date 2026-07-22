#!/bin/bash

#SBATCH --job-name=H3DW_PROBLEM
#SBATCH --output=H3DW_PROBLEM_%j.out
#SBATCH --error=H3DW_PROBLEM_%j.err
#SBATCH --time=18:00:00


module unload MATLAB
module load MATLAB/R2023b
matlab -r 'cd /home/jyliu/HTLR; htlr_startup; cd /home/jyliu/HTLR/experiments/H3DW; exp_H3DW_Problem;'
