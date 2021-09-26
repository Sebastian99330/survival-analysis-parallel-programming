odpalenie_java <- 'java -jar ./out/artifacts/mgrmaven_jar/mgrmaven.jar '

# setwd("C:/Users/Seba/OneDrive/Dokumenty/Projekty/IntelliJ/mgrmaven")

work1 <- '"turnover.csv" "exp, event" "branch + pipeline" "'
work2 <- '"turnover-mln-0-8.csv" "exp, event" "branch + pipeline" "'
work3 <- '"turnover-mln-3.csv" "exp, event"  "branch + pipeline" "'
prost1 <- '"prostate_cancer.csv" "time, status" "treatment + age + sh + size + index" "'
prost2 <- '"prost_cancer_gen_mln.csv" "time, status" "treatment + age + sh + size + index" "'
prost3 <- '"prostate_cancer_mln.csv" "time, status" "treatment + age + sh + size + index" "'
colorectal1 <- '"colorectal-cancer.csv" "dfs_in_months, dfs_event" "age_in_years + dukes_stage + gender + location + adj_radio + adj_chem" "' 
colorectal2 <- '"colorectal-cancer-mln.csv" "dfs_in_months, dfs_event" "age_in_years + dukes_stage + gender + location + adj_radio + adj_chem" "' 
work_edw <- '"turnover-edward.csv" "stag,event" "gender+age+industry+profession+traffic+coach+head_gender+greywage+way+extraversion+independ+selfcontrol+anxiety+novator" "'
work_edw2 <- '"turnover-edward-mln.csv" "stag,event" "gender+age+industry+profession+traffic+coach+head_gender+greywage+way+extraversion+independ+selfcontrol+anxiety+novator" "' 
work_edw3 <- '"turnover-edward-mln-2.csv" "stag,event" "gender+age+industry+profession+traffic+coach+head_gender+greywage+way+extraversion+independ+selfcontrol+anxiety+novator" "'
ret <- '"retinopatia.csv" "tr_time, tr_status" "laser_type + eye + age + type + tr_group" "'
ret2 <- '"retinopatia-mln.csv" "tr_time, tr_status" "laser_type + eye + age + type + tr_group" "'
lungs <- '"lungs.csv" "time, status" "age + sex + ph_ecog + ph_karno + pat_karno + meal_cal + wt_loss" "'
lungs2 <- '"lungs-mln.csv" "time, status" "age + sex + ph_ecog + ph_karno + pat_karno + meal_cal + wt_loss" "'
colon <- '"colon.csv" "time, status" "rx + sex + age + obstruct + perfor + adhere + nodes + differ + extent + surg + node4 + etype" "'
colon2 <- '"colon-mln.csv" "time, status" "rx + sex + age + obstruct + perfor + adhere + nodes + differ + extent + surg + node4 + etype" "'
flchain <- '"flchain.csv" "futime, death" "age + sex + sample_yr + kappa + lambda + flc_grp + creatinine + mgus + chapter" "'
flchain2 <- '"flchain-mln.csv" "futime, death" "age + sex + sample_yr + kappa + lambda + flc_grp + creatinine + mgus + chapter" "'
gbsg <- '"gbsg.csv" "rfstime, status" "age + meno + size + grade + nodes + pgr + er + hormon" "'
gbsg2 <- '"gbsg-mln.csv" "rfstime, status" "age + meno + size + grade + nodes + pgr + er + hormon" "'
kidney <- '"kidney.csv" "time, status" "age + sex + disease + frail" "'
kidney2 <- '"kidney-mln.csv" "time, status" "age + sex + disease + frail" "'
mgus <- '"mgus.csv" "futime, death" "age + sex + pcdx + pctime + alb + creat + hgb + mspike" "'
mgus2 <- '"mgus-mln.csv" "futime, death" "age + sex + pcdx + pctime + alb + creat + hgb + mspike" "'
myeloid <- '"myeloid.csv" "futime, death" "trt + sex + txtime + crtime + rltime" "'
myeloid2 <- '"myeloid-mln.csv" "futime, death" "trt + sex + txtime + crtime + rltime" "'
nafld1 <- '"nafld1.csv" "futime, status" "age + male + weight + height + bmi" "'
nafld1_2 <- '"nafld1-mln.csv" "futime, status" "age + male + weight + height + bmi" "'
nwtco <- '"nwtco.csv" "edrel, rel" "instit + histol + stage + study + age + in_subcohort" "'
nwtco2 <- '"nwtco-mln.csv" "edrel, rel" "instit + histol + stage + study + age + in_subcohort" "'
pbc <- '"pbc.csv" "time, status" "trt + age + sex + ascites + hepato + spiders + edema + bili + chol + albumin + copper + alk.phos + ast + trig + platelet + protime + stage" "'
pbc2 <- '"pbc-mln.csv" "time, status" "trt + age + sex + ascites + hepato + spiders + edema + bili + chol + albumin + copper + alk.phos + ast + trig + platelet + protime + stage" "'



# java -jar ./out/artifacts/mgrmaven_jar/mgrmaven.jar "covid.csv" "offset, survival" "intubated" "sex + age + finding + survival + intubated + intubation_present + went_icu + in_icu + needed_supplemental_O2 + extubated + temperature + pO2_saturation + leukocyte_count + neutrophil_count + lymphocyte_count + view + modality" 8

# rscript --vanilla script.r covid.csv output-seq.txt km_seq.jpg cph_seq.jpg output_seq , ramka_seq.rds "offset, survival" "intubated" "sex + age + finding + survival + intubated + intubation_present + went_icu + in_icu + needed_supplemental_O2 + extubated + temperature + pO2_saturation + leukocyte_count + neutrophil_count + lymphocyte_count + view + modality" T

watki <- c(4)

#parametry <- c(work1, work2, work3, prost1, prost2, colorectal1, colorectal2, work_edw, work_edw2)
# parametry <- c(work_edw, work_edw2, ret, ret2, lungs, lungs2, colon, colon2, flchain, flchain2, gbsg, gbsg2, kidney, kidney2, 
#               mgus, mgus2, myeloid, myeloid2, nafld1, nafld1_2)
parametry <- c(work_edw2)
iteracja <- 0
suma_iteracji <- length(parametry) * length(watki) * 1

for(slowo in parametry){ # petla z zestawem parametrow wywolujacych
  for(j in watki){ # testowac bedziemy od x do y watkow
    for(i in 1:1){ # liczba testow dla tej samej liczby watkow
      iteracja <- iteracja + 1
      liczba_watkow <- j
      polecenie <- paste0(odpalenie_java, slowo,liczba_watkow,'"')
      print(polecenie)
      print(paste0("Iteracja: ",iteracja," / ", suma_iteracji, ", liczba watkow: ",j,", godzina: ",format(Sys.time())))
      start.time <- Sys.time() 
      
      javaOutput <- system(polecenie, intern = TRUE)
      
      end.time <- Sys.time()
      time.taken <- as.numeric(end.time - start.time)
      time.taken <- format(round(time.taken, 2), nsmall = 2) # formatowanie do dwoch miejsc po przecinku
      print(paste0("Czas wykonania powyzszej instrukcji: ",time.taken, " sekund(y)"))
    }
  }
}
