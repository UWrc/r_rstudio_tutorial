# Running R Non-Interactively with `Rscript`

Working interactively in RStudio is ideal for exploration and development, but most production R workloads on Hyak Klone are run non-interactively using the `Rscript` command.

`Rscript` allows you to:
* Execute a single R expression, or
* Run an entire `.R` script from the command line

When combined with a container and Slurm, `Rscript` enables long-running or resource-intensive analyses to run unattended on compute nodes.

## The Example R Script
We’ll start with a very simple R script called `test.R`:

```bash
cat test.R
```

This script doesn’t do much computationally, but it’s enough to demonstrate:
* That R is running correctly
* That packages inside the container are available
* Where output from a batch job ends up

## The Slurm Submission Script

Next, we’ll use a Slurm submission script to run this R script on the cluster. This file is called `rscript-submit.slurm`.

```bash
cat rscript-submit.slurm
```

Let’s walk through this script section by section.

### Slurm Directives Explained
All lines starting with `#SBATCH` are directives to Slurm, not shell commands.

#### Job identification and placement
* `--job-name=rscript-submit` Sets the job name (used in queue listings and output files).
* `--account=uwit` Charges compute usage to this allocation.
* `--partition=compute` Specifies which partition to run on. Use `hyakalloc` to see partitions you can access.

#### Resource requests
* `--time=5:00` Maximum wall time for the job.
* `--nodes=1` Number of nodes requested.
* `--ntasks=1` Number of tasks (maps to cores).
* `--mem=4G` Total memory requested for the job.

#### Output handling
* `--signal=USR2` This directive tells Slurm to send the USR2 signal to your job shortly before it reaches its wall-time limit. This gives the application a chance to clean up, save state, or exit gracefully. 
* `--output=%x_%j.out` Writes standard output and standard error to a file named `jobname_jobID.out`.

This is where the output from `test.R` will appear.

> **Optional Side Quest: Email Notifications**
> These lines configure email alerts:
> ```bash
> #SBATCH --mail-type=BEGIN,END,FAIL
> #SBATCH --mail-user=your_netid@uw.edu
> ```
> They tell Slurm to email you when:
> * The job starts
> * The job finishes
> * The job fails
>
> This is especially useful for long-running jobs that you don’t want to monitor manually. Add this to `rscript-submit.slurm` if you wish. 

### Running R Inside the Container
The final line is the actual command Slurm executes:
```bash
apptainer exec --bind /gscratch r-w-libs.sif Rscript test.R
```

This does the following:
* Runs the command inside your custom container (`r-w-libs.sif`)
* Binds `/gscratch` so your data and scripts are accessible
* Executes `Rscript test.R` non-interactively

Because the container already includes the required R packages and system libraries, the job does not depend on your personal R library or an interactive session.

## Submitting the Job

To submit the job to Slurm, run:
```bash
sbatch rscript-submit.slurm
```

Slurm will return a job ID. Once the job completes, you can view the output with:
```bash
cat rscript-submit_<jobID>.out
```

You should see the result of 5 + 5 and confirmation that tidyverse loaded successfully.

> **Key Takeaway:** This pattern, custom container + `Rscript` + Slurm, is the standard way to run scalable, reproducible R workloads on Hyak Klone. Interactive RStudio sessions are for development; batch jobs are for getting real work done.

At this point, you should start to imagine how powerful this pattern becomes when your R script runs for hours, ingests large datasets, and writes results to disk without requiring your attention. By combining a custom container, Rscript, and Slurm, you can move seamlessly from interactive development in RStudio to fully unattended, production-scale analyses on Hyak Klone. 

In the next section, you’ll put this into practice by running a real analysis end-to-end using Open OnDemand.