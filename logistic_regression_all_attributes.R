dat <- read.csv(file="newdata.csv", header=TRUE, sep=",")

#newdat = dat[-1, -5, -6, -10, -11, -12, -15, 20, -21, -22, -25, -26, -27, -30, -31, -32, -33]
newdat = dat[, c(2,3,4,7,8,9,13,14,17,18,19,23,24,27,28,29)]

head(dat)
#pairs(newdat)
newdat = na.omit(newdat)

X = scale(dat[,c(-1,-2,-33)], center=TRUE, scale=TRUE)
apply(X, 2, sd)

library("rjags")

mod1_string = " model {
    for (i in 1:length(y)) 
    {
        y[i] ~ dbern(p[i])
        logit(p[i]) = int + b[1]*radius_mean[i] + b[2]*texture_mean[i] + b[3]*perimeter_mean[i] + b[4]*area_mean[i] + b[5]*smoothness_mean[i] + b[6]*compactness_mean[i] + b[7]*concavity_mean[i] + b[8]*concave.points_mean[i] + b[9]*symmetry_mean[i] + b[10]*fractal_dimension_mean[i]
    }
    int ~ dnorm(0.0, 1.0/25.0)
    for (j in 1:10) 
    {
        b[j] ~ ddexp(0.0, sqrt(2.0)) # has variance 1.0
    }
} "

set.seed(92)
head(X)

data_jags = list(y=dat$diagnosis, radius_mean=X[,"radius_mean"], texture_mean=X[,"texture_mean"], perimeter_mean=X[,"perimeter_mean"], area_mean=X[,"area_mean"], smoothness_mean=X[,"smoothness_mean"], compactness_mean=X[,"compactness_mean"], concavity_mean=X[,"concavity_mean"], concave.points_mean=X[,"concave.points_mean"], symmetry_mean=X[,"symmetry_mean"], fractal_dimension_mean=X[,"fractal_dimension_mean"])

params = c("int", "b")

mod1 = jags.model(textConnection(mod1_string), data=data_jags, n.chains=3)
update(mod1, 5e4)

mod1_sim = coda.samples(model=mod1, variable.names=params, n.iter=5e3)
mod1_csim = as.mcmc(do.call(rbind, mod1_sim))

summary(mod1_sim)
summary(mod1_csim)

## convergence diagnostics
plot(mod1_sim, ask=TRUE)

gelman.diag(mod1_sim)
autocorr.diag(mod1_sim)
autocorr.plot(mod1_sim)
effectiveSize(mod1_sim)

## calculate DIC
dic1 = dic.samples(mod1, n.iter=1e3)
dic1
(pm_coef = colMeans(mod1_csim))
pm_coef
pm_Xb = pm_coef["int"] + X[, 1:10] %*% pm_coef[1:10]
phat = 1.0 / (1.0 + exp(-pm_Xb))
head(phat)
jpeg('rplot.jpg')
plot(phat, jitter(dat$diagnosis), xlab="Predicted Diagnosis Probability", ylab="Actual Diagnosis Probability")
dev.off()
(tab0.5 = table(phat > 0.5, data_jags$y))
sum(diag(tab0.5)) / sum(tab0.5)
