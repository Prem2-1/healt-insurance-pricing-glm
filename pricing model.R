df=read.csv("insurance.csv")
head(df,5)
str(df)
colSums(is.na(df))
df$sex=as.factor(df$sex)
df$smoker=as.factor(df$smoker)
df$region=as.factor(df$region)
summary(df$charges)
hist(df$charges,breaks=40,col="lightblue",main="distribution of claim charges",xlab="Charges")
t_test_smoker=t.test(charges~smoker,data=df)
print(t_test_smoker)
aggregate(charges~smoker,data=df,function(x) c(mean=mean(x),median=median(x)))
aggregate(charges~region,data=df,mean)
aggregate(bmi~region,data=df,mean)
table(df$region,df$smoker)
num_vars=df[,c("age","bmi","children","charges")]
round(cor(num_vars),2)
gamma_model=glm(charges~age+bmi+children+smoker+region,data=df,family=Gamma(link="log"))
summary(gamma_model)
plot(gamma_model,which=c(1,2))
round(exp(coef(gamma_model)), 3)
new_profile=data.frame(age=c(25,55),bmi=c(22.0,32.0),children=c(0,2),smoker=factor(c("no","yes")),region=factor(c("northeast","southeast")))
new_profile$predicted_claims=round(predict(gamma_model,newdata=new_profile,type="response"),2)
new_profile
gamma_interaction=glm(charges~age+children+region+bmi*smoker,family =Gamma(link="log"),data=df)
AIC(gamma_model,gamma_interaction)
round(exp(coef(gamma_interaction)), 3)
new_profile$interaction_claims=round( predict(gamma_interaction, newdata = new_profile, type = "response"), 2)
new_profile
res_deviance=residuals(gamma_interaction,type="deviance")
summary(res_deviance)
plot(
  predict(gamma_interaction, type = "response"),
  res_deviance,
  xlab = "Fitted Claim Costs ($)",
  ylab = "Deviance Residuals",
  main = "Deviance Residuals vs Fitted Values",
  col = rgb(0, 0, 1, 0.3),
  pch = 16
)
abline(h = 0, col = "red", lwd = 2, lty = 2)
fixed_expense <- 150
variable_ratio <- 0.15
profit_margin <- 0.05

denominator <- 1 - (variable_ratio + profit_margin)
new_profile$commercial_premium=round((new_profile$interaction_claims+fixed_expense)/denominator,2)
new_profile[, c("age", "bmi", "smoker", "interaction_claims", "commercial_premium")]

coefficients_table <- data.frame(
  Factor = names(coef(gamma_interaction)),
  Relativity = round(exp(coef(gamma_interaction)), 4)
)

write.csv(coefficients_table, "glm_rating_factors.csv", row.names = FALSE)