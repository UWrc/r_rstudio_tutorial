# Customizing RStudio Containers

In this section, we’ll move from background concepts into hands-on practice. Rather than jumping directly into a complex container build, we’ll walk through a series of short, guided demonstrations that illustrate how containers behave and when customization is necessary.

These demonstrations are designed to be fast, practical, and directly relevant to common R workflows on Hyak Klone.

## What We’ll Do
* Demo 1: Installing R Packages Without Modifying a Container
* Demo 2: Building a Simple Custom R Container
* Demo 3: When R Packages Require System Libraries

## Preparation: Allocate a compute node
Working with containers interactively or building containers are processes to perform on compute nodes rather than the login nodes. 

```bash
# for the live demo on 5 Feb 2026
# change the account and partition directives as needed
salloc --account=uwit --partition=compute --time=2:00:00 --mem=20G

# for demonstration account users
salloc --partition=ckpt-all --time=2:00:00 --mem=20G
```
Change directory to your workspace for this tutorial if you haven't already 
```bash
cd /gscratch/scrubbed/$USER
```

## Demo 1: Installing R Packages Without Modifying a Container
We’ll start by running an existing Rocker container on a compute node and installing an R package interactively. This will be successful, but we’ll examine where that package was installed and what happens if configured library paths are not accessible to the container.

> Goal: Understand the difference between installing packages into a personal library using bind mounts and installing packages into a container.

Pull a small base image with R. 
```bash
time apptainer pull docker://rocker/r-base
# usually takes 2-3 minutes
```

Shell into the container and bind the filesystem `/gscratch` this is required for the container to have access to your the R library you set up with your `.Renviron` configuration file and ***ALL other files you need*** for your R analysis (e.g., input data).
```bash
apptainer shell --bind /gscratch/ r-base_latest.sif
```

Start R from the command line
```bash
R
```
Check library paths
```bash
.libPaths()
```
This should show `/gscratch/scrubbed/$USER/R` as we set this up with your `.Renviron` configuration file. 

Install a simple package with few dependencies
```bash
install.packages("RColorBrewer")
library(RColorBrewer)
```
Exit R
```bash
q()
# don't have the workspace image

# exit the container
exit
```
List your R library
```bash
ls R
```
You will see that RColorBrewer is installed in your personal R library. By mounting the storage cluster `/gscratch` to the container, we were able to access files that are *outside* of the container. 

If we neglect to mount `/gscratch` loading RColorBrewer fails even though we have it in our R library. The R library is not accessible if storage outside of the container is not mounted. 
```bash
apptainer shell r-base_latest.sif

# start R
R

# attempt to load the library
library(RColorBrewer) #fails

# check your library paths
.libPaths()
```

> **WARNING:** An unconfigured library path will default to your home directory storage and result in storage quota limits. 

Exit R
```bash
q()
# don't have the workspace image

# exit the container
exit
```

> **Key takeaway - Bind mounts are important and need to be applied intentionally. Containers are immutable.**

## Demo 2: Building a Simple Custom R Container
Next, we’ll create a minimal Apptainer definition file and build a custom container that includes an R package baked directly into the image. We’ll then run the container and verify that the package is available without any additional configuration.

> Goal: Learn the basic workflow for customizing an R container and see what “container immutability” looks like in practice.

A definition file (`.def`) is a recipe that documents the container build process, including the base OS, packages to install, and commands to run. In this section we will build a custom R base container, but this time we'll use a definition file and install RColorBrewer into the container rather than in our R library.

Take a look at the definition file we made called `customR.def`:
```bash 
cat customR.def
```

Let's break down what these sections do when Apptainer builds the container:

* All definition files start with `Bootstrap` followed by the bootstrap agent which specifies the base container image will use. In this tutorial, we will be using the Docker bootstrap agent.
* `From: rocker/r-base` indicates what image you want to use or the specific publisher in Docker Hub you are pulling from. In this case, we are using the R-base container from the Rocker Project repository available on Docker Hub.
* The `%post` section is where new software packages can be downloaded and installed. 
* `Rscript -e 'install.packages("RColorBrewer")'` runs a non-interactive R command during the container build process to install the RColorBrewer package directly into the container’s system R library, making it permanently available whenever the container is run.

Build the custom R container from the definition file. We will call the new container `r-base-brewer.sif`
```bash 
time apptainer build r-base-brewer.sif customR.def
# usually takes 2-3 minutes
```
Verify RColorBrewer is installed by shelling into the container, this time without mounting `/gscratch` so that the container is completely isolated from outside packages. 
```bash
apptainer shell r-base-brewer.sif

# start R
R

# load the library
library(RColorBrewer) 

# check your library paths
.libPaths()
```
This time you see that `/usr/local/lib/R/site-library` is set as your default library path. This path only exists in the container. 
```bash
# quit R
q()

# list the path shown with .libPaths()
ls /usr/local/lib/R/site-library
# RColorBrewer is installed in the container

# exit the container
exit

# attempt to list the path shown with .libPaths()
ls /usr/local/lib/R/site-library #fails
```

We installed RColorBrewer inside the container. No bind mounts were required to use RColorBrewer with `r-base-brewer.sif`. The contaienrized environment is fully reproducible, it doesn't require another user to install packages into their own R library. 

