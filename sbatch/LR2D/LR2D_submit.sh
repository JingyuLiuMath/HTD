#!/bin/bash

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
cd "$script_dir"

scripts=(
    LR2D_NBR_Gaussian.sh
    LR2D_NBR_SLP.sh
    LR2D_NBR_Helm.sh
    LR2D_WS_Gaussian.sh
    LR2D_WS_SLP.sh
    LR2D_WS_Helm.sh
)

job_ids=()
for script in "${scripts[@]}"; do
    job_id=$(sbatch --parsable "$script")
    job_id=${job_id%%;*}
    job_ids+=("$job_id")
    printf 'Submitted %s: Job %s\n' "${script%.sh}" "$job_id"
done

dependency_list=$(IFS=:; printf '%s' "${job_ids[*]}")
plot_job_id=$(sbatch --parsable \
    --dependency="afterok:$dependency_list" LR2D_plot.sh)
plot_job_id=${plot_job_id%%;*}
printf 'Submitted LR2D Plot: Job %s (afterok:%s)\n' \
    "$plot_job_id" "$dependency_list"

job_ids+=("$plot_job_id")
job_list=$(IFS=,; printf '%s' "${job_ids[*]}")
printf 'Monitor: squeue -j %s\n' "$job_list"
