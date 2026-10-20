#!/bin/bash

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
cd "$script_dir"

problem_job_id=$(sbatch --parsable H2DWQ_problem.sh)
problem_job_id=${problem_job_id%%;*}
printf 'Submitted H2DWQ Problem: Job %s\n' "$problem_job_id"

intermatrix_job_id=$(sbatch --parsable \
    --dependency="afterok:$problem_job_id" H2DWQ_intermatrix.sh)
intermatrix_job_id=${intermatrix_job_id%%;*}
printf 'Submitted H2DWQ Intermatrix: Job %s (afterok:%s)\n' \
    "$intermatrix_job_id" "$problem_job_id"

hmv_job_id=$(sbatch --parsable \
    --dependency="afterok:$intermatrix_job_id" H2DWQ_hmv.sh)
hmv_job_id=${hmv_job_id%%;*}
printf 'Submitted H2DWQ HMultV: Job %s (afterok:%s)\n' \
    "$hmv_job_id" "$intermatrix_job_id"

printf 'Monitor: squeue -j %s,%s,%s\n' \
    "$problem_job_id" "$intermatrix_job_id" "$hmv_job_id"
