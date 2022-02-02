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
library(lubridate) # work with dates
library(readxl) # read excel files

library(zoo)
library(forecast)
library(tseries) # test for stationarity
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
   group_by(Year, Month, Site, Date) %>% 
   summarize(mg_per_day = mean(mg_per_day),
             SD = sd(mg_per_day))
## `summarise()` has grouped output by 'Year', 'Month', 'Site'. You can override using the `.groups` argument.
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
## 1992 0.19720048 0.17287674 0.22245691 0.19099507 0.29837595 0.25253055
## 1993 0.16021289 0.17687754 0.17556807 0.18637328 0.23178339 0.25296320
## 1994 0.26344432 0.22925615 0.20842929 0.37041379 0.24118309 0.27879146
## 1995 0.21130029 0.19121012 0.10307317 0.08241862 0.09931825 0.08333792
## 1996 0.14728220 0.16492892 0.19284190 0.17767449 0.17986075 0.20276905
## 1997 0.21863033 0.24410228 0.23386617 0.25159712 0.30447740 0.29352118
## 1998 0.30978222 0.25296185 0.21872907 0.23005210 0.24302850 0.27009450
## 1999 0.29154410 0.36545669 0.38763046 0.32599558 0.34510937 0.29771991
## 2000 0.30085380 0.25189903 0.25521031 0.27594033 0.40270498 0.28076867
##             Jul        Aug        Sep        Oct        Nov        Dec
## 1991                                             0.25306877 0.23900784
## 1992 0.25565163 0.28373564 0.23251146 0.21234847 0.31353391 0.16511895
## 1993 0.28689861 0.19435768 0.18664468 0.19178039 0.20202774 0.18509298
## 1994 0.28624845 0.21469297 0.18553862 0.17246271 0.17704678 0.16616008
## 1995 0.08211737 0.11941252 0.18315669 0.17061648 0.14140745 0.14434108
## 1996 0.20712967 0.22212884 0.24918299 0.21774453 0.25409175 0.23876105
## 1997 0.26507705 0.25044615 0.24562185 0.24100262 0.27477369 0.31405246
## 1998 0.32675768 0.32439414 0.25294530 0.37859670 0.68902957 0.28908035
## 1999 0.29811903 0.30952621 0.35835451 0.27831867 0.59599662 0.33971704
## 2000 0.27500903 0.28545684 0.31936740
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

## Decomposition

Decomposition separates out a times series `\(Y_{t}\)` into a seasonal `\(S_{t}\)`, trend `\(T_{t}\)`, and error/residual `\(E_{t}\)` components.

These elements can be *additive* when the seasonal component is relatively constant over time.

`$$Y_{t} = S_{t} + T_{t} + E_{t}$$`

Or *multiplicative* when seasonal effects tend to increase as the trend increases.

`$$Y_{t} = S_{t} * T_{t} * E_{t}$$`

The `decompose()` function uses a moving average (MA) approach to filter the data. The *window* or period over which you after is based on the frequency of the data. For example, monthly data can be averaged across a 12 month period.


```r
library(xts)
## 
## Attaching package: 'xts'
## The following objects are masked from 'package:dplyr':
## 
##     first, last
xts_1335 <- as.xts(x = ave_s1335$mg_per_day, order.by = ave_s1335$Date)

k2 <- rollmean(xts_1335, k = 2)
k4 <- rollmean(xts_1335, k = 4)
k8 <- rollmean(xts_1335, k = 8)
k16 <- rollmean(xts_1335, k = 16)
k32 <- rollmean(xts_1335, k = 32)

kALL <- merge.xts(xts_1335, k2, k4, k8, k16, k32)
head(kALL)
## Warning: timezone of object (UTC) is different than current timezone ().
##             xts_1335        k2        k4        k8 k16 k32
## 1991-11-28 0.2530688 0.2460383        NA        NA  NA  NA
## 1991-11-29 0.2390078 0.2181042 0.2155385        NA  NA  NA
## 1991-11-30 0.1972005 0.1850386 0.2078855        NA  NA  NA
## 1991-12-01 0.1728767 0.1976668 0.1958823 0.2283140  NA  NA
## 1991-12-02 0.2224569 0.2067260 0.2211762 0.2286369  NA  NA
## 1991-12-03 0.1909951 0.2446855 0.2410896 0.2342279  NA  NA
plot.xts(kALL, multi.panel = TRUE)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" width="672" />

Let's use the  use the `stats::decompose()` function for an additive model:


```r
decomp_1335 <- decompose(ts_1335, type = "additive") # additive is the default
plot(decomp_1335)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-9-1.png" width="672" />

In the top 'observed' plot there does not appear to be a clear case of seasonality increasing over time so the additive model should be fine. There is a huge peak in the trend in 1995 which decreases until around 1998 before increasing again.

## Remove seasonality components using the forecast package.


