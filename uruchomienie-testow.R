odpalenie_java <- 'java -jar mgrmaven.jar '

work1 <- '"turnover.csv" "exp, event" "branch" "branch + pipeline" "'
work2 <- '"turnover-mln-0-8.csv" "exp, event" "branch" "branch + pipeline" "'
work3 <- '"turnover-turnover-mln-3.csv" "exp, event" "branch" "branch + pipeline" "'
prost1 <- '"prostate_cancer.csv" "time, status" "treatment" "treatment + age + sh + size + index" "'
prost2 <- '"prost_cancer_gen_mln.csv" "time, status" "treatment" "treatment + age + sh + size + index" "'
prost3 <- '"prost_cancer_gen_3_mln.csv" "time, status" "treatment" "treatment + age + sh + size + index" "'
parametry <- c(work1,work2,work3,prost1,prost2,prost3)

for(slowo in parametry){ # petla z zestawem parametrow wywolujacych
  for(j in 2:6){ # testowac bedziemy od 2 do 6 watkow
    for(i in 1:5){ # liczba testow dla tej samej liczby watkow
      liczba_watkow <- j
      polecenie <- paste0(odpalenie_java, slowo,liczba_watkow,'"')
      print(polecenie)
      javaOutput <- system(polecenie, intern = TRUE)
      print(paste0("Iteracja: ",i,", liczba watkow: ",j,", godzina: ",format(Sys.time())))
    }
  }
}