> **Key takeaway - If it’s in the `.def` file, it’s part of the environment.**


## Demo 3: When R Packages Require System Libraries
Finally, we’ll look at a slightly more advanced example where installing an R package requires additional operating system libraries. We’ll examine how these dependencies are added at build time and discuss why some packages cannot be installed interactively in RStudio.

> Goal: Recognize when a custom container is required and understand how system-level dependencies fit into the R container workflow.

Let's start the next build, which will take longer, and then discus the definition file contents while we wait. 

```bash 
time apptainer build r-w-libs.sif customR-OSlibs.def
# usually takes 8-10 minutes
```

While that is building, let's discuss the definition file
```bash 
cat customR-OSlibs.def
```

> #### Special Cases: Source and Bioconductor Package Installs (Build-Time Only)
> 
> The following installation methods must be placed in the %post section of an Apptainer definition file. These commands run at container build time and permanently modify the container environment.
> 
> ***These approaches cannot be used interactively in RStudio or on a running container.***
> 
> **Installing R packages from source**
>
> When you need a specific package version or when prebuilt binaries are unavailable, you can install directly from a source tarball during the container build in the `%post` section of your definition file:
> ```bash
> wget https://cran.r-project.org/src/contrib/RColorBrewer_1.1-3.tar.gz
> R CMD INSTALL RColorBrewer_1.1-3.tar.gz
> ```
> 
> This installs the package into the container’s system R library so it is available every time the container is run.
> 
> **Installing Bioconductor packages**
> Bioconductor packages are also best installed at build time and should be handled explicitly in `%post`:
> 
> ```bash
> Rscript -e 'if (!require(\"BiocManager\", quietly = TRUE)) install.packages(\"BiocManager\")'
> Rscript -e 'BiocManager::install(version = \"3.20\")'
> 
> #example package install from BiocManager
> Rscript -e 'BiocManager::install(\"regioneR\")'
> Rscript -e 'BiocManager::install(\"regioneReloaded\")'
> ```
> 
> Setting the Bioconductor version helps ensure compatibility with the R version in your container and improves long-term reproducibility.
> 
> **Reminder:** If these installs fail, the cause is often a missing OS-level dependency. Those dependencies must also be added in the `%post` section before the R package installation commands.
> 
> Think of `%post` as the recipe that builds your environment. If it isn’t in `%post`, it isn’t part of the container.

### Understanding OS-Level Dependencies in R Containers

In this demonstration, we’re moving beyond R packages alone and looking at operating system (OS) libraries that some R packages depend on. These libraries are not R packages, they are system components that R packages link against when they are compiled or loaded.

On Hyak Klone, users do not have root or sudo access, which means OS libraries cannot be installed interactively on login or compute nodes. This is why some R packages fail to install in RStudio, even when your R library path is correctly configured.

#### Where OS Libraries Fit in the Container Build

In an Apptainer definition file, OS libraries are installed in the %post section:
* `%post` runs at build time, not at runtime
* Commands in this section modify the container filesystem
* This is the only place where system-level changes can be made

For example:
```bash
# not available to Hyak Klone users outside of a container build
apt-get update -y
apt-get install -y libxml2 libpng-dev libjpeg-dev
```

These commands install shared libraries and development headers into the container’s operating system layer, making them available to R during package installation.

#### Why These Libraries Are Needed

Many R packages include compiled code written in C, C++, or Fortran. During installation, these packages must link against external libraries provided by the operating system. Common examples include:
* libxml2 – required for XML parsing (xml2, rvest)
* zlib, bzip2, lzma – used for compression support
* libjpeg, libpng – required for image handling
* libicu – internationalization and text processing
* libglpk – linear programming and optimization

If these libraries are missing, `install.packages()` will fail with compilation or linking errors—often referencing missing headers (*.h files) or shared objects (*.so files).

#### Why This Can’t Be Done in RStudio

When you install a package interactively in RStudio:
* R can install files into your personal library
* R cannot install missing OS libraries
* The container filesystem is read-only at runtime

As a result, any package that depends on missing system libraries will fail to install, regardless of where your R library is located.

#### Why Containers Solve This Problem

By installing OS libraries at build time:
* R packages can compile successfully
* Dependencies are explicitly documented
* The environment becomes reproducible and portable
* All users of the container get the same working setup

This is why custom containers are essential for R packages with nontrivial system dependencies, and why installing everything interactively is not sufficient for many real-world R workflows.

> **Key takeaway: If an R package needs something outside of R itself, it belongs in the container definition file—not in an interactive RStudio session.**

With a custom container in place, you now have a stable and reproducible R environment that no longer depends on interactive sessions or ad-hoc package installs. This is the foundation needed to move beyond RStudio and toward running real workloads on Hyak Klone.

In the next section, we’ll introduce the `Rscript` command and show how it is used to run R non-interactively inside a container. You’ll learn how `Rscript`, your custom container, and Slurm work together to submit longer-running or resource-intensive jobs to the cluster, allowing analyses to run unattended on compute nodes rather than in your browser. This is the standard pattern for scaling R workflows on Hyak, moving from exploratory work in RStudio to production runs managed by Slurm.