odpalenie_java <- 'java -jar ./out/artifacts/mgrmaven_jar/mgrmaven.jar '

work1 <- '"turnover.csv" "exp, event" "branch" "branch + pipeline" "'
work2 <- '"turnover-mln-0-8.csv" "exp, event" "branch" "branch + pipeline" "'
# work3 <- '"turnover-mln-3.csv" "exp, event" "branch" "branch + pipeline" "'
# prost1 <- '"prostate_cancer.csv" "time, status" "treatment" "treatment + age + sh + size + index" "'
#prost2 <- '"prost_cancer_gen_mln.csv" "time, status" "treatment" "treatment + age + sh + size + index" "'
# colorectal1 <- '"colorectal-cancer.csv" "dfs_in_months, dfs_event" "gender" "age_in_years + dukes_stage + gender + location + adj_radio + adj_chem" "' 
# colorectal2 <- '"colorectal-cancer-mln-7.csv" "dfs_in_months, dfs_event" "gender" "age_in_years + dukes_stage + gender + location + adj_radio + adj_chem" "' 
work_edw <- '"turnover-edward.csv" "stag,event" "profession" "gender+age+industry+profession+traffic+coach+head_gender+greywage+way+extraversion+independ+selfcontrol+anxiety+novator" "'
work_edw2 <- '"turnover-edward-mln.csv" "stag,event" "profession" "gender+age+industry+profession+traffic+coach+head_gender+greywage+way+extraversion+independ+selfcontrol+anxiety+novator" "' 

watki <- c(6)

#parametry <- c(work1)
# parametry <- c(colorectal1,colorectal2)
parametry <- c(work2)
iteracja <- 0
for(slowo in parametry){ # petla z zestawem parametrow wywolujacych
  for(j in watki){ # testowac bedziemy od x do y watkow
    for(i in 1){ # liczba testow dla tej samej liczby watkow
      iteracja <- iteracja + 1
      liczba_watkow <- j
      polecenie <- paste0(odpalenie_java, slowo,liczba_watkow,'"')
      print(polecenie)
      javaOutput <- system(polecenie, intern = TRUE)
      print(paste0("Iteracja: ",iteracja,", liczba watkow: ",j,", godzina: ",format(Sys.time())))
    }
  }
}
