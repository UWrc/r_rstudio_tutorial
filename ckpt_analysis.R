#ckpt data analysis
#purpose: find a mean job requested vs. job run time
#finchkn

#libraries----
library(tidyverse)

#set working directory----

#ADJUST THE FOLLOWING LINE 
#INSERT YOUR UWNETID
setwd("/gscratch/scrubbed/<$USER>/r_rstudio_tutorial/")

#data----
ckpt<-read.csv("sacct_ckpt_lite.csv",header=1, quote = "",row.names = NULL,stringsAsFactors = FALSE)

ckpt$X<-NULL

ckpt<-ckpt%>%filter(Partition == "ckpt")

ckpt$TimelimitRaw<-as.numeric(ckpt$TimelimitRaw)
ckpt$ElapsedRaw<-as.numeric(ckpt$ElapsedRaw)
summary(ckpt$ElapsedRaw)
ckpt<-ckpt%>%mutate(ElapsedRawMin = ElapsedRaw/60)
summary(ckpt$ElapsedRawMin)
summary(ckpt$TimelimitRaw)

ckpt$ReqMem<-gsub("G","",ckpt$ReqMem)
ckpt$ReqMem<-as.numeric(ckpt$ReqMem)

ckpt<-ckpt%>%separate(State,into=c("State","byNote"),sep=" by ",remove=FALSE)%>%separate(JobID,into=c("Job","JobArray_index"),sep="_",remove=FALSE)

ckpt$array_job <- ifelse(is.na(ckpt$JobArray_index),"no", "yes")
head(ckpt)
table(ckpt$array_job)

table(ckpt$State)

unlimited_jobs<-ckpt%>%filter(ElapsedRawMin>=307)
#write.csv(unlimited_jobs,"unlimited_jobs.csv",row.names=FALSE,quote=FALSE)

ckpt<-ckpt%>%filter(!JobID %in% unlimited_jobs$JobID)

(byState<-ggplot(aes(x=State,fill=array_job,color=Partition),data=ckpt)+
  geom_bar(size=1)+
  scale_color_manual(values = c("black"),guide=FALSE)+
  scale_fill_manual(values = c("white","darkgray"),name="Array Job?",labels=c("","yes"))+ 
  labs(x="State",y="Number of Jobs",title="Jobs by State")+
  #ylim(c(0,6050))+
  theme_bw()+
  theme(legend.position = "bottom",
        axis.text.x=element_text(size=6.25),
        axis.title.x=element_text(size=8),
        axis.text.y=element_text(size=6.5),
        axis.title.y=element_text(size=8)))

ggsave("byState.pdf",byState,width=6,height=4)

(dist_time<-ggplot()+geom_histogram(data = ckpt,aes(x=ElapsedRawMin,fill=State))+
  geom_vline(xintercept=305,size=1,color="firebrick")+
  labs(x="Job time (min)",y="Count",title="Jobs sample (n=160976)")+
  theme_bw())

ggsave("dist_time.pdf",dist_time,width=6,height=4)
