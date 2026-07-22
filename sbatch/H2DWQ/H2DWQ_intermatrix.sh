#!/bin/bash

#SBATCH --job-name=H2DWQ_INTER
#SBATCH --output=H2DWQ_INTER_%j.out
#SBATCH --error=H2DWQ_INTER_%j.err
#SBATCH --nodelist=bigMem0
#SBATCH --exclusive
#SBATCH --time=18:00:00


module unload MATLAB
module load MATLAB/R2023b
source /home/jyliu/HTLR/sbatch/slurm_job_info.sh
print_slurm_job_info

matlab -batch "cd('/home/jyliu/HTLR'); htlr_startup; cd('experiments/H2DWQ'); exp_H2DWQ_Intermatrix;"
job_status=$?

print_slurm_job_footer "$job_status"
exit "$job_status"
