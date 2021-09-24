odpalenie_java <- 'java -jar ./out/artifacts/mgrmaven_jar/mgrmaven.jar '

work1 <- '"turnover.csv" "exp, event" "branch" "branch + pipeline" "'
work2 <- '"turnover-mln-0-8.csv" "exp, event" "branch" "branch + pipeline" "'
work3 <- '"turnover-mln-3.csv" "exp, event" "branch" "branch + pipeline" "'
prost1 <- '"prostate_cancer.csv" "time, status" "treatment" "treatment + age + sh + size + index" "'
prost2 <- '"prost_cancer_gen_mln.csv" "time, status" "treatment" "treatment + age + sh + size + index" "'
colorectal1 <- '"colorectal-cancer.csv" "dfs_in_months, dfs_event" "gender" "age_in_years + dukes_stage + gender + location + adj_radio + adj_chem" "' 
colorectal2 <- '"colorectal-cancer-mln.csv" "dfs_in_months, dfs_event" "gender" "age_in_years + dukes_stage + gender + location + adj_radio + adj_chem" "' 
work_edw <- '"turnover-edward.csv" "stag,event" "profession" "gender+age+industry+profession+traffic+coach+head_gender+greywage+way+extraversion+independ+selfcontrol+anxiety+novator" "'
work_edw2 <- '"turnover-edward-mln.csv" "stag,event" "profession" "gender+age+industry+profession+traffic+coach+head_gender+greywage+way+extraversion+independ+selfcontrol+anxiety+novator" "' 
ret <- '"retinopatia.csv" "tr_time, tr_status" "laser_type" "laser_type + eye + age + type + tr_group" "'
ret2 <- '"retinopatia-mln.csv" "tr_time, tr_status" "laser_type" "laser_type + eye + age + type + tr_group" "'


# java -jar ./out/artifacts/mgrmaven_jar/mgrmaven.jar "covid.csv" "offset, survival" "intubated" "sex + age + finding + survival + intubated + intubation_present + went_icu + in_icu + needed_supplemental_O2 + extubated + temperature + pO2_saturation + leukocyte_count + neutrophil_count + lymphocyte_count + view + modality" 8

# rscript --vanilla script.r covid.csv output-seq.txt km_seq.jpg cph_seq.jpg output_seq , ramka_seq.rds "offset, survival" "intubated" "sex + age + finding + survival + intubated + intubation_present + went_icu + in_icu + needed_supplemental_O2 + extubated + temperature + pO2_saturation + leukocyte_count + neutrophil_count + lymphocyte_count + view + modality" T

watki <- c(10)

#parametry <- c(work1, work2, work3, prost1, prost2, colorectal1, colorectal2, work_edw, work_edw2)
parametry <- c(covid)
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
      print(paste0("Czas wykonania powyzszej instrukcji: ",time.taken, " sekund(y)")) # zakomentowane na czas testow
    }
  }
}

