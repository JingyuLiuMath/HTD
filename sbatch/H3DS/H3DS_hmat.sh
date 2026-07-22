#!/bin/bash

#SBATCH --job-name=H3DS_HMAT
#SBATCH --output=H3DS_HMAT_%j.out
#SBATCH --error=H3DS_HMAT_%j.err
#SBATCH --nodelist=bigMem0
#SBATCH --time=18:00:00
#SBATCH --exclusive


module unload MATLAB
module load MATLAB/R2023b
matlab -r 'cd /home/jyliu/HTLR; htlr_startup; cd /home/jyliu/HTLR/experiments/H3DS; exp_H3DS_HMAT;'
