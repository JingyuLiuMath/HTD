#!/bin/bash

#SBATCH --job-name=LR3D_NBR_SLP
#SBATCH --output=LR3D_NBR_SLP_%j.out
#SBATCH --error=LR3D_NBR_SLP_%j.err
#SBATCH --nodelist=bigMem0
#SBATCH --time=18:00:00


module unload MATLAB
module load MATLAB/R2023b
source /home/jyliu/HTLR/sbatch/slurm_job_info.sh
print_slurm_job_info

matlab -batch "cd('/home/jyliu/HTLR'); htlr_startup; cd('experiments/LowRank3D'); exp_LR3D_NBR_SLP;"
job_status=$?

print_slurm_job_footer "$job_status"
exit "$job_status"
