#!/bin/bash

#SBATCH --job-name=H3DS_PROBLEM
#SBATCH --output=H3DS_PROBLEM_%j.out
#SBATCH --error=H3DS_PROBLEM_%j.err
#SBATCH --nodelist=bigMem0


module unload MATLAB
module load MATLAB/R2023b
source /home/jyliu/HTLR/sbatch/slurm_job_info.sh
print_slurm_job_info

matlab -batch "cd('/home/jyliu/HTLR'); htlr_startup; cd('experiments/H3DS'); exp_H3DS_Problem;"
job_status=$?

print_slurm_job_footer "$job_status"
exit "$job_status"
