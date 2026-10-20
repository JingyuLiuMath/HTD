#!/bin/bash

#SBATCH --job-name=H2DW_PROBLEM
#SBATCH --output=H2DW_PROBLEM_%j.out
#SBATCH --error=H2DW_PROBLEM_%j.err
#SBATCH --nodelist=bigMem0


module unload MATLAB
module load MATLAB/R2023b
source /home/jyliu/HTLR/sbatch/slurm_job_info.sh
print_slurm_job_info

matlab -batch "cd('/home/jyliu/HTLR'); htlr_startup; cd('experiments/H2DW'); exp_H2DW_Problem;"
job_status=$?

print_slurm_job_footer "$job_status"
exit "$job_status"
