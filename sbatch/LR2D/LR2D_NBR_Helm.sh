#!/bin/bash

#SBATCH --job-name=LR2D_NBR_HELM
#SBATCH --output=LR2D_NBR_HELM_%j.out
#SBATCH --error=LR2D_NBR_HELM_%j.err
#SBATCH --nodelist=bigMem0
#SBATCH --time=18:00:00


module unload MATLAB
module load MATLAB/R2023b
source /home/jyliu/HTLR/sbatch/slurm_job_info.sh
print_slurm_job_info

matlab -batch "cd('/home/jyliu/HTLR'); htlr_startup; cd('experiments/LowRank2D'); exp_LR2D_NBR_Helm;"
job_status=$?

print_slurm_job_footer "$job_status"
exit "$job_status"
