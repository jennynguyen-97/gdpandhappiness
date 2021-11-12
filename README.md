# Exploring a Timeless Problem Through a Novel Lens: Happiness v.s. GDP

### Motivation
Happiness levels are correlated with societal metrics such as crime rate, birth rate, economic growth, and education levels. Policy makers, consequently, often use happiness as a basis for making policy changes. I believe this topic is of particular importance in studying governmental policies and their related social implications, as the ultimate goal of a nation is to increase not only economic well-being, but also mental and physical welfare of its citizens.

**Understanding the causal relationship between changes in the happiness of a nation's citizens and changes in that nation's GDP per capita can allow governing bodies to make data-driven decisions regarding post-pandemic recovery policies towards both the economy and the well-being of their citizens.**

### Literature
There have been numerous studies over the years on happiness vs GDP, with students and experts alike analyzing data in search of an answer to the causal relationship between these two variables. I draw inspiration from some of these previous studies.

The genesis of happiness and GDP stems from [Richard Easterlin](https://halshs.archives-ouvertes.fr/halshs-00590436/) who in 1974 attempted to explain why despite the growth of the U.S. economy, the levels of national hapiness did not rise correspondingly. Easterlin analyzed the happiness levels of many Western countries over time and saw virtually no trends for changes in happiness levels despite incomes nearly doubling over the same period of time. 

<p align="center"><img width="667" alt="image" src="https://user-images.githubusercontent.com/93355594/140999697-00902f49-bfa1-4bfa-b8ef-5cdb3eeea63a.png">
 
Other literature results, on the other hand, show diminishing impact of GDP on Happiness. A popular theory conducted by [Proto and Rustichini](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0079358) stated that the positive relation in happiness vanishes beyond some value of increasing income. They partitioned all individual observations into quantiles of per capita GDP by the country of residence (with the first quantile of the distribution containing the individuals living in the poorest countries), and then estimated the relation between GDP and happiness by using the quantiles. In their 2013 report _A Reassessment of the Relationship between GDP and Life Satisfaction_, Proto and Rustichini provided analysis supporting their main findings:

* Most of the variation of life satisfaction due to GDP is explained by the effect in countries with per capita GDP below $10,000 (data are PPP-adjusted).
* People in countries with a GDP per capita of below $6,700 were 12% less likely to report the highest level of life satisfaction than those in countries with a GDP per capita of around $20,000.
* Countries with GDP per capita over $20,000 see a much less obvious link between GDP and happiness.
* Between this level and the very highest GDP per capita level ($54,000), the probability of reporting the highest level of life satisfaction changes by no more than 2%, and seems to be hump-shaped, with a bliss point at around $33,000.

<p align="center"><img width="582" alt="image" src="https://user-images.githubusercontent.com/93355594/141002991-d651f88c-5c86-496d-acbe-6c212e6fc54e.png">
 
In agreement with Proto and Rustichini, Robert E. Lane in his 2001 book _The Loss of Hapiness in Market Democracies_ also argued that once an individual rised above a poverty line or "subsistence level", the main source of increased well-being is not income but rather friends and a good family life.

Prior academic literature attempted to discover the relationship between happiness and GDP (income) through various methodologies:
1. Regression of happiness on income in cross-section survey data from one country (with or without standard demographic controls).
2. Panel data that controls for unobserved individual fixed effects, such as personality traits.
3. Very large samples and cross-time cross-country models that control for country fixed-effects.
 
My intial expectation is that there is a positive causal relationship of GDP per capita on hapiness. I will perform two different methodologies to examine this causal effect:
1. Perform a linear regression of happiness on log GDP per capita and a multiple linear regression controlling for three other factors: Freedom to make life choices, Generosity, and Perceptions of corruption.
2. Perform panel regressions on unbalanced panel data and balanced panel data for a period of 8 years from 2014-2021 to control for individual country effect and time effect.
 
### Data and Exploratory Data Analyses
I utilize the Gallup World Poll's [World Happiness Report](https://www.kaggle.com/ajaypalsinghlo/world-happiness-report-2021) covering years from 2005 to 2021. The data includes country name and year along with nine variables:
 
* Happiness score or subjective well-being (variable name **Life Ladder**) on a scale of 0 - 10.
* The statistics log of GDP per capita (variable name **Log GDP per capita**) in purchasing power parity (PPP). 
* **Social support**(or having someone to count on in times of trouble) is the national average of the binary responses (either 0 or 1).
* **Healthy life expectancies at birth** are based on the data extracted from the World Health Organization’s (WHO) Global Health Observatory data repository.
* **Freedom to make life choices** is the national average of responses to the GWP question “Are you satisfied or dissatisfied with your freedom to choose what you do with your life?”
* **Generosity** is the residual of regressing national average of response to the GWP question “Have you donated money to a charity in the past month?” on GDP per capita.
* **Perceptions of corruption**: The measure is the national average perceptions regarding corruption (between 0 and 1).
* **Positive affect** is defined as the average of three positive affect measures in GWP: happiness, laugh and enjoyment.
* **Negative affect** is defined as the average of three negative affect measures in GWP. They are worry, sadness and anger.
 
The happiness scores and rankings use data from the Gallup World Poll. The columns following the happiness score estimate the extent to which each of six factors – economic production (GDP), social support, life expectancy, freedom, absence of corruption, and generosity – contribute to making life evaluations higher in each country. The six factors have no impact on the total score reported for each country, but they do explain why some countries rank higher than others.

Correlation matrix for six factors is shown below:
 
<p align="center"><img width="813" alt="image" src="https://user-images.githubusercontent.com/93355594/141028297-68b48892-f448-416d-8403-d64d9ac1a440.png">
 
From the correlation matrix, there are several pairs of variables that are highly correlated, specifically _social_ and _loggdp_, _healthylife_ and _loggdp_, _healthylife_ and _social_. Consequently, I will carefully monitor these variables in my modeling to avoid multicollinearity. I will exclude _social_ and _healthylife_ variables out of the multiple linear regression model to reduce multicollinearity.
 
I perform intial descriptive analysis to see how the dataset is shaped and find out any interesting insights about the data before modeling. As I am interested in the relationship between _happiness_ and _loggdp_, I visualize the relationship between these two variables.
 
<p align="center"><img width="706" alt="image" src="https://user-images.githubusercontent.com/93355594/141028828-dded89ff-7038-4fec-aaaa-33c005cae77e.png">
 
Indeed, there is a positive trend between _loggdp_ and _happiness_, indicating that in general as _loggdp_ increases, _happiness_ will increase as well. However, I will have to consider omitted variable bias (OVB) in my modeling.
 
EDA also reveals that countries with the lowest level of happiness mostly located in the Sub-Saharan Africa region, whereas 9 out of 10 countries with the highest level of hapiness located in Western Europe.

<p align="center"><img width="671" alt="image" src="https://user-images.githubusercontent.com/93355594/141029104-59c4774c-72c8-46a9-a361-9aa4cd4977d1.png">
 
<p align="center"><img width="671" alt="image" src="https://user-images.githubusercontent.com/93355594/141029138-124c0c6d-81c8-40d0-9303-97326deeb95c.png">
 
### Methodology
#### A. Linear Regression (OLS)
<p align="center"> Model: Happiness = ɑ + βLogGDP + e
 
<p align="center"><img width="574" alt="image" src="https://user-images.githubusercontent.com/93355594/141030004-7641b446-bdd0-47a9-ac85-eb11f303cbdf.png">
 
I can see that for 1% change in GDP, happiness index increases on average by 0.76, ceteris paribus. The relationship between happiness and GDP is also statistically significant. There seems to be a positive relationship between happiness and GDP. However, my model may suffer from OVB because there are many factors that affect happiness such as employment, equality, freedom, etc. that have not been taken into consideration. The coefficient might actually refect some other "unobserved" factors that are not included in the analysis.
 
<p align="center"> Model: Happiness = ɑ + β<sub>1</sub>LogGDP + β<sub>2</sub>Freedom + β<sub>3</sub>Generosity + β<sub>4</sub>Corruption + e
 
<p align="center"><img width="572" alt="image" src="https://user-images.githubusercontent.com/93355594/141030636-75c571e7-7163-4386-8086-8a7d1cb55ea2.png">
 
The relationship between GDP and happiness is still positive and statistically significant. However, the magnitude of GDP on happiness is smaller: for 1% change in GDP, happiness index increases on average by 0.67, ceteris paribus.
 
#### B. Panel Regression
Panel regressions eliminate potential sources of country-specific measurement error and OVB. Panel regressions are of crucial importance for analysis based on survey data, because the questionnaires are generally different across countries, and there are pervasive effects due to culture and language on the statement made in the surveys.

I create a panel data of my current dataset with Country ID as the entity ID and Year as the time ID. I have 166 countries (entities), observed over 17 periods (2005 - 2021), for a total of 2,098 observations. Note that the panel is unbalanced in that not all countries are observed throughout 17 periods. Consider the panel nature of the dataset, perhaps happiness is different (on average) for each country (e.g., varying with perception and evaluation) or perhaps happiness is different through time (e.g., government policies). These variables are in effect omitted, and if relevant, then my causal estimate may be biased (OVB); consequently, I run a panel regression for happiness on Log GDP per capita while controlling for countries and time effects.
 
<p align="center">Model: index_plm <- plm(happiness~loggdp, data = index.p, model = "within", effect = "twoways")

<p align="center"><img width="740" alt="image" src="https://user-images.githubusercontent.com/93355594/141031366-8e1f6dd5-8d3d-4b40-87f4-d94d5706c159.png">
  
The coefficient on _loggdp_ is 1.229 and is statistically significant. This implies that the treatment effect remains positive, but the OLS specification seems to have been biased downward the effect of Log GDP on happiness by omitting entity and time effects.
 
I take a deeper look at the panel regression model by examining the effect of Log GDP per capita on Hapiness with balanced and unbalanced panel data for a period of eight years from 2014 - 2021.
 
<p align="center"> Balanced panel data (85 countries for a total of 680 observations)

<p align="center"><img width="630" alt="image" src="https://user-images.githubusercontent.com/93355594/141031770-33db5a51-fc24-403b-b887-5a4ff9de3b35.png">
 
<p align="center"> Unbalanced panel data (160 countries for a total of 1107 observations)
 
<p align="center"><img width="674" alt="image" src="https://user-images.githubusercontent.com/93355594/141031842-e8fdbf7d-59fa-46e9-99f2-4d4e0debfbc4.png">

The effect of _loggdp_ on happiness is positive and significant for both panels. However, the effect of _loggdp_ is higher in balanced panel data than it is in unbalanced panel data. The unbalanced data contains influential observations that pulls the betas toward zero.
 
Upon further investigation, I recognize that most missing data in the period 2014 - 2021 was in the year of 2020. Specifically, most under-developed or developing countries such as Afghanistan, Costa Rica, Haiti, Indonesia, and Vietnam are missing happiness records in 2020. The reason for that is because the surveys cannot be conducted in those countries due to the pandemic. Due to the severe impacts of Covid-19 in under-developed and developed countries, they did not have the means to carry out surveys from the Gallup World Poll. Consequently, most poor countries are removed in the 2020 World Happiness Record. This provided a distorted view of happiness and of factors leading to happiness. Additionally, removing countries that were not observed during the entire time period 2014 - 2021 leads to significant loss of data. The unbalanced panel contains 160 countries, but balanced panel contains only 85 countries. The total observations for unbalanced panel is over 1.5 times more than the observations for balanced panel. As a result, I suspect that there are some unobserved characteristics caused by the lack of random attrition in panel data.
 
A balanced data set is a set that contains all elements observed in all time frame, whereas unbalanced data is a set of data where certain years, the data category is not observed. Recall that in the balanced panel data, the error term is u = mu + v; however, in the unbalanced panel data set, there is an additional error term in “u”; therefore u = mu + v + e where “e” is the additional disturbance from the unbalanced random effect term. The unbalanced panel data begins to have a problem when the value of “e” exerts significant effect on the system, thus, inflating error term for the panel regression. ANOVA, MIVQUE, and MLE can be used to estimate this error component; however, this is beyond the scope of the study. 
 
To determine if the data is random, I conduct a t-test for randomization on balanced and unbalanced panel data. t-value is 5.512 and p-value= 4.163e-08 which is significant. Consequently, the data is not randomly missing.

<p align="center"><img width="581" alt="Screen Shot 2021-11-11 at 9 01 26 PM" src="https://user-images.githubusercontent.com/93355594/141396067-f530fe73-2b33-44fd-aa8f-8eec75b3ead3.png">

### Findings
From both linear regression and panel regression methodologies, I can conclude that there is a positive relationship between happiness and Log of GDP per capita. The relationship indicates that people in richer countries are on average happier than people in poorer countries. My finding is consistent with my initial hypothesis.
 
The conclusion of this project is different from the Easterlin Paradox which states that there is no correlation between GDP and happiness and other academic research which indicates that average life satisfaction actually peaks with countries that have an average annual income of about $33,000; after that, life satisfaction tends to drop as wealth rises.
 
The conclusion further strengthens the importance of GDP per capita (or a sense of financial stability) in influencing and determining a nation's happiness level. Based on a statement made by [Clark, Frijters, & Shields](https://halshs.archives-ouvertes.fr/halshs-00590436/document) that "Every social scientist should be attempting to understand the determinants of happiness, and it should be happiness which is the explicit aim of government intervention," my findings conclude that policy makers and economists should put a greater emphasis on fiscal policies that restructure and expand economies post-pandemic to enhance the nation's overall well-being and life satisfaction.
 
### Conclusion
Based on my modeling of linear regression (OLS) and panel regression, I conclude that there is a positive causal relationship of GDP per capita on Happiness. Specifically, people in developed countries are on average happier and more satisfied with their lives than people in developing and under-developed countries. The coefficient of Log GDP varies based upon methodologies and control variables; however, ther is always a positive and statistically significant relationship between Log GDP and Happiness.
 
I acknowledge that there are limitations to my analysis that I can improve upon or can be a source of improvement for future studies. Specifically:
 
* One critical consideration that is relevant in my analysis is the potential existence of a two-way relationship between a nation's GDP and the happiness level of that nation's citizens. It could very well be the case where higher GDP raises the happiness of citizens as disposable income increases, but it could also be the case where happier citizens are more productive and therefore contribute to a higher national GDP. Implementation of simultaneous equations could address this issue.
* The data source can be improved to eliminate selectivity problems and to create a randomly missing panel data. If data cannot be collected in 2020 due to the global pandemic, survey conductors can try to identify and remove those influential observations by using the Cook's distance.
* GDP has a positive impact on Happiness, but the level of impact may be different across stages of economies or geographical locations. Consequently, researchers can divide countries according to the level of economy and/or the geographic location to determine if the causal relationship is constant.
 











