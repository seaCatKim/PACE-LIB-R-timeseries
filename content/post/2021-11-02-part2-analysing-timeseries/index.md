---
title: "Part 2: Analysing Time Series Data"
subtitle: "Pharmacy Australia Centre of Excellence x Library R workshop"
slug: "analysing"
author: "Catherine Kim"
date: "2022-01-27"
categories: ["R"]
tags: [""]
output:
  blogdown::html_page:
    df_print: tibble
    toc: true
    number_sections: TRUE
---




**Catherine Kim, PhD**

Technology Trainer, The University of Queensland Library

## Prerequisites 

This R workshop assumes basic knowledge of R including:

* Installing and loading packages
* How to read in data
    + read.csv
    + read_csv
    + and similar
* Creating objects in R

We are happy to have any and all questions though!

## What are we going to learn?

In this hands-on session...

## Load packages


```r
library(tidyverse)
## -- Attaching packages --------------------------------------- tidyverse 1.3.1 --
## v ggplot2 3.3.5     v purrr   0.3.4
## v tibble  3.1.6     v dplyr   1.0.7
## v tidyr   1.1.4     v stringr 1.4.0
## v readr   2.0.1     v forcats 0.5.1
## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
library(lubridate) # work with dates
## 
## Attaching package: 'lubridate'
## The following objects are masked from 'package:base':
## 
##     date, intersect, setdiff, union
library(readxl) # read excel files

library(zoo)
## 
## Attaching package: 'zoo'
## The following objects are masked from 'package:base':
## 
##     as.Date, as.Date.numeric
library(forecast)
## Registered S3 method overwritten by 'quantmod':
##   method            from
##   as.zoo.data.frame zoo
```

## About the data

...

## Read in the excel sheets

For this section, we will go the process of analysing time series for one site. 

Let's read in the first just the first site sheet from the excel file.


```r
s1335 <- read_excel("Data workshop.xlsx", sheet = 3) %>% 
   rename(Site = 1, Date = 3, mg_per_day = 7) %>% 
   mutate(Site = factor(Site), # change columns to factor
                   Year = as.factor(Year),
                   Month = as.factor(Month)) 
```

### Visualize the data for one site


```r
ggplot(s1335,
        aes(Date, mg_per_day, color = Site)) +
   geom_point()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-2-1.png" width="672" />

Count the number of samples per month.


```r
s1335 %>% 
   group_by(Year, Month) %>% 
   summarize(count = n()) %>% 
   arrange(-count) # arrange by count column in descending order
## `summarise()` has grouped output by 'Year'. You can override using the `.groups` argument.
## # A tibble: 68 x 3
##    Year  Month count
##    <fct> <fct> <int>
##  1 1992  10        7
##  2 1993  2         7
##  3 1993  4         7
##  4 1993  6         7
##  5 1993  8         7
##  6 1993  12        7
##  7 1994  2         7
##  8 1994  6         7
##  9 1994  8         7
## 10 1994  12        7
## # ... with 58 more rows
```

The maximum number of samples we have per month is 7. Probably not enough to do any meaningful analysis for a daily trend. Let's average samples by month. There also can be no data gaps for a time series (ts) data class.


```r
ave_s1335 <- s1335 %>% 
   group_by(Year, Month, Site) %>% 
   summarize(mg_per_day = mean(mg_per_day),
             SD = sd(mg_per_day))
## `summarise()` has grouped output by 'Year', 'Month'. You can override using the `.groups` argument.
```

Alternatively, can graphically summarize the distribution of dates using the `hist()` (`hist.Date()`) function. 


```r
hist(as.Date(s1335$Date), # change POSIXct to Date object
     breaks = "months", 
     freq = TRUE,
     xlab = "", # remove label so doesn't overlap with date labels,
     format = "%b %Y", # format the date label, mon year
     las = 2)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" width="672" />

Let's convert our data into a time series. Times series data must be sampled at equispaced points in time.

