odpalenie_java <- 'java -jar mgrmaven.jar '
liczba_watkow <- 3
work <- paste0('turnover.csv "exp, event" "branch" "branch + pipeline" "',liczba_watkow,'"')
prost <- paste("\"prostate_cancer.csv\" \"time, status\" \"treatment\" \"treatment + age + sh + size + index\" \"",liczba_watkow, "\"")
polecenie <- paste0(odpalenie_java, prost)
cat(polecenie)


javaOutput <- system(cat(polecenie), intern = TRUE)
