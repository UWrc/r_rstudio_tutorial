# Using R and RStudio on Hyak Klone

Welcome! This workshop is designed for researchers who already use R and RStudio and are ready to move beyond running analyses on a personal laptop or desktop. Many RStudio users come to Hyak Klone because their R jobs are long-running, computationally intensive, or require large amounts of memory, forcing them to dedicate their own computer for hours or days at a time.

Hyak Klone provides access to powerful compute nodes and a job scheduler, allowing R workloads to run unsupervised, reliably, and at scale. By using R and RStudio through containerized environments and Open OnDemand, you can keep your local machine free while your analyses run efficiently on the supercomputer.

This workshop focuses on helping you make that transition smoothly.

> **Important:** This is *not* an R programming workshop. Attendees are expected to have prior experience using R. The focus is on environment setup, storage management, and scalable workflows for running R on Hyak Klone.

## Goals & Rationale

R and RStudio are widely used across the UW research community, but on Hyak Klone they are provided exclusively through containerized environments. This workshop is designed to help researchers use R productively on Klone by focusing on how R and RStudio are run in this environment rather than on R programming itself.

Participants will learn how to launch RStudio Server through Open OnDemand, choose appropriate compute resources, and manage storage so that R packages and user libraries are written to project or scratch space instead of the home directory. The workshop also covers best practices for working with containerized R environments, including using community-maintained RStudio containers and building custom containers when additional system dependencies or R packages are required.

This workshop is specific to Hyak Klone and reflects Klone’s software and container policies. 

The workflows demonstrated here are not currently supported on Tillicum. To use a custom Rstudio container on Tillicum, consider the [**port forwarding protocol**](https://hyak.uw.edu/docs/tools/r#rstudio-container-and-graphical-user-interface) presented in our documentation. 

## Learning Objectives

By the end of this workshop, participants will be able to:

* Understand Hyak Klone software and container policies as they apply to R and RStudio.
* Launch RStudio Server on Klone using Open OnDemand and select appropriate compute resources.
* Configure a `.Renviron` file to control where R packages and user libraries are installed.
* Use UW-maintained, community-supported RStudio containers on Hyak Klone.
* Pull and run RStudio containers from the Rocker project on Docker Hub.
* Understand why containers are read-only at runtime and when `install.packages()` will not work.
* Build a custom R or RStudio container using a definition file to install required system dependencies and R packages.
* Use `Rscript` to submit longer-running, non-interactive R jobs to Slurm for unattended execution.

## Repository Structure

Each topic in this tutorial is contained in its own Markdown file for easy navigation and reuse:

| Section | Description |
|-------|-------------|
| [**00-prereqs.md**](./00-prereqs.md) | Account and access prerequisites |
| [**01-ood-rstudio.md**](./01-ood-rstudio.md) | RStudio via Open OnDemand |
| [**02-r-containers-background.md**](./02-r-containers-background.md) | RStudio Containers Background Information |
| [**03-customR-containers.md**](./03-customR-containers.md) | Customizing RStudio Containers |
| [**04-Rscript-function.md**](./04-Rscript-function.md) | The Rscript function - R + Slurm |
| [**05-task.md**](./05-task.md) | Hands-on exercise |

## Introduction Video

An optional introduction video accompanies this tutorial and provides a high-level walkthrough of the concepts covered:

*Using R and RStudio on Hyak Klone*  - Video coming soon. 

[**Slide Deck**](./slide_deck_r_rstudio.pdf) from live tutorial on February 5, 2026. 

## Feedback

Your feedback helps improve Hyak trainings and documentation.

After completing this tutorial or attending a related workshop, please share your thoughts using our  
[**feedback form**](https://forms.office.com/r/MZ0UZ5S7t7).

## Additional Resources

* [**Hyak Short How-To Video Collection**](https://hyak.uw.edu/learn)
    * [**Hyak Klone Login**](https://youtu.be/gbse1xqezqk)
    * [**Hyak Home Directories**](https://youtu.be/OhLwqAZIBOo)
    * [**Hyak Klone Filesystem**](https://youtu.be/VFGREiZ37x0)
    * [**Hyak Klone Slurm**](https://youtu.be/jgHXB7IfGPQ?si=0lFpU_ujrQoUUmyb)
* [**Hyak Documentation**](https://hyak.uw.edu/docs/)