There are several different time series object that have different functionalalities such as working with irregularly spaced time series. See this [resource](https://faculty.washington.edu/ezivot/econ424/Working%20with%20Time%20Series%20Data%20in%20R.pdf).


```r
ts_1335 <- ts(ave_s1335$mg_per_day, frequency = 12,
                 start = c(1991, 11), end = c(2000, 9))

class(ts_1335) # check the object class
## [1] "ts"
ts_1335 # see the data
##             Jan        Feb        Mar        Apr        May        Jun
## 1991                                                                  
## 1992 0.27545325 0.25955623 0.17283015 0.24237330 0.21492034 0.21685501
## 1993 0.24936087 0.26921357 0.30978222 0.25693728 0.37014955 0.33177930
## 1994 0.34481141 0.34235679 0.36426187 0.46659618 0.44669432 0.37206745
## 1995 0.65457749 0.69834479 0.62221301 0.57168051 0.40724687 0.41195379
## 1996 0.24812201 0.25220778 0.32420921 0.40677658 0.49618890 0.34124538
## 1997 0.49926914 0.48207736 0.26538307 0.24687993 0.24478730 0.18937818
## 1998 0.21492034 0.21685501 0.21884272 0.29415920 0.18834451 0.09494631
## 1999 0.37014955 0.33177930 0.27831867 0.33660285 0.32467068 0.26865238
## 2000 0.44669432 0.37206745 0.39990788 0.47986144 0.33436319 0.38241556
##             Jul        Aug        Sep        Oct        Nov        Dec
## 1991                                             0.22975903 0.19544291
## 1992 0.21884272 0.29415920 0.18834451 0.09494631 0.16351067 0.20807004
## 1993 0.27831867 0.33660285 0.32467068 0.26865238 0.31360895 0.26773691
## 1994 0.39990788 0.47986144 0.33436319 0.38241556 0.38570498 0.46601276
## 1995 0.50863024 0.60921090 0.66656370 0.67302314 0.84627446 0.26116715
## 1996 0.36344698 0.32072347 0.29003143 0.26723167 0.35837799 0.42259062
## 1997 0.22975903 0.19544291 0.27545325 0.25955623 0.17283015 0.24237330
## 1998 0.16351067 0.20807004 0.24936087 0.26921357 0.30978222 0.25693728
## 1999 0.31360895 0.26773691 0.34481141 0.34235679 0.36426187 0.46659618
## 2000 0.38570498 0.46601276 0.65457749
```

## Create a irregularly spaced time series using the zoo (Zeileis ordered observations) package

The `zoo` class is a flexible time series data with an ordered time index. The data is stored in a matrix with vector date information attached. Can be regularly or irregularly spaced.


```r
library(zoo)
z_1335 <- zoo(s1335$mg_per_day, order.by = s1335$Date)

head(z_1335)
## 1991-11-28 1991-11-29 1991-11-30 1991-12-01 1991-12-02 1991-12-03 
##  0.2530688  0.2390078  0.1972005  0.1728767  0.2224569  0.1909951
```

## Investigating the time series data

Yt = St + Tt + Et

Or multiplicative

Yt = St * Tt * Et

First we need to convert our time series to a ts data type.

Next we can use the `decompose()` function to 


```r
decomp_1335 <- decompose(ts_1335)
plot(decomp_1335)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" width="672" />

Remove seasonality components using the forecast package.


```r
stl_1335 <- stl(ts_1335, s.window = "periodic") # deompose into seasonal, trend, and irregular components
head(stl_1335$time.series)
##              seasonal     trend    remainder
## Nov 1991  0.021512597 0.2253694 -0.017122969
## Dec 1991 -0.019995577 0.2243884 -0.008949903
## Jan 1992  0.035564624 0.2234074  0.016481258
## Feb 1992  0.024725533 0.2220857  0.012744950
## Mar 1992 -0.007203528 0.2207641 -0.040730440
## Apr 1992  0.028745667 0.2191495 -0.005521904
```

The seasonal and reminder/irregular components are small compared to the trend component.

Let's seasonally adjust the data and plot the raw data and adjusted data.


```r
sa_1335 <- seasadj(stl_1335) # seasonally adjusted data

par(mfrow = c(2,1))
plot(ts_1335) #, type = "1")
plot(sa_1335)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-10-1.png" width="672" />

These two plots are pretty much the same. There does not seem to be a large seasonality component in the data.

Plot the time series against the seasons in separate years.


```r
par(mfrow = c(1,1))
seasonplot(sa_1335, 12, col=rainbow(12), year.labels=TRUE, main="Seasonal plot: Site 1335")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-11-1.png" width="672" />

The lines do not really follow the same pattern throughout the year - again, not a big seasonality component.

## Autocorrelation

Correlograms, k lags on x-axis and the unit of lag is sampling interval (month here). Lag 0 correlation is always 1, helps to compare other lags


```r
acf(s1335$mg_per_day)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-12-1.png" width="672" />

```r
pacf(s1335$mg_per_day)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-12-2.png" width="672" />


```r
library(tseries)
adf.test(ts_1335) # p-value < 0.05 indicates the TS is stationary
## 
## 	Augmented Dickey-Fuller Test
## 
## data:  ts_1335
## Dickey-Fuller = -2.0988, Lag order = 4, p-value = 0.5357
## alternative hypothesis: stationary
kpss.test(ts_1335)
## Warning in kpss.test(ts_1335): p-value greater than printed p-value
## 
## 	KPSS Test for Level Stationarity
## 
## data:  ts_1335
## KPSS Level = 0.2472, Truncation lag parameter = 4, p-value = 0.1
```

Differencing


```r
nsdiffs(ts_1335)
## [1] 0
```

## AR model


```r
ar_1335 <- ar(ts_1335, method = "mle")

mean(ts_1335)
## [1] 0.3390491
ar_1335$order
## [1] 6
ar_1335$ar
## [1]  0.692318630  0.056966778 -0.007328706 -0.164283447  0.023423585
## [6]  0.284339996
acf(ar_1335$res[-(1:ar_1335$order)], lag = 50) 
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-15-1.png" width="672" />

## regression


```r
chem <- window(ts_1335, start = 1991)
## Warning in window.default(x, ...): 'start' value not changed
head(chem)
##            Jan       Feb       Mar       Apr May Jun Jul Aug Sep Oct       Nov
## 1991                                                                 0.2297590
## 1992 0.2754533 0.2595562 0.1728301 0.2423733                                  
##            Dec
## 1991 0.1954429
## 1992
chem.lm <- lm(chem ~ time(chem))
coef(chem.lm)
##   (Intercept)    time(chem) 
## -11.040746179   0.005700586
confint(chem.lm)
##                     2.5 %     97.5 %
## (Intercept) -31.137573143 9.05608078
## time(chem)   -0.004366695 0.01576787
acf(resid(chem.lm))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-16-1.png" width="672" />

## gls


```r
library(nlme)
## 
## Attaching package: 'nlme'
## The following object is masked from 'package:forecast':
## 
##     getResponse
## The following object is masked from 'package:dplyr':
## 
##     collapse
chem.gls <- gls(chem ~ time(chem), cor = corAR1(0.7))
coef(chem.gls)
## (Intercept)  time(chem) 
## -27.9996710   0.0141997
confint(chem.gls)
##                    2.5 %      97.5 %
## (Intercept) -87.94375365 31.94441156
## time(chem)   -0.01582862  0.04422801
acf(resid(chem.gls))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-17-1.png" width="672" />

## seasonal component


```r
Seas <- cycle(chem)
Time <- time(chem)
chem.lm <- lm(chem ~ 0 + Time + factor(Seas))
coef(chem.lm)
##           Time  factor(Seas)1  factor(Seas)2  factor(Seas)3  factor(Seas)4 
##    0.005756378  -11.122691112  -11.131937489  -11.162273796  -11.124295885 
##  factor(Seas)5  factor(Seas)6  factor(Seas)7  factor(Seas)8  factor(Seas)9 
##  -11.155275762  -11.202207940  -11.174639108  -11.139997655  -11.123771124 
## factor(Seas)10 factor(Seas)11 factor(Seas)12 
##  -11.171495571  -11.139425944  -11.179592661
acf(resid(chem.lm))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-18-1.png" width="672" />

## ARIMA


```r
par(mfrow = c(2,1))
plot(ts_1335)
plot(diff(ts_1335))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-19-1.png" width="672" />


```r
AIC (arima(ts_1335, order = c(1,1,0),
seas = list(order = c(1,0,0), 12)))
## [1] -200.1787
chem.arima <-  (arima(ts_1335, order = c(0,1,1),
seas = list(order = c(0,0,1), 12)))

acf(resid(chem.arima), lag = 50)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-20-1.png" width="672" />
