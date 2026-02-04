# RStudio Containers

## What Are Containers?
**Containers** are lightweight, isolated software environments that encapsulate an application along with its dependencies and runtime settings. They provide a consistent and reproducible way to package, distribute, and run software across different computing environments.

Instead of relying on whatever software happens to be installed on a system, containers let you define exactly what versions of R, system libraries, and packages your analysis depends on and then run that same environment anywhere the container runtime is available.

## Containers on Hyak Klone
Hyak Klone is a shared high-performance computing environment with a baseline software stack and a set of commonly used tools pre-installed. For security and stability reasons:
* Users do not have root or sudo access
* System-wide software is centrally managed
* Users are responsible for managing any additional software required for their research

Documentation and direct support are available through the [**Research Computing help desk**](https://uwconnect.uw.edu/sp?id=sc_cat_item&sys_id=9e0fe8b58718fa906f1997dd3fbb35f3), but users cannot modify the underlying operating system.

Containers bridge this gap.

By using containers, researchers can build and run customized software stacks on Hyak Klone in a secure, portable, and fully reproducible way without requiring elevated system access. This makes containers the preferred mechanism for complex or nonstandard software environments on Hyak.

## Installing R Packages and Understanding Container Limits
At this point, in the tutorial you should have RStudio running in your browser and be able to begin working interactively.

The container you launched already includes a curated R environment (for example, tidyverse and its dependencies). You can begin customizing your R setup using: 
```bash
install.packages("packagename")
```

### What `install.packages()` Does (and Does Not Do)
Because you configured `R_LIBS_USER`, any packages you install during this session will be placed in your personal R library (for example, `/gscratch/scrubbed/$USER/R`). This allows you to:
* Install many commonly used R packages
* Maintain installed packages across RStudio sessions
* Avoid filling your home directory

However, it’s important to understand that this ***does not modify the container itself***.

**Containers provide:**
* An isolated environment for reproducibility
* Consistent, tested software stacks
* *Read-only* system software

Your personal R library works on top of the container. It can only install packages whose system-level dependencies are already present in the container or can be built without modifying the operating system.

### When `install.packages()` Fails
Some R packages require:
* Additional system libraries (e.g., `libxml2`, `udunits`, `gdal`)
* Specific compilers or OS-level configuration
* Older or pinned dependency versions

When those requirements are not met, `install.packages()` may fail — even though your R library path is correctly configured.

***This is expected behavior in containerized environments.***

### Why Custom Containers Matter
Because R is open source and its ecosystem evolves rapidly, relying solely on ad-hoc package installs can lead to environments that are:
* Difficult to reproduce
* Fragile when packages or dependencies change
* Incompatible with future updates

**Building a custom R container allows you to:**
* Control the R version
* Install system dependencies explicitly
* Preserve working environments over time
* Reduce duplicated software and overall storage usage

## The Rocker Project: A Strong Starting Point
The Rocker Project was launched in October 2014 to provide high-quality, community-maintained container images for R. These images package R, RStudio, and curated sets of packages into ready-to-use environments that ***just work***.

Rocker containers give R users access to a wider variety of preconfigured environments than is typically available through operating system packages or centrally managed software stacks, which often focus on a single (current) R release.

This portability is especially valuable in high-performance computing environments.

**On Hyak Klone:**
* Apptainer is the supported container runtime
* Rocker Docker images can be used directly with Apptainer
* Containers can be run interactively (RStudio) or in batch jobs (via Slurm)
* Apptainer container definition files make further customizations possible

This makes Rocker containers an excellent foundation for building custom R environments on Hyak.

At this point, you’ve seen why containers are a foundational tool for running R on Hyak Klone. They allow you to move beyond ad-hoc package installation and toward software environments that are reproducible, portable, and compatible with the constraints of a shared HPC system.

In the next section, we’ll shift from *why* containers matter to *how* to use them.