```r
stl_1335 <- stl(ts_1335, s.window = "periodic") # deompose into seasonal, trend, and irregular components
head(stl_1335$time.series)
##             seasonal     trend   remainder
## Nov 1991  0.07940866 0.2156235 -0.04196336
## Dec 1991 -0.01238431 0.2188676  0.03252456
## Jan 1992 -0.01100365 0.2221117 -0.01390757
## Feb 1992 -0.01707596 0.2246125 -0.03465983
## Mar 1992 -0.02326860 0.2271134  0.01861217
## Apr 1992 -0.01359065 0.2288255 -0.02423981
```

The seasonal and reminder/irregular components are small compared to the trend component.

Let's seasonally adjust the data and plot the raw data and adjusted data.


```r
sa_1335 <- seasadj(stl_1335) # seasonally adjusted data

par(mfrow = c(2,1))
plot(ts_1335) #, type = "1")
plot(sa_1335)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-11-1.png" width="672" />

These two plots are pretty much the same. There does not seem to be a large seasonality component in the data.

It can also be visualised using on the same plot to highlight the small effect of seasonality.


```r
s1335_deseason <- ts_1335 - decomp_1335$seasonal # manually adjust for seasonality

deseason <- ts.intersect(ts_1335, s1335_deseason) # bind the two time series

plot.ts(deseason, 
        plot.type = "single",
        col = c("red", "blue"),
        main = "Original (red) and Seasonally Adjusted Series (blue)")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-12-1.png" width="672" />

Plot the time series against the seasons in separate years.


```r
par(mfrow = c(1,1))
seasonplot(sa_1335, 12, col=rainbow(12), year.labels=TRUE, main="Seasonal plot: Site 1335")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-13-1.png" width="672" />

The lines do not really follow the same pattern throughout the year - again, not a big seasonality component.

## Stationarity

The **residual** part of the model should be **random** where the model explained most significant patterns or *signal* in the time series leaving out the *noise*.

[This article](http://r-statistics.co/Time-Series-Analysis-With-R.html) states that the following conditions must be met:

1. The mean value of time-series is constant over time, which implies, the trend component is nullified.
2. The variance does not increase over time.
3. Seasonality effect is minimal.

There are a few tests for stationarity with the `tseries` package: Augmented Dickery-Fuller and KPSS. See this [section](https://atsa-es.github.io/atsa-labs/sec-boxjenkins-aug-dickey-fuller.html). 


```r
adf.test(ts_1335) # p-value < 0.05 indicates the TS is stationary
## 
## 	Augmented Dickey-Fuller Test
## 
## data:  ts_1335
## Dickey-Fuller = -2.7241, Lag order = 4, p-value = 0.2763
## alternative hypothesis: stationary
kpss.test(ts_1335, null = "Trend") # null hypothesis is that the ts is level/trend stationary, so do not want to reject the null, p > 0.05
## Warning in kpss.test(ts_1335, null = "Trend"): p-value smaller than printed p-
## value
## 
## 	KPSS Test for Trend Stationarity
## 
## data:  ts_1335
## KPSS Trend = 0.28448, Truncation lag parameter = 4, p-value = 0.01
# 
```

The tests indicate that the time series is not stationary. How do you make a non-stationary time series stationary?

## Differencing

One common way is to *difference* a time series - subtract each point in the series from the previous point.

Using the `forecast` package, we can do *seasonal differencing* and *regular differencing*.


```r
nsdiffs(ts_1335, type = "trend") # seasonal differencing
## Warning: The chosen seasonal unit root test encountered an error when testing for the first difference.
## From seas.heuristic(): unused argument (type = "trend")
## 0 seasonal differences will be used. Consider using a different unit root test.
## [1] 0
ndiffs(ts_1335, type = "trend") # type 'level' deterministic component is default
## [1] 1
stationaryTS <- diff(ts_1335, differences= 1)

diffed <- ts.intersect(ts_1335, stationaryTS) # bind the two time series

plot.ts(diffed, 
        plot.type = "single",
        col = c("red", "blue"),
        main = "Original (red) and Differenced Series (blue)")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-15-1.png" width="672" />

Let's check the differenced time series with the same stationarity tests: 


```r
adf.test(stationaryTS) 
## Warning in adf.test(stationaryTS): p-value smaller than printed p-value
## 
## 	Augmented Dickey-Fuller Test
## 
## data:  stationaryTS
## Dickey-Fuller = -7.3514, Lag order = 4, p-value = 0.01
## alternative hypothesis: stationary
kpss.test(stationaryTS, null = "Trend")
## Warning in kpss.test(stationaryTS, null = "Trend"): p-value greater than printed
## p-value
## 
## 	KPSS Test for Trend Stationarity
## 
## data:  stationaryTS
## KPSS Trend = 0.029403, Truncation lag parameter = 4, p-value = 0.1
```

The both tests now indicate the differenced time series is now stationary.

## Autocorrelation

### Autocorrelation plots

Plot the **autocorrelation function** (ACF) correlogram for the time series. There are *k* lags on the x-axis and the unit of lag is sampling interval (month here). Lag 0 is always the theoretical maximum of 1 and helps to compare other lags. 

