setwd("/Users/dengshuyang/Downloads/data copy_1")
#һ?????????ݣ?????��???ֶ?  Active?? Placebo????????ǰ???????Ƿ???ȡ?÷??????ƣ?
#1 ?????? 0 ??????
Treatment=read.csv("Treatment.csv")
str(Treatment)
label=as.character(names(table(Treatment$Study_Arm)))


Treatment$Treatment_Group_Delta[is.na(Treatment$Treatment_Group_Delta)]=10000
Treatment$Active=0

Treatment$Active[Treatment$Study_Arm=="Active"&Treatment$Treatment_Group_Delta<=90]=1

Treatment$Placebo=0

Treatment$Placebo[Treatment$Study_Arm=="Placebo"&Treatment$Treatment_Group_Delta<=90]=1
Treatment=Treatment[,c("subject_id","Active","Placebo")]
head(Treatment)
# ǰ?????? alsfrsƽ?? ֵ  
alsfrs=read.csv("alsfrs.csv")
str(alsfrs)
head(alsfrs)
alsfrs=alsfrs[alsfrs$ALSFRS_Delta<=90,]

alsfrs3= aggregate(alsfrs[,c("ALSFRS_Total")],by=list(alsfrs$subject_id),mean)
names(alsfrs3)=c("subject_id","ALSFRS_Total3")

# ǰ??-12???? alsfrsƽ?? ֵ 
alsfrs=read.csv("alsfrs.csv")
str(alsfrs)
head(alsfrs)
alsfrs=alsfrs[alsfrs$ALSFRS_Delta<=360&alsfrs$ALSFRS_Delta>=90,]

alsfrs3_12= aggregate(alsfrs[,c("ALSFRS_Total")],by=list(alsfrs$subject_id),mean)
names(alsfrs3_12)=c("subject_id","ALSFRS_Total3_12")


# ǰ?????? Fvcƽ?? ֵ 
Fvc=read.csv("Fvc.csv")
str(Fvc)
head(Fvc)

Fvc=Fvc[Fvc$Forced_Vital_Capacity_Delta<=90,]

Fvc3= aggregate(Fvc[,c("Subject_Liters_Trial_1"   , "pct_of_Normal_Trial_1"     ,"Subject_Liters_Trial_2"     
                       , "pct_of_Normal_Trial_2"  ,     "Subject_Liters_Trial_3"    ,  "pct_of_Normal_Trial_3"
                       , "Subject_Normal"    )],by=list(Fvc$subject_id),mean)


head(Fvc3)

names(Fvc3)[1]="subject_id"

# ǰ?????? Svcƽ?? ֵ 
Svc=read.csv("Svc.csv")
str(Svc)
head(Svc)

Svc=Svc[Svc$Slow_vital_Capacity_Delta<=90,]

Svc3= aggregate(Svc[,c("Subject_Liters_Trial_1"  ,  "pct_of_Normal_Trial_1"   ,  
                      "pct_of_Normal_Trial_2"  ,   "pct_of_Normal_Trial_3"  ,   "Subject_Normal"   )],by=list(Svc$subject_id),mean)


head(Svc3)

names(Svc3)[1]="subject_id"


#???廷??
demographics=read.csv("demographics.csv")
head(demographics)
demographics1=c()
for(i in 1:length(demographics$subject_id)){
  x=names(demographics)[which(demographics[demographics$subject_id==demographics$subject_id[i],]==1)]
  if(length(x)==0){ demographics1[i]=NA}else{ demographics1[i]=x}

  
  
}
demographics$demographics=demographics1
demographics=demographics[,c("subject_id","Sex","Age","demographics")]
#ALS??ʷ
AlsHistory=read.csv("AlsHistory.csv")
AlsHistory=AlsHistory[,c("subject_id","Subject_ALS_History_Delta","Onset_Delta","Diagnosis_Delta")]
#help(read.csv)
head(AlsHistory)
#????ָ??

setwd("/home/email/R")
Labs=read.csv("Labs.csv",stringsAsFactors=F)
Labs=Labs[Labs$Laboratory_Delta<=90,]
head(Labs)
nam=unique(Labs$Test_Name)
a=list()
i=1
p=unique(Labs$subject_id)

for(sub in p){
 a[['subject_id']][i]=sub
for(n in  nam[1:60]){
 x= Labs$Test_Result[Labs$Test_Name==n&Labs$subject_id==sub]
 x=x[!is.na(x)]
 if(length(x)==0){a[[n]][i]=NA}else{
 y=as.numeric(x)
 if(length(y[!is.na(y)])==0){
   tb=table(x) 
   a[[n]][i]=names(tb[tb==max(tb)])
 }else{
  
   a[[n]][i]=mean(y)  
   
}}
}
i=i+1
print(i)
}



b=data.frame(a)
write.table(b,file="labes1.csv")

b=read.table("labes1.csv")
head(b)
#?ϲ?????  
all_data=merge(Treatment,b, by.x = "subject_id", by.y = "subject_id",all.x=TRUE)
all_data=merge(all_data,alsfrs3, by.x = "subject_id", by.y = "subject_id",all.x=TRUE)
all_data=merge(all_data,alsfrs3_12, by.x = "subject_id", by.y = "subject_id",all.x=TRUE)
all_data=merge(all_data,demographics, by.x = "subject_id", by.y = "subject_id",all.x=TRUE)
all_data=merge(all_data,AlsHistory, by.x = "subject_id", by.y = "subject_id",all.x=TRUE)
all_data=merge(all_data,Svc3, by.x = "subject_id", by.y = "subject_id",all.x=TRUE)
all_data=merge(all_data,Fvc3, by.x = "subject_id", by.y = "subject_id",all.x=TRUE)

1  subject_id
2-3 Treatment  (Active,Placebo)
4-63 lab
64 ALSFRS_Total3
65 ALSFRS_Total3_12
66-68 sex age  demographics
69-71  Subject_ALS_History_Delta  Onset_Delta  Diagnosis_Delta
72-83  SVC  FVC
str(all_data)
write.table(all_data,file="all_data.csv",sep=",")

#####################????Ϊ???ݴ???############################################

all_data=read.csv("all_data.csv",stringsAsFactors=F)
#????ΪNA ???Ծ?ֵ?滻 
for(name in names(all_data))
{ 
 
 if( is.numeric(all_data[,name])){ 
   
   all_data[is.na(all_data[,name]),name]=mean(as.numeric(all_data[,name]),na.rm = T)
   
   
   }
  
  

  
}
  
  

str(all_data)



#??ģ  Ԥ??3-12?µ?alsfrsֵ   
##?ع???   
overFit1 <- rpart(ALSFRS_Total3_12 ~.,data=all_data[,-1]
                  
)

#ģ?ͽ???
summary(overFit1)
#?в?
summary(residuals(overFit1))
#?в?????
plot(predict(overFit1),residuals(overFit1))

#Ԥ??????
ALSFRS_Total3_12_new=predict(overFit1)

#R ??
R2<-function(y_test, y_true){
  
  return (1 - (sum((y_test - y_true)^2)/sum((y_true - mean(y_true))^2)) )   
  
}

R2(ALSFRS_Total3_12_new,all_data$ALSFRS_Total3_12)


