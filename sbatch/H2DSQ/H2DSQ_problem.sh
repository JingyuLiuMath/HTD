#!/bin/bash

#SBATCH --job-name=H2DSQ_PROBLEM
#SBATCH --output=H2DSQ_PROBLEM_%j.out
#SBATCH --error=H2DSQ_PROBLEM_%j.err
#SBATCH --nodelist=bigMem0
#SBATCH --time=18:00:00


module unload MATLAB
module load MATLAB/R2023b
matlab -r 'cd /home/jyliu/HTLR; htlr_startup; cd /home/jyliu/HTLR/experiments/H2DSQ; exp_H2DSQ_Problem;'
