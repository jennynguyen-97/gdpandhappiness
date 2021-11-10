## ----setup, include=FALSE------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ------------------------------------------------------------------------------------------------------------
rm(list = ls())
library(dplyr)
library(plyr)
library(ggplot2)
library(plm)


## ------------------------------------------------------------------------------------------------------------
# Import world-happiness-report.csv and change the necessary column names
library(readr)
index <- read_csv("~/Desktop/R Working Directory/world-happiness-report.csv")
colnames(index) <- c("name","year","happiness","loggdp","social","healthylife","freedom","generosity","corruption","positive","negative")
nrow(index)
index %>%
  summarise_all(funs(sum(is.na(.))))
# Positive affect and Negative affect columns have a high number of missing value: 171 (8.15%) and 165 (7.86%), respectively. Consequently, we decide to drop these two columns.
drops <- c("positive","negative")
index = index[,!(names(index) %in% drops)]


## ------------------------------------------------------------------------------------------------------------
# Create a correlation matrix between six factors that influence happiness
droplist <- c("name","year","happiness") #Dropping Country name, year, and dependent variable happiness
index_cor <- index[,!(names(index) %in% droplist)]
index_cor <- na.omit(index_cor)
corr <- cor(index_cor)
library(corrplot)
corrplot(corr, type="lower", method="square")
# Descriptive analysis was performed to see how the dataset is shaped and find out any interesting insights about the data before modeling. Because we are interested in the relationships between the happiness and loggdp, we visualized the relationship between these two variables.
# happiness~loggdp
x=aggregate(happiness~loggdp,data = index,FUN=mean)
ggplot(index,aes(x=loggdp,y=happiness))+geom_point(size=2, shape=18, col="lightblue")+ xlab("Log GDP per Capita") + ylab("Happiness")+geom_smooth(method = lm,col='red')
# Comparison of Life Ladder (Happiness level) of each country in 2021
happiness21 <- read.csv("~/Desktop/R Working Directory/world-happiness-report-2021.csv")
View(happiness21)
names(happiness21)[names(happiness21)=="Country.name"] <- "country"
names(happiness21)[names(happiness21)=="Ladder.score"] <- "happiness"
require(data.table)
order <- data.table(happiness21, key="happiness")
bottom10 <- head(order,10)
ggplot(bottom10, aes(x = reorder(country, happiness), y = happiness))+ geom_bar(stat="identity", fill="lightblue") +ylab("Happiness")+xlab("Country")+ggtitle("10 Countries with the lowest level of Happiness in 2021")
top10 <- tail(order,10)
ggplot(top10, aes(x = reorder(country, happiness), y = happiness))+geom_bar(stat="identity", fill="lightblue")+ylab("Happiness")+xlab("Country")+ggtitle("10 Countries with the highest level of Happiness in 2021")


## ------------------------------------------------------------------------------------------------------------
# LINEAR REGRESSION MODEL
reg <- lm(happiness~loggdp, data=index)
summary(reg)
# We can see that for 1% change in GDP, happiness index increases on average by 0.76, ceteris paribus. The relationship between happiness and GDP is also statistically significant.
# There seems to be a positive relationship between happiness and GDP. However, our model may suffer from OVB because there are many factors that affect happiness such as employment, equality, freedom, etc. that have not been taken into consideration. The correlation might actually reflect some other “unobserved” factor that is not included in the analysis.
# Multiple linear regression
reg1 <- lm(happiness~loggdp+freedom+generosity+corruption, data=index)
summary(reg1)
# We can see that the relationship between GDP and happiness is still positive and statistically significant. However, the magnitude of GDP on happiness is smaller: for 1% change in GDP, happiness index increases on average by 0.67, ceteris paribus.


## ------------------------------------------------------------------------------------------------------------
# PANEL REGRESSION (with unbalanced panel)
# Transform countries to unique IDs
index <- transform(index,id=as.numeric(factor(index$name)))
View(index)
# Set the panel dataframe
# "id" is the entity ID
# "year" is the time ID
index.p <- pdata.frame(index, index=c("id","year"))
# Find the dimensions of our panel dataframe
pdim(index.p)
# We have 166 countries (entities), observed over 17 periods, for a total of 2,098 observations. Note that we have an unbalanced panel in that not all countries are observed throughout 17 periods.
# Let's consider the panel nature of our dataset.  Perhaps happiness is different (on average) for each country (e.g. varying with perception and evaluation).  Or perhaps happiness is different through time (e.g. government policies).  These variables are in effect omitted, and if relevant, then our causal estimate may be biased (OVB). So let's run an LSDV regression and a panel regression for happiness on loggdp while controlling for countries and time effects
# Generate entity dummy variables
entity.f <- factor(index$id)
# Generate time dummy variables
time.f <- factor(index$year)
# Run and summarize the LSDV regression
index_lm <- lm(happiness~loggdp+entity.f+time.f,data=index)
summary(index_lm)
# Run the specification via the plm command by using the within model option
index_plm <- plm(happiness~loggdp,data=index.p,model="within",effect="twoways")
summary(index_plm)
# We can see that both regressions have the coefficient on loggdp of 1.229 and is statistically significant. This implies that the treatment effect remains positive, but the OLS specification seems to have been biased downward the effect of loggdp on happiness by omitting entity and time effects.
# The estimates are the same, implying that we can estimate the fixed effects model via LSDV or twoway fixed ala PLM. Again, the PLM is most preferred for it's compactness. 


## ------------------------------------------------------------------------------------------------------------
# PANEL REGRESSION (with balanced panel)
index_unbalanced <- index[!index$year %in% c(2005:2013),]
index_balanced <- index[!index$year %in% c(2005:2013),]
countyear <- ddply(index_balanced, .(name), nrow)
eightyear <- (countyear$name[which (countyear[,2] == 8)])
index_balanced <- index_balanced[index_balanced$name %in% eightyear,]
View(index_balanced)
# Set the panel dataframe
#"id" is the entity ID
#"year" is the time ID
index.p1 <- pdata.frame(index_balanced, index=c("id","year")) #Balanced panel data
index.p2 <- pdata.frame(index_unbalanced, index=c("id","year")) #Unbalanced panel data
# Find the dimensions of our panel dataframe
pdim(index.p1)
pdim(index.p2)
# For the balanced panel, we have 85 countries (entities), each observed for 8 periods, for a total of 680 observations.
# For the unbalanced panel, we have 160 countries (entities) over 8 periods for a total of 1107 observations.
# Run the specification via the plm command by using the within model option
index_plm1 <- plm(happiness~loggdp,data=index.p1,model="within",effect="twoways")
summary(index_plm1)
index_plm2 <- plm(happiness~loggdp,data=index.p2,model="within",effect="twoways")
summary(index_plm2)
# Conduct t-test for randomization
X_balance <- mean(index_balanced$happiness, na.rm=TRUE)
X_balance #5.785
X_unbalanced <- mean(index_unbalanced$happiness, na.rm=TRUE)
X_unbalanced #5.498
s_balance <- sd(index_balanced$happiness)
s_balance #1.044
s_unbalanced <- sd(index_unbalanced$happiness)
s_unbalanced #1.110
nrow(index_balanced) #680
nrow(index_unbalanced) #1107
se_balance <- s_balance^2/nrow(index_balanced)
se_unbalanced <- s_unbalanced^2/nrow(index_unbalanced)
tstat <- (X_balance-X_unbalanced)/(sqrt(se_balance+se_unbalanced))
tstat #t-test for randomization (long way)
t.test(index_balanced$happiness,index_unbalanced$happiness,alternative="two.sided") #t-test for randomization (short way)

