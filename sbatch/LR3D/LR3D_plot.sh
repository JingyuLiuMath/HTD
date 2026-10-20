#!/bin/bash

#SBATCH --job-name=LR3D_PLOT
#SBATCH --output=LR3D_PLOT_%j.out
#SBATCH --error=LR3D_PLOT_%j.err
#SBATCH --nodelist=bigMem0
#SBATCH --time=01:00:00


module unload MATLAB
module load MATLAB/R2023b
source /home/jyliu/HTLR/sbatch/slurm_job_info.sh
print_slurm_job_info

matlab -batch "cd('/home/jyliu/HTLR'); htlr_startup; cd('experiments/LowRank3D'); plot_LR3D;"
job_status=$?

print_slurm_job_footer "$job_status"
exit "$job_status"
