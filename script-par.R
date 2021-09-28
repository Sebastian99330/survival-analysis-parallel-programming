library(survival)


oblicz_cox <- function(df, time_status, zmienne_grupowanie_cox){
# Cox Proportional Hazards Model
#cox <- coxph(Surv(time, status) ~ treatment + age + sh + size + index, data = my_data) # przed zmiana
# tworze jedna instrukcje wsadzajac za parametr zmienne, po ktorych grupujemy (one zostaly podane jako argument odpalenia tego skryptu)
instrukcja <- sprintf("coxph(Surv(%s) ~ %s, data = df)", time_status, zmienne_grupowanie_cox)
cox <- eval(parse(text=instrukcja)) # uruchomienie instrukcji zapisanej w zmiennej "instrukcja"

podsumowanie_cox <- summary(survfit(cox)) 
# obiekt 'podsumowanie_cox' ma teraz duzo niepotrzebnych wartosci, dlatego wyciagniemy tylko to co potrzebujemy
# czyli kolumny tworzace tabelke ktora laczymy
tabelka_cox <- as.data.frame(podsumowanie_cox[c("time", "n.risk", "n.event", "surv","lower","upper")])
# zamieniamy . na _ zeby sie nie mylilo z separatorem liczb potem
colnames(tabelka_cox) <- c("time", "n_risk", "n_event", "survival","lower","upper")

return(tabelka_cox)
}
