# RStudio via Open OnDemand

**Open OnDemand (OOD)** is a web-based interface to Hyak Klone that provides a **graphical alternative to the command line**. It is especially useful for workflows that benefit from a graphical user interface (GUI), such as data analysis and other workflows in R.

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

> ### Access Note (VPN)
>
> If you are accessing Hyak from **off campus**, you may need to connect to the **UW VPN**.
>
> To access Hyak Open OnDemand services from an off-campus location, first connect to the UW VPN.
>
> Follow the [**Husky OnNet instructions**](https://itconnect.uw.edu/tools-services-support/networks-connectivity/husky-onnet/installing-configuring-and-using-husky-onnet/).
>
> ***Note:*** VPN setup differs for Windows and macOS. Follow the instructions for your operating system.
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
1. Changing the **Account** field to "uwit" if available. 
2. Changing the **Partition** field to "compute" if available. Select another field that is available to you. Demonstration account users should select "ckpt" to request a compute resource from our community idle resources; *queue wait times may vary*. 
3. Changing the **"RStudio Server Container"** field to "rocker/tidyverse".

> ***Note:*** The containers listed in the form are **maintained by the Hyak team** and provide preconfigured R environments. 

4. In the field **User R library path (R_LIBS_USER)**, enter: `/gscratch/scrubbed/$USER/R`

> Even though you configured `R_LIBS` in your `.Renviron` file, you must also set it in the RStudio launch form. This ensures that R packages are installed in scratch storage rather than your home directory.

The next field of the form set up the resources requested for your job. For our purposes set: 

5. **Tasks** to 1
6. **CPUs per tasks** to 1
7. **Memory (GB)** to 40
8. **Number of hours** to 2

And press the **Launch** button. 

## Starting Your Session
After submitting the form, your job will be submitted to Slurm (Hyak Klone's job scheduler). When it is ready, the session page will display:
* Slurm Job ID – the scheduler identifier. This is the number in the parentheses. 
* Host – the compute node running your job.
* Status – shows Running when ready.
* Session ID – links to detailed logs for troubleshooting.

Once the job is running, click the **"Connect to RStudio Server"** button to open it in a new browser tab.

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

## Gracefully Ending the Session
We will return to RStudio in OOD later. Let's close the current session properly to avoid server errors. 

Use the orange power button in the top right corner of the screen to end the R Session. Once the "R Session Ended" message is shown, you can close your browser window. 

![Screenshot showing the R session indicating the power button to end the session. A message will appear showing that the session has ended.](./img/end-r-session.png 'End session')
*Screenshot showing the R session indicating the power button to end the session. A message will appear showing that the session has ended.*

From there, you can return to the browser tab where "My Interactive Sessions" shows your job and delete it. 

![Screenshot showing the My Interactive Sessions section of OOD and indicating the delete button to cancel the job.](./img/delete-job.png 'Delete job')
*Screenshot showing the My Interactive Sessions section of OOD and indicating the delete button to cancel the job.*

> ***Troubleshooting:*** If the RStudio session starts showing there was a server error, refresh the page. 

## From Interactive RStudio to Reproducible Environments
You now have RStudio running through Open OnDemand and are working from scratch storage, which is the recommended location for active analysis and tutorial files. At this stage, you can explore data, run R code interactively, and install many common R packages into your personal R library.

This workflow is ideal for learning, prototyping, and short-term analysis. However, as your projects grow in complexity, or need to be shared, rerun, or scaled on the cluster, it becomes important to think more carefully about how your software environment is defined and preserved.

This is where containers come in.
