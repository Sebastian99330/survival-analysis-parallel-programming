odpalenie_java <- 'java -jar mgrmaven.jar '

# work1 <- 
  
  for(j in 2:6){
    for(i in 1:5){
      liczba_watkow <- j
      work <- paste0('"turnover.csv" "exp, event" "branch" "branch + pipeline" "',liczba_watkow,'"')
      prost <- paste("\"prostate_cancer.csv\" \"time, status\" \"treatment\" \"treatment + age + sh + size + index\" \"",liczba_watkow, "\"")
      polecenie <- paste0(odpalenie_java, work)
      cat(polecenie)
      javaOutput <- system(polecenie, intern = TRUE)
      print(paste0("Iteracja: ",i,", liczba watkow: ",j,", godzina: ",format(Sys.time(), "%S")))
    }
  }
