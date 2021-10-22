odpalenie_java <- 'java -jar ./out/artifacts/mgrmaven_jar/mgrmaven.jar '

setwd("C:/Users/Seba/OneDrive/Dokumenty/Projekty/IntelliJ/mgrmaven")

work1 <- '"input\\turnover.csv" "exp, event" "branch + pipeline" "'
work2 <- '"input\\turnover-mln-0-8.csv" "exp, event" "branch + pipeline" "'
work3 <- '"input\\turnover-mln-7.csv" "exp, event"  "branch + pipeline" "'
prost1 <- '"input\\prostate_cancer.csv" "time, status" "treatment + age + sh + size + index" "'
prost2 <- '"input\\prost_cancer_gen_mln.csv" "time, status" "treatment + age + sh + size + index" "'
prost3 <- '"input\\prostate_cancer_mln.csv" "time, status" "treatment + age + sh + size + index" "'
colorectal1 <- '"input\\colorectal-cancer.csv" "dfs_in_months, dfs_event" "age_in_years + dukes_stage + gender + location + adj_radio + adj_chem" "' 
colorectal2 <- '"input\\colorectal-cancer-mln.csv" "dfs_in_months, dfs_event" "age_in_years + dukes_stage + gender + location + adj_radio + adj_chem" "' 
work_edw <- '"input\\turnover-edward.csv" "stag,event" "gender+age+industry+profession+traffic+coach+head_gender+greywage+way+extraversion+independ+selfcontrol+anxiety+novator" "'
work_edw2 <- '"input\\turnover-edward-mln.csv" "stag,event" "gender+age+industry+profession+traffic+coach+head_gender+greywage+way+extraversion+independ+selfcontrol+anxiety+novator" "' 
ret <- '"input\\retinopatia.csv" "tr_time, tr_status" "laser_type + eye + age + type + tr_group" "'
ret2 <- '"input\\retinopatia-mln.csv" "tr_time, tr_status" "laser_type + eye + age + type + tr_group" "'
lungs <- '"input\\lungs.csv" "time, status" "age + sex + ph_ecog + ph_karno + pat_karno + meal_cal + wt_loss" "'
lungs2 <- '"input\\lungs-mln.csv" "time, status" "age + sex + ph_ecog + ph_karno + pat_karno + meal_cal + wt_loss" "'
colon <- '"input\\colon.csv" "time, status" "rx + sex + age + obstruct + perfor + adhere + nodes + differ + extent + surg + node4 + etype" "'
colon2 <- '"input\\colon-mln.csv" "time, status" "rx + sex + age + obstruct + perfor + adhere + nodes + differ + extent + surg + node4 + etype" "'
flchain <- '"input\\flchain.csv" "futime, death" "age + sex + sample_yr + kappa + lambda + flc_grp + creatinine + mgus + chapter" "'
flchain2 <- '"input\\flchain-mln.csv" "futime, death" "age + sex + sample_yr + kappa + lambda + flc_grp + creatinine + mgus + chapter" "'
gbsg <- '"input\\gbsg.csv" "rfstime, status" "age + meno + size + grade + nodes + pgr + er + hormon" "'
gbsg2 <- '"input\\gbsg-mln.csv" "rfstime, status" "age + meno + size + grade + nodes + pgr + er + hormon" "'
kidney <- '"input\\kidney.csv" "time, status" "age + sex + disease + frail" "'
kidney2 <- '"input\\kidney-mln.csv" "time, status" "age + sex + disease + frail" "'
mgus <- '"input\\mgus.csv" "futime, death" "age + sex + pcdx + pctime + alb + creat + hgb + mspike" "'
mgus2 <- '"input\\mgus-mln.csv" "futime, death" "age + sex + pcdx + pctime + alb + creat + hgb + mspike" "'
myeloid <- '"input\\myeloid.csv" "futime, death" "trt + sex + txtime + crtime + rltime" "'
myeloid2 <- '"input\\myeloid-mln.csv" "futime, death" "trt + sex + txtime + crtime + rltime" "'
nafld1 <- '"input\\nafld1.csv" "futime, status" "age + male + weight + height + bmi" "'
nafld1_2 <- '"input\\nafld1-mln.csv" "futime, status" "age + male + weight + height + bmi" "'
nwtco <- '"input\\nwtco.csv" "edrel, rel" "instit + histol + stage + study + age + in_subcohort" "'
nwtco2 <- '"input\\nwtco-mln.csv" "edrel, rel" "instit + histol + stage + study + age + in_subcohort" "'
pbc <- '"input\\pbc.csv" "time, status" "trt + age + sex + ascites + hepato + spiders + edema + bili + chol + albumin + copper + alk.phos + ast + trig + platelet + protime + stage" "'
pbc2 <- '"input\\pbc-mln.csv" "time, status" "trt + age + sex + ascites + hepato + spiders + edema + bili + chol + albumin + copper + alk.phos + ast + trig + platelet + protime + stage" "'


same_male <- c(work1, prost1, colorectal1, work_edw, ret, lungs, colon, flchain, gbsg, kidney, mgus, myeloid,
               nafld1, nwtco, pbc)
same_mln <- c(work2, work3, prost2, prost3, colorectal2, work_edw2, ret2, lungs2, colon2, flchain2, gbsg2,
kidney2, mgus2, myeloid2, nafld1_2, nwtco2, pbc2)

# testy_uruchomione_dla_zbiorow <- c(kidney2, mgus2, myeloid2, nafld1_2, nwtco2, pbc2) # mniejsza wersja bo przerwalo testy w trakcie

testy_uruchomione_dla_zbiorow <- same_male

watki <- c(3:10)

parametry <- testy_uruchomione_dla_zbiorow
suma_iteracji <- length(parametry) * length(watki) * 6
iteracja <- 0

for(slowo in parametry){ # petla z zestawem parametrow wywolujacych
  for(j in watki){ # testowac bedziemy od x do y watkow
    for(i in 1:6){ # liczba testow dla tej samej liczby watkow
      iteracja <- iteracja + 1
      liczba_watkow <- j
      polecenie <- paste0(odpalenie_java, slowo,liczba_watkow,'"')
      print(polecenie)
      print(paste0("Iteracja: ",iteracja," / ", suma_iteracji, ", liczba watkow: ",j,", godzina: ",format(Sys.time())))
      javaOutput <- system(polecenie, intern = TRUE)
      
    }
  }
}

# cat(polecenie)

# dzielenie zbioru:
# polecenie <- "rscript --vanilla dzielenie-zbioru-seq.R input//nwtco-mln.csv 10 output//split-data//zbior_"
# system.time(system(polecenie, intern = TRUE))
