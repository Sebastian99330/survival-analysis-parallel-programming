
library(survival)
# library(ggfortify) #funkcja autoplot

# Cox Proportional Hazards Model
#cox <- coxph(Surv(time, status) ~ treatment + age + sh + size + index, data = my_data) # przed zmiana
# tworze jedna instrukcje wsadzajac za parametr zmienne, po ktorych grupujemy (one zostaly podane jako argument odpalenia tego skryptu)
instrukcja <- sprintf("coxph(Surv(%s) ~ %s, data = my_data)", time_status, zmienne_grupowanie_cox)
# za pomoca eval(parse(...) uruchamiamy instrukcje, ktora jest zapisana w zmiennej
cox <- eval(parse(text=instrukcja))

podsumowanie_cox <- summary(survfit(cox)) 
# obiekt 'podsumowanie_cox' ma teraz duzo niepotrzebnych wartosci, dlatego wyciagniemy tylko to co potrzebujemy
# czyli kolumny tworzace tabelke ktora laczymy
tabelka_cox <- as.data.frame(podsumowanie_cox[c("time", "n.risk", "n.event", "surv","lower","upper")])
# zamieniamy . na _ zeby sie nie mylilo z separatorem liczb potem
colnames(tabelka_cox) <- c("time", "n_risk", "n_event", "survival","lower","upper")

lokalizacja_output_ramki <- paste0(".//",nazwa_folderu_output,"//",df_file)

saveRDS(tabelka_cox, lokalizacja_output_ramki)
