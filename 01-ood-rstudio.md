# RStudio via Open OnDemand

**Open OnDemand (OOD)** is a web-based interface to Hyak Klone that provides a **graphical alternative to the command line**. It is especially useful for workflows that benefit from a graphical user interface (GUI).

You can access **Hyak Klone’s Open OnDemand** instance at:  
👉 **https://ondemand.hyak.uw.edu/**

## When Should You Use Open OnDemand?

Open OnDemand is the **recommended way** to run GUI-based applications on Hyak, including:

- **RStudio**
- **Jupyter notebooks**
- **VS Code**
- Other interactive or desktop-style applications

OOD is also helpful if you want to:
- Navigate files by **clicking through directories**
- Quickly **view plots or images**
- Download small output files (logs, figures, results)

> **Access Note (VPN)**
>
> If you are accessing Hyak from **off campus**, you may need to connect to the **UW VPN**.
>
> To access Hyak Open OnDemand services from an off-campus location, first connect to the UW VPN.
>
> Follow the [**Husky OnNet instructions**](https://itconnect.uw.edu/tools-services-support/networks-connectivity/husky-onnet/installing-configuring-and-using-husky-onnet/).
>
> **Note:** VPN setup differs for Windows and macOS. Follow the instructions for your operating system.
>
> **MacOS Tahoe:**
>
>At this time, the **Big-IP Edge Client** is not supported on macOS 26 (Tahoe).
>
> Instead, install **F5 Access** from the App Store and configure it following the *Selecting a Server on iOS* instructions on the  
[**Selecting a Husky OnNet Server**](https://uwconnect.uw.edu/it?id=kb_article_view&sysparm_article=KB0034248) page.
>
>If you encounter VPN issues, contact **help@uw.edu**.

## Launching RStudio with Open OnDemand

1. Log in to **https://ondemand.hyak.uw.edu/** using your UW NetID and Duo.
2. From the top menu, select **Interactive Apps → RStudio**.

![Screenshot showing the OOD dashboard and an arrow indicating the Interactive Apps menu and showing the RStudio application.](./img/open-form.png 'Interactive Apps')
*Screenshot showing the OOD dashboard. The arrow indicate the Interactive Apps menu and shows the RStudio application.*

This opens a form where you will configure your interactive RStudio job.

![Screenshot showing the RStudio launch form. Arrows indicate the account field, partition field, and container field. A box shows the field where the user should insert the path to their working directory for this tutorial.](./img/fill-form.png 'RStudio Launch Form')
*Screenshot showing the RStudio launch form. Arrows indicate the account field, partition field, and container field. A box shows the field where the user should insert the path to their working directory for this tutorial.*

For this part of the tutorial, set up the form by: 
1. Changing the account field to "uwit" if available. 
2. Changing the partition field to "compute" if available. Select another field that is available to you. Demonstration account users should select "ckpt" to request a compute resource from our community idle resources; *queue wait times may vary*. 
3. Changing the "RStudio Server Container" fiel to "rocker/tidyverse".

> **Note:** The containers listed in the form are **maintained by the Hyak team** and provide preconfigured R environments. 

4. In the field **User R library path (R_LIBS_USER)**, enter: `/gscratch/scrubbed/$USER/R`

> Even though you configured `R_LIBS` in your `.Renviron` file, you must also set it in the RStudio launch form. This ensures that R packages are installed in scratch storage rather than your home directory.

The next field of the form set up the resources requested for your job. For our purposes set: 

5. Tasks to 1
6. CPUs per tasks to 1
7. Memory (GB) to 40
8. Number of hours to 2

And press the Launch button. 

## Starting Your Session
After submitting the form, your job will be submitted to Slurm (Hyak Klone's job scheduler). When it is ready, the session page will display:
* Slurm Job ID – the scheduler identifier. This is the number in the parentheses. 
* Hostname – the compute node running your job.
* Status – shows Running when ready.
* Session ID – links to detailed logs for troubleshooting.

Once the job is running, click the "Connect to RStudio Server" button to open it in a new browser tab.

![Screenshot showing your OOD job queue. The job will be ready when the status changes to "Running" and the button to "Connect to RStudio Server" is visible.](./img/start-job.png 'OOD job queue')
*Screenshot showing your OOD job queue. The job will be ready when the status changes to "Running" and the button to "Connect to RStudio Server" is visible.*

## Navigating Files in RStudio

When RStudio opens, the Files pane (bottom right) shows your **home directory**, which is the container’s root. 

You should see the symbolic link you created earlier:
```bash
scratch → /gscratch/scrubbed/$USER
```

![Screenshot showing RStudio Server and a red box around the Files window in the bottom right. The arrow indicates the scratch directory or your working directory containing tutorial files. This shortcut was made with a symbolic link.](./img/rstudio-scratch.png 'scratch short cut')
*Screenshot showing RStudio Server. The red box shows the Files window in the bottom right. The arrow indicates the scratch directory or your working directory containing tutorial files. This shortcut was made with a symbolic link.*

Navigate into `scratch` to access your working directory and tutorial files. All work done there uses scratch storage and avoids home directory quota issues.

## Installing R Packages and Understanding Container Limits
At this point, you should have RStudio running in your browser and be able to begin working interactively.

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

In the next section, we’ll walk through how to build a custom R container that includes the dependencies and packages you need, so your R workflows remain stable, reproducible, and portable on Hyak.