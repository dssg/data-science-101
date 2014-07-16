
##################################################
#####     PRE-PROCESS POSTSECONDARY DATA     #####
##################################################

#install packages if you have to...
#install.packages("psych")
#install.packages("lme4")
#install.packages("plyr")

#load libraries
library(psych)
library(lme4)
library(plyr)

#load data
raw_data <- read.csv("/Users/davidmiller/Dropbox/DSSG/tutorials/data.csv");
describe(raw_data)
count(raw_data$hs_name)
count(raw_data$hs_id)

#R.I.C.A., Gateway to College, MCPS Transitions, Rock Terrace, Stephen Knolls
#are for special needs children. Exclude them in our analyses
hs_special <- raw_data$hs_id %in% c(524, 525, 799, 916, 965)
data <- subset(raw_data,hs_special==0)
count(data$hs_name)
count(data$hs_id)       #25 high schools
table(data$hs_id,data$urm)

################################
#####     DESCRIPTIVES     #####
################################

#simple descriptives
describe(data)
describeBy(data, group=data$urm)

#calculate the school means
schl_means <- ddply(data,~hs_id,summarise,urm_mn=mean(urm),
                                          gpa_mn=mean(hs_gpa),
                                          enroll_mn=mean(enroll_4yr))
schl_means

#graph school-level means, histograms
hist(schl_means$urm_mn,breaks=20)
hist(schl_means$gpa_mn,breaks=20)
hist(schl_means$enroll_mn,breaks=20)

#graph school-level means, scatterplots
plot(schl_means$urm_mn,schl_means$gpa_mn)
abline(lm(schl_means$gpa_mn~schl_means$urm_mn))
plot(schl_means$urm_mn,schl_means$enroll_mn)
abline(lm(schl_means$enroll_mn~schl_means$urm_mn))
plot(schl_means$gpa_mn,schl_means$enroll_mn)
abline(lm(schl_means$enroll_mn~schl_means$gpa_mn))

#compute raw racial difference in GPA for each school
schl_means$urm_gpa_diff <- NULL
for (i in 1:nrow(schl_means)) {
  schl_data <- subset(data,hs_id==schl_means$hs_id[i])
  descriptives <- describeBy(schl_data,schl_data$urm)
  schl_means$urm_gpa_diff[i] <- descriptives[[2]]["hs_gpa","mean"]-descriptives[[1]]["hs_gpa","mean"]
}
hist(schl_means$urm_gpa_diff,breaks=20)
plot(schl_means$gpa_mn,schl_means$urm_gpa_diff)
abline(lm(schl_means$urm_gpa_diff~schl_means$gpa_mn))

#append urm school means to data frames
#will become useful later
row.names(schl_means) <- schl_means$hs_id
data$urm_mn <- schl_means[as.character(data$hs_id),"urm_mn"]

##################################################
#####     BUILDING A RANDOM SLOPES MODEL     #####
##################################################

#unconditional model
m0 <- lmer(hs_gpa ~ (1 | hs_id), data=data)
m0_sum <- summary(m0)
m0_sum                                 #get a summary of the unconditional model
m0_sum$varcor                          #look at specifially variance components
ICC <- 0.24217^2/(0.24217^2+0.66918^2) #calculate intraclass correlation
ICC

#add urm as a covariate 
m1 <- lmer(hs_gpa ~ urm + (1 | hs_id), data=data)
m1_sum <- summary(m1)
m1_sum
m1_sum$varcor
m0_sum$varcor   #how have the variance components changed? why?

#random slopes model
m2 <- lmer(hs_gpa ~ urm + (urm | hs_id), data=data)
m2_sum <- summary(m2)
m2_sum
m2_sum$varcor  #one additional variance component, one additional co-variance
m0_sum$varcor

#average racial difference of -.58 (SD = .12)

##################################################
#####     GROUP-MEAN CENTERING IN ACTION     #####
##################################################

#as we noticed in model 1, both the between-schools
#and within-schools variance changed when we added urm 
#as a covariate

#this makes sense because urm varies both between
#schools (i.e., some schools have higher URM percentages)
#and within schools

#could there be different urm-gpa relationships between-schools
#versus within-schools

#two ways of centering the data to analyze this issue
#A: re-center the covariate (group-mean centering)
#B: add the group means of the covariate

#first strategy = group-mean center urm
data$urm_dev <- data$urm - data$urm_mn
m3a <- lmer(hs_gpa ~ urm_dev + urm_mn + (urm_dev | hs_id), data=data)
m3a_sum <- summary(m3a)
m3a_sum
m3a_sum$coefficients  #look at fixed effects coefficients
#interpret the urm_mn coefficient = between-school regression
#              urm_dev coefficient = within-school regression