The cutest explanation of ACF by Dr Allison Horst:

![acf art by Allison Horst](acf_1.jpg)


```r
acf(s1335$mg_per_day)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-17-1.png" width="672" />

You can used the ACF to estimate the number of moving average (MA) coefficients in the model. Here, there are 3 to 4 significant autocorrelation. The lags crossing the dotted blue line are statistically significant.

The **partial autocorrelation function** can also be plotted. The partial correlation is the left over correlation at lag *k* between all data points that are *k* steps apart accounting for the correlation with the data between *k* steps.


```r
pacf(s1335$mg_per_day)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-18-1.png" width="672" />

Practically, this can help us identify the number of autoregression (AR) coefficients in an autoregression integrated moving average (ARIMA) model. The above plot shows *k* = 3 so the initial ARIMA model will have three AR coefficients (AR(3)). The model will still require fitting and checking.

### Autocorrelation test

There is also the `base::Box.test()` function that can be used to test for autocorrelation:


```r
Box.test(ts_1335)
## 
## 	Box-Pierce test
## 
## data:  ts_1335
## X-squared = 36.1, df = 1, p-value = 1.874e-09
```

The p-value is significant which means the data contains significant autocorrelations.

## Autoregressive model

Autoregressive (AR) models can simulate *stochastic* trends by regressing the time series on its past values. Order selection is done by Arkaike Information Criterion (AIC) and method chosen here is maximum likelihood estimation (mle).


```r
ar_1335 <- ar(ts_1335, method = "mle")

mean(ts_1335)
## [1] 0.2461971
ar_1335$order
## [1] 3
ar_1335$ar
## [1] 0.3950686 0.1103582 0.2421397
acf(ar_1335$res[-(1:ar_1335$order)], lag = 50) 
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-20-1.png" width="672" />

The correlogram of residuals has a few marinally significant lags (around 15 and between 30-40). The AR(4) model is a relatively good fit for the time series.

## Regression

*Deterministic* trends and seasonal variation can be modelled using regression.

Linear models are non-stationary for time series data, thus a non-stationary time series must be differenced.


```r
chem <- window(ts_1335, start = 1991)
## Warning in window.default(x, ...): 'start' value not changed
head(chem)
##            Jan       Feb       Mar       Apr May Jun Jul Aug Sep Oct       Nov
## 1991                                                                 0.2530688
## 1992 0.1972005 0.1728767 0.2224569 0.1909951                                  
##            Dec
## 1991 0.2390078
## 1992
chem.lm <- lm(chem ~ time(chem))
coef(chem.lm)
##  (Intercept)   time(chem) 
## -32.15810054   0.01623258
confint(chem.lm)
##                    2.5 %       97.5 %
## (Intercept) -43.55848720 -20.75771387
## time(chem)    0.01052169   0.02194348
acf(resid(chem.lm))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-21-1.png" width="672" />

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
##  (Intercept)   time(chem) 
## -31.28011126   0.01579311
confint(chem.gls)
##                     2.5 %       97.5 %
## (Intercept) -50.148423710 -12.41179881
## time(chem)    0.006341238   0.02524498
acf(resid(chem.gls))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-22-1.png" width="672" />

## seasonal component


```r
Seas <- cycle(chem)
Time <- time(chem)
chem.lm <- lm(chem ~ 0 + Time + factor(Seas))
coef(chem.lm)
##           Time  factor(Seas)1  factor(Seas)2  factor(Seas)3  factor(Seas)4 
##     0.01659631   -32.89287141   -32.89988569   -32.90702026   -32.89799718 
##  factor(Seas)5  factor(Seas)6  factor(Seas)7  factor(Seas)8  factor(Seas)9 
##   -32.87111561   -32.88731478   -32.88086313   -32.89100810   -32.89137196 
## factor(Seas)10 factor(Seas)11 factor(Seas)12 
##   -32.89752284   -32.80113584   -32.89359047
acf(resid(chem.lm))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-23-1.png" width="672" />

## ARIMA


```r
par(mfrow = c(2,1))
plot(ts_1335)
plot(diff(ts_1335))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-24-1.png" width="672" />


```r
AIC (arima(ts_1335, order = c(1,1,0),
seas = list(order = c(1,0,0), 12)))
## [1] -254.7406
chem.arima <-  (arima(ts_1335, order = c(0,1,1),
seas = list(order = c(0,0,1), 12)))

acf(resid(chem.arima), lag = 50)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-25-1.png" width="672" />

## Resources 

Resources used to compile this session included:
* [Ch 14 Time Series Analysis](https://rc2e.com/timeseriesanalysis) in R Cookbook, 2nd edition, by JD Long and Paul Teetor. Copyright 2019 JD Long and Paul Teetor, 978-1-492-04068-2
* [Time Series Analysis with R](https://nicolarighetti.github.io/Time-Series-Analysis-With-R/) by Nicola Righetti
