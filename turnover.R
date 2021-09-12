library(lubridate)
library(survival)
library(ggplot2)

q = read.csv("turnover.csv", header = TRUE, sep = ",", na.strings = c("",NA))
str(q)
summary(q)

# exp – length of employment in the company, 
#       length of employment is counted in months up to two decimal places
# event – event (1 – terminated, 0 – currently employed)
# branch – branch
# pipeline – source of recruitment


w = coxph(Surv(exp, event) ~ 1 , data = q)
w
str(w)
summary(survfit(w))
quantile(survfit(w), conf.int = FALSE)

plot(survfit(w),
     xlim = c(0, 12) , ylim = c(0.0, 1),
     col = c("red"),
     lwd = 3, xaxt="n", yaxt="n")

axis(side=1, at=seq(0, 12, 1), cex.axis=1.2)
axis(side=2, at=seq(0.0 , 1.0, 0.1), las=2, cex.axis=1.2)
abline(v=(seq(0, 12, 1)), col="black", lty="dotted")
abline(h=(seq(0.0, 1, 0.1)), col="black", lty="dotted")

summary(q$pipeline)
table(q$pipeline)
#cs – company career site
#ea – employment agency/ center
#js – job sites
#ref – referrals
#sm – social media

q$pipeline = as.factor(q$pipeline)
k = relevel(q$pipeline, ref = "js") 
table(k)

w1 = coxph(Surv(exp, event) ~ k  , data = q)
summary(w1)

w = coxph(Surv(exp, event) ~  pipeline , data = q)
summary(w)

plot(survfit(w, newdata=data.frame(pipeline = c("cs", "ea","js","ref", "sm"))) ,
     xlim = c(0, 12) , ylim = c(0.0, 1),conf.int = FALSE,
     col = c("red", "blue", "yellow", "green", "grey1"),
	lwd = 4, xaxt="n", yaxt="n")

axis(side=1, at=seq(0, 12, 1), cex.axis=1.2)
axis(side=2, at=seq(0.0 , 1.0, 0.1), las=2, cex.axis=1.2)
abline(v=(seq(0, 12, 1)), col="black", lty="dotted")
abline(h=(seq(0.0, 1, 0.1)), col="black", lty="dotted")

legend("bottomleft", legend=c("cs", "ea","js","ref", "sm"),
		col = c("red", "blue", "yellow", "green", "grey1"), cex = 1, lty = 1, pch = "",
		lwd=4)


library(survminer)
library(ggplot2)

fit=surv_fit(Surv(exp, event) ~  pipeline , data = q)
?surv_pvalue
surv_pvalue(fit)

ggsurvplot(fit,
           title = "Survival curve",
           linetype = "solid",
           ylab="percent working", xlab="months at company",
           conf.int = T, 
           pval = TRUE,
           break.time.by = 1,
           break.y.by = 0.1,
           xlim=c(0,12),
           surv.scale="percent",
           legend.title = "Group:",
           risk.table = TRUE)$plot +
  geom_hline(yintercept = seq(0,1,0.1), linetype="dotted") +
  geom_vline(xintercept = seq(0,12,1), linetype="dashed")

sel_idx= which(q$pipeline %in% c("cs", "ea", "sm"))
fit=surv_fit(Surv(exp, event) ~  pipeline , data = q[sel_idx, ])
surv_pvalue(fit)

#ggsave("tenure.pdf", width = 8, height = 5)

#-------- plot ROC ----------
table(q$branch, q$pipeline)

# risk score based on the linear predictor
w = coxph(Surv(exp, event) ~  branch +pipeline , data = q)
cox.pred <- predict(w, type = "lp")
q$lp=cox.pred

roc.obj <- survivalROC::survivalROC(Stime = q$exp,
                                    status = q$event,
                                    marker = q$lp,
                                    predict.time = 1,
                                    method = "NNE",
                                    span = 0.25 * nrow(q)^(-0.20))
plot(roc.obj$FP, roc.obj$TP,
     type="l", xlim=c(0,1), ylim=c(0,1),   
     xlab=paste( "FP", "\n", "AUC = ",round(roc.obj$AUC,3)), 
     ylab="TP"
)

library(survminer)
ggsurvplot(surv_fit(Surv(exp, event) ~ 1, data = q),
           risk.table = TRUE,
           break.time.by = 1)

quantile(q$exp, seq(0.05,1,0.05))

source("turnover_helpers.R")
library(dplyr)
library(purrr)
plot_ROC_curve(max_t=16)
plot_risk_set(max_t=16)


#lung - Survival in patients with advanced lung cancer from the North Central Cancer Treatment Group
# Performance scores rate how well the patient can perform usual daily activities.
# time:	Survival time in days
# status:	censoring status 1=censored, 2=dead
# ph.ecog:	ECOG performance score (0=good 5=dead)
# sex:	Male=1 Female=2

summary(lung)

lung$sex = ifelse(lung$sex==1, "Male", "Female")

l1=survfit(Surv(time, status) ~ ph.ecog, data=lung)
ggsurvplot(l1, conf.int = F)

rem_idx= which(lung$ph.ecog==3)
l2=survfit(Surv(time, status) ~ ph.ecog, data=lung[-rem_idx, ])

ggsurvplot(l2,
           title = "Survival in patients with advanced lung cancer",
           conf.int = T,
           pval = T,
           break.time.by = 90,
           break.y.by = 0.1,
           xlim=c(0,900),
           xlab="time in days",
           surv.scale="percent",
           legend.title = "ECOG score:")$plot +
  geom_hline(yintercept = seq(0,1,0.1), linetype="dotted") +
  geom_vline(xintercept = seq(0,900,90), linetype="dashed")

#ggsave("lungs.pdf", width = 8, height = 5)



