# Hands-On Exercise: From Interactive RStudio to Batch Execution

In this exercise, you will bring together everything covered so far:
* Using a custom R container
* Running R interactively in RStudio via Open OnDemand
* Working from scratch storage
* Executing the same analysis non-interactively with Slurm and Rscript

You will first run an analysis interactively to explore the results, then submit it as a batch job.

## Part 1: Launch RStudio with Your Custom Container

1. Navigate to Open OnDemand in your browser.
2. Open the **RStudio** interactive app.
3. Select the **Custom** container you built earlier. The one with OS libraries and R packages installed. It should be 
```bash
/gscratch/scrubbed/$USER/r_rstudio_tutorial/r-w-libs.sif #or similar
```
4. In the **User R library path (R_LIBS_USER)** field, set:
```bash
R_LIBS_USER=/gscratch/scrubbed/$USER/R
```
This ensures any additional R packages are installed in scratch storage and not your home directory.

5. Set **Tasks** to 1
6. Set **CPUs per tasks** to 1
7. Set **Memory (GB)** to 40
8. Set **Number of hours** to 2

![Screenshot showing the RStudio job submission form in the OOD interactive application. The field are filled as described in this section.](./img/ood-custom-container.png 'OOD job custom container')
*Screenshot showing the RStudio job submission form in the OOD interactive application. The field are filled as described in this section.*

9. **Launch** the RStudio session and wait for it to start.

## Part 2: Navigate to Scratch Storage

Once RStudio is running:
1. In the `Files` pane (bottom-right), navigate using the symbolic link to scratch storage:
```bash
/gscratch/scrubbed/$USER
```
Once there click the directory `r_rstudio_tutorial` to open it. 

This directory contains the tutorial files and is where all work for this exercise should take place.

## Part 3: Run the Analysis Interactively
1. In the Files pane, click on:
```bash
ckpt_analysis.R
```

![Screenshot showing the RStudio session and indicating the ckpt_analysis.R script with a red arrow.](./img/open-script.png 'Open script')
*Screenshot showing the RStudio session and indicating the ckpt_analysis.R script with a red arrow.*

The script will open in the Source pane (top-left).
2. Adjust the indicated line to set the working directory to your tutorial working directory by replacing <$USER> with your UW NetID. 

3. Save the Rscript with your change (use the Ctrl key + S or the "Save icon"). 

4. Review the script briefly. It will:
* Load checkpoint-related job data from `sacct_ckpt_lite.csv`
* Perform basic analysis
* Generate several plots
* Write the plots out as PDF files

5. Select all lines in the script (or use Run → Run All).
6. Click Run to execute the script from top to bottom.

As the script runs, you should see output in the Console pane, plots will appear in the Plots tab, and new PDF files appear in the Files pane.

## Part 4: View Output Plots in the Browser

### From within RStudio
* Click on any of the generated .pdf files in the Files pane.
* RStudio will display the PDF directly in the browser.

### From Open OnDemand Files
1. Return to the main Open OnDemand dashboard.
2. Click Files → Scrubbed.

![Screenshot showing the My Interactive Session section of OOD and indicating with red arrows to clice on Files and open your working directory in Scrubbed.](./img/open-files.png 'Open files')
*Screenshot showing the My Interactive Session section of OOD and indicating with red arrows to clice on Files and open your working directory in Scrubbed.*

3. Click to open the tutorial directory `r_rstudio_tutorial`
4. Click on one of the generated PDF files to:
* View it directly in the browser
* Download it to your local machine

This is the same output you would retrieve from a batch job.

## Part 5: Challenge — Run the Analysis as a Slurm Job

Now that you’ve verified the analysis works interactively, you’ll submit it as a batch job using Slurm.

### Your Task

Edit `rscript-submit.slurm` to make the following changes:
1. Update the account and partition SBATCH directives as needed 
2. Increase the wall time to 10 minutes
3. Add email notifications so you are emailed when the job:
* Begins, Ends, Fails (hint: [see the optional side quest the previous section](./04-Rscript-function.md))
4. Update the command to run `ckpt_analysis.R` instead of `test.R`

## Part 6: Submit and Review the Job

1. Submit the job from the command line:
```bash
sbatch rscript-submit.slurm
```
2. Slurm will return a job ID.
3. Once the job completes, view the output file:
```bash
cat rscript-submit_<jobID>.out
```
4. Confirm that:
* The script ran without errors
* Output messages are present
* The PDF files were generated in scratch storage

**OPTIONAL:** You can view and download these files again using Open OnDemand → Files, just as before.

5. Check the solution script [**`solution.slurm`**](./solution.slurm)

## What You’ve Accomplished

By completing this exercise, you have:
* Run R code interactively using a custom container
* Generated and viewed output files in scratch storage
* Submitted the same analysis as a non-interactive Slurm job
* Used `Rscript` + `Apptainer` + Slurm together

This workflow: interactive development followed by batch execution, is the standard and recommended way to run R analyses on Hyak Klone.