#second strategy = add group means to model
m3b <- lmer(hs_gpa ~ urm + urm_mn + (urm | hs_id), data=data)
m3b_sum <- summary(m3b)
m3b_sum
m3b_sum$coefficients  #look at fixed effects coefficients
m3a_sum$coefficients  #compare to group-mean centering
#coefficient for urm/urm_dev is the same
#coefficient for urm_mn is now the "compositional effect"
#compositional effect = between-schl slope - within-schl slope

#this compositional effect indicates that the between-schools
#regression has a stronger relationship than the within-schools

##################################################
#####     MULTILEVEL LOGISTIC REGRESSION     #####
##################################################

#multilevel logistic regression of whether students enrolled at a four-year
#college after high school

#model0 <- lmer(hs_gpa     ~ (1 | hs_id), data=data) #unconditional model for continous outcome
m0_logit <- glmer(enroll_4yr ~ (1 | hs_id), data=data, family=binomial, 
                nAGQ = 10, control = glmerControl(optimizer = "bobyqa")) #model estimation parameters
m0_logit_sum <- summary(m0_logit)
m0_logit_sum

#measures of intraclass correlation are not as straightforward 
#in multilevel logistic regression. but helpful to look at ranges
#(e.g., middle 80% of postsecondary enrollment rates)

1/(1+exp(-0.04509+0.6282*qnorm(.90)))
1/(1+exp(-0.04509-0.6282*qnorm(.90)))

#middle 80% of enrollment rates = [32%, 70%]

#another multilevel logistic regression
#add urm_dev and urm_mn as covariates, and urm_dev as a random slopes term 

#m3a      <- lmer(hs_gpa ~ urm_dev + urm_mn + (urm_dev | hs_id), data=data)
m3a_logit <- glmer(enroll_4yr ~ urm_dev + urm_mn + (urm_dev | hs_id), data=data, family=binomial, 
                  nAGQ = 10, control = glmerControl(optimizer = "bobyqa")) #model estimation parameters

#the above returns an error message
#ugh why won't R let me use more than one integration point with a random slopes model????
#Stata doesn't have a problem with this....
#So fine, I'll use one integration point. It gets reasonably close answers to Stata which 
#allows for more integration points

m3a_logit <- glmer(enroll_4yr ~ urm_dev + urm_mn + (urm_dev | hs_id), data=data, family=binomial, 
                   nAGQ = 1, control = glmerControl(optimizer = "bobyqa")) #model estimation parameters
m3a_logit_sum <- summary(m3a_logit)
m3a_logit_sum

#############################################
#####     EMPIRICAL BAYES ESIMATORS     #####
#############################################

#get empirical bayes estimates of models m0 and m1

ranef(m0) #unconditional empirical Bayes residuals (no covariates)
ranef(m1) #conditional empirical Bayes residuals (urm used as a covariate)
ranef(m2) #two columns now. one for residuals for the interpception and for the slope

#unconditional empirical Bayes predictions for school GPA means
gpa_bayes <- ranef(m0)[[1]]+summary(m0)$coefficients[1]  
cbind(gpa_bayes,schl_means$gpa_mn) #compare to raw averages
#mostly the same

#empirical Bayes predictions for racial differences 
urm_gpa_diff_bayes <- ranef(m2)[[1]][,2]+summary(m2)$coefficients[2]
urm_estimates <- cbind(urm_gpa_diff_bayes,schl_means$urm_gpa_diff) #compare to raw differences
colnames(urm_estimates) <- c("bayes","raw")
urm_estimates <- data.frame(urm_estimates)
urm_estimates

#compare residuals for racial differences
urm_residuals <- urm_estimates - summary(m2)$coefficients[2]
colnames(urm_residuals) <- c("bayes","raw")
urm_residuals <- data.frame(urm_residuals)
urm_residuals$shrinkage <- urm_residuals$bayes/urm_residuals$raw
urm_residuals$hs_id <- schl_means$hs_id
urm_residuals
#shrinkage ranges from 53% to 100% (not sure why greater than 1.01 in one case though...)

#why does shrinkage differ across schools (e.g., residual
#for school #427 is shrunk by half)?
table(data$hs_id,data$urm)
#answer = few URMs at school #427
#hence, estimate of racial difference is unreliable at that school 
#therefore the residual is shrunk to a greater extent to reflect this
