odpalenie_java <- 'java -jar mgrmaven.jar '

#work1 <- '"turnover.csv" "exp, event" "branch" "branch + pipeline" "'
# work2 <- '"turnover-mln-0-8.csv" "exp, event" "branch" "branch + pipeline" "'
# work3 <- '"turnover-mln-3.csv" "exp, event" "branch" "branch + pipeline" "'
#prost1 <- '"prostate_cancer.csv" "time, status" "treatment" "treatment + age + sh + size + index" "'
#prost2 <- '"prost_cancer_gen_mln.csv" "time, status" "treatment" "treatment + age + sh + size + index" "'
#prost3 <- '"prost_cancer_gen_3_mln.csv" "time, status" "treatment" "treatment + age + sh + size + index" "'
colorectal1 <- '"colorectal-cancer.csv" "dfs_in_months, dfs_event" "gender" "age_in_years + dukes_stage + gender + location + adj_radio + adj_chem" "' 
colorectal2 <- '"colorectal-cancer-mln-7.csv" "dfs_in_months, dfs_event" "gender" "age_in_years + dukes_stage + gender + location + adj_radio + adj_chem" "' 


#parametry <- c(work1,work2,work3,prost1,prost2,prost3)
# parametry <- c(colorectal1,colorectal2)
parametry <- c(colorectal2)
iteracja <- 0
for(slowo in parametry){ # petla z zestawem parametrow wywolujacych
  for(j in 4:6){ # testowac bedziemy od x do y watkow
    for(i in 1:1){ # liczba testow dla tej samej liczby watkow
      iteracja <- iteracja + 1
      liczba_watkow <- j
      polecenie <- paste0(odpalenie_java, slowo,liczba_watkow,'"')
      print(polecenie)
      javaOutput <- system(polecenie, intern = TRUE)
      print(paste0("Iteracja: ",iteracja,", liczba watkow: ",j,", godzina: ",format(Sys.time())))
    }
  }
}

wtf <- "java -jar mgrmaven.jar \"colorectal-cancer-mln-2.csv\" \"dfs_in_months, dfs_event\" \"gender\" \"age_in_years + dukes_stage + gender + location + adj_radio + adj_chem\" \"4\""
cat(wtf)
