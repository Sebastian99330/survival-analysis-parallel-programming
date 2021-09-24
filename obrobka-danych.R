df <- read.table("covid.csv",sep=",",header = T)

head(df2)
names(df2)
sapply(df2, class)

df2 <- na.omit(df)

df <- df[,-1]

# usuniecie niechcianych kolumn
df <- df[,c("offset","sex","age","finding", "survival","intubated","intubation_present","went_icu","in_icu",
             "needed_supplemental_O2","extubated","temperature","pO2_saturation","leukocyte_count", "neutrophil_count",
             "lymphocyte_count","view","modality")]


# zamiana 2 na 0 w kolumnie status
df2$offset [df2$offset  =="NAs"] <- NA
df2$extubated [df2$extubated  =="N"] <- 0
head(df2)

df3 <- df2


# "intubated","intubation_present","went_icu","in_icu","needed_supplemental_O2","extubated"
cols = c("offset")
df2[,c(cols)] <- as.numeric(df2[,c(cols)])


# zamiana przecinka na kropke w kolumnie time
df$untr_time <- as.numeric(gsub(",", ".", gsub("\\.", "", df$untr_time)))

# wypisanie dwoch polaczonych df
library(dplyr)
merge(df,df2, by="age") %>% 
  select(status.x, status.y) %>%
  head(40)
nrow(df)



write.csv(df,"covid.csv",row.names = F)
