# Prerequisites and First Login

This workshop assumes some prior familiarity with Hyak Klone. However, **if you are completely new to Hyak or Open OnDemand**, there are two things you must do first:

1. Log in to Klone at least once so your **home directory is created**
2. Become aware of **Hyak storage locations and quotas** so you do not accidentally fill your home directory

## Prerequisites

Before starting this tutorial, you should have the following in place:

* A UW NetID  
* An active Hyak account for Klone  
* Two-factor authentication (2FA) enabled  
* Access to an SSH client on your local computer  

If you do not yet have a Hyak account, you can request access for training purposes:

👉 [**Klone demonstration account request form**](https://uwconnect.uw.edu/sp?id=sc_cat_item&sys_id=f5caba8fdbe108101ba12968489619e0).

### Student Accounts

Students should apply for a **Student Technology Fee** (`stf`) account, managed by the [**Research Computing Club**](https://depts.washington.edu/uwrcc/). 

👉 [**Apply now for your `stf` account**](https://depts.washington.edu/uwrcc/hyak_access/). 

### Two-Factor Authentication (2FA)

UW policy requires **two-factor authentication (2FA)** for all UWIT services, including Hyak. Confirm that 2FA is enabled before attempting to log in:

👉 [**UW Two-Factor Authentication Info**](https://identity.uw.edu/2fa/)

## First Login to Hyak Klone (Required Once)

👉 [**Hyak Klone Login Video**](https://youtu.be/gbse1xqezqk)

👉 [**Detailed login instructions**](https://github.com/UWrc/linux-fundamentals/blob/main/01-logging-in.md)

👉 [**More information about SSH Clients**](https://github.com/UWrc/linux-fundamentals/blob/main/00-prereqs.md)

To initialize your account and create your home directory, log in to Klone once using SSH.
```bash
ssh UWNetID@klone.hyak.uw.edu
```
A successful login will display a welcome banner. Once you see this, your home directory has been created.

> Too many failed login attempts may result in a temporary IP ban (one hour).

## Storage Overview

When you first log in, you will land in your home directory:
```bash
[UWNetID@klone-login01 ~]$
```

### Your home directory:
* Is intended for configuration files and small scripts
* Has a strict **10 GB quota**
* Should ***not*** be used for large datasets or software installations

👉 [**Hyak Home Directories Video**](https://youtu.be/OhLwqAZIBOo)

### Scrubbed Storage — Our Tutorial Workspace
For this workshop, you will create a working directory in:
```bash
/gscratch/scrubbed
```
This location is designed for active work and provides substantially more space. 

> ***Note:*** Scrubbed storage is temporary scratch space for active computation. It’s not backed up and files are deleted automatically after **21 days** of inactivity.

Create a personal folder there and move into it:

```bash
mkdir /gscratch/scrubbed/$USER
cd /gscratch/scrubbed/$USER
```

While we're at it, le'ts clone the git repository for this tutorial, we'll use some of the files later. 

```bash
git clone https://github.com/UWrc/r_rstudio_tutorial.git
```
We also want to make a directory to hold the R packages we will install during the workshop. 
```bash
mkdir R
```

We'll return here later, but for how return to your home directory to configure R environment file. 

```bash
cd ~
```

## Creating Your `.Renviron` File

After setting up your working directory, you will create a `.Renviron` file in your home directory.

This file ensures that:
* R packages are installed outside your home directory
* Package libraries persist across RStudio sessions
* Containerized R environments behave as expected

Without a `.Renviron` file, R will default to installing packages in your home directory, which often leads to quota issues and failed installs.

Run the following command to create your `.Renviron` file and make a variable `R_LIBS` inside of it which is the path to your workspace for this tutorial. 
```bash
echo 'R_LIBS="/gscratch/scrubbed/'"$USER"'/R"' >> ~/.Renviron
```

> ***Note:*** After this tutorial, we recommend setting this variable to a more permanent location if that is available to you, like your lab group's dedicated storage under `/gscratch`. 

Files beginning with `.` are hidden in Linux systems, so listing your directory will not display your `.Renviron` file. To list the directory including hidden files use `-a`.
```bash
ls -a
```

## Configuring Open OnDemand Access to Scratch Storage

When RStudio is launched through Open OnDemand, it runs inside a container. For security and consistency, the container’s root directory is set to your home directory by default.

Because your home directory:
* Has a **10 GB quota**
* Is not intended for active computation or large files

working directly there can quickly lead to quota issues.

To make it easy to access high-capacity storage from within RStudio, we create a **symbolic link** in your home directory that points to scratch space.

### Create a symbolic link to scratch storage

```bash 
ln -s /gscratch/scrubbed/$USER ~/scratch
```

This creates a directory called `scratch` in your home directory that points to your workspace for this tutorial. View that this is set up properly by listing your home director with long format, which will show the directory and its true path. 
```bash
ls -l
```
From within RStudio (or any Open OnDemand app), you can now easily navigate to `~/scratch` and work in scratch storage, even though the container starts in your home directory.

> **Important notes about symbolic links:**
> 
> * A symbolic link is not a copy of the directory—it is a pointer
> * Deleting the link does not delete the target directory or its contents
> * You can safely remove the link later with:
> ```bash 
> rm ~/scratch
> ```
> Your data in `/gscratch/scrubbed/$USER` will remain intact.

These setup steps ensured that interactive applications launched through Open OnDemand can access appropriate storage locations without risking home directory quota issues.