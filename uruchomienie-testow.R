odpalenie_java <- 'java -jar ./out/artifacts/mgrmaven_jar/mgrmaven.jar '

#setwd("C:/Users/Seba/OneDrive/Dokumenty/Projekty/IntelliJ/mgrmaven")

work1 <- '"input\\turnover.csv" "exp, event" "branch + pipeline" "'
work2 <- '"input\\turnover-mln-0-8.csv" "exp, event" "branch + pipeline" "'
work3 <- '"input\\turnover-mln-3.csv" "exp, event"  "branch + pipeline" "'
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



# java -jar ./out/artifacts/mgrmaven_jar/mgrmaven.jar "covid.csv" "offset, survival" "intubated" "sex + age + finding + survival + intubated + intubation_present + went_icu + in_icu + needed_supplemental_O2 + extubated + temperature + pO2_saturation + leukocyte_count + neutrophil_count + lymphocyte_count + view + modality" 8

# rscript --vanilla script.r covid.csv output-seq.txt km_seq.jpg cph_seq.jpg output_seq , ramka_seq.rds "offset, survival" "intubated" "sex + age + finding + survival + intubated + intubation_present + went_icu + in_icu + needed_supplemental_O2 + extubated + temperature + pO2_saturation + leukocyte_count + neutrophil_count + lymphocyte_count + view + modality" T

watki <- c(10)

# parametry <- c(work_edw, work_edw2, ret, ret2, lungs, lungs2, colon, colon2, flchain, flchain2, gbsg, gbsg2, kidney, kidney2, 
#               mgus, mgus2, myeloid, myeloid2, nafld1, nafld1_2)
# parametry <- c(work1, work2, work3, prost1, prost2, prost3, work_edw, work_edw2)
# parametry <- c(colon, colon2, flchain, flchain2, gbsg, gbsg2, kidney, kidney2)
parametry <- c(lungs)
suma_iteracji <- length(parametry) * length(watki) * 1
iteracja <- 0

for(slowo in parametry){ # petla z zestawem parametrow wywolujacych
  for(j in watki){ # testowac bedziemy od x do y watkow
    for(i in 1:1){ # liczba testow dla tej samej liczby watkow
      iteracja <- iteracja + 1
      liczba_watkow <- j
      polecenie <- paste0(odpalenie_java, slowo,liczba_watkow,'"')
      print(polecenie)
      print(paste0("Iteracja: ",iteracja," / ", suma_iteracji, ", liczba watkow: ",j,", godzina: ",format(Sys.time())))
      # javaOutput <- system(polecenie, intern = TRUE)
      
    }
  }
}

cat(polecenie)
