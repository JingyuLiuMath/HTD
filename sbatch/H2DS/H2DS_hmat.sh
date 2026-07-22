#!/bin/bash

#SBATCH --job-name=H2DS_HMAT
#SBATCH --output=H2DS_HMAT_%j.out
#SBATCH --error=H2DS_HMAT_%j.err
#SBATCH --nodelist=bigMem0
#SBATCH --time=18:00:00
#SBATCH --exclusive


module unload MATLAB
module load MATLAB/R2023b
matlab -r 'cd /home/jyliu/HTLR; htlr_startup; cd /home/jyliu/HTLR/experiments/H2DS; exp_H2DS_HMAT;'
