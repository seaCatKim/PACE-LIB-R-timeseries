---
title: "Day 1.1 Data manipulation"
subtitle: "Centre for Biodiversity and Conservation Science + Library R workshop"
author: "Catherine Kim"
date: "2021-11-03"
categories: ["R"]
tags: ["dplyr"]
output:
  blogdown::html_page:
    df_print: tibble
    toc: true
    number_sections: TRUE
---



**Catherine Kim, PhD**

Postdoctoral Associate, School of Biological Sciences  
Technology Trainer, The University of Queensland Library

- c dot kim @uq.edu.au
- [\@fishiinthec](https://twitter.com/fishiinthec)

# Today's schedule

* Session 1: Data manipulation with `dplyr`
* Session 2: Data visualization with `ggplot2`
* Session 3: Rmarkdown
* Session 4: Practice! #TidyTuesday or BYOData

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

In this hands-on session, you will use R, RStudio and the `dplyr` package to transform your data.

Specifically, you will learn how to **explore, filter, reorganise and process** a table of data with the following verbs:

* `select()`: pick variables
* `filter()`: pick observations
* `arrange()`: reorder observations
* `mutate()`: create new variables
* `summarise()`: collapse to a single summary
* `group_by()`: change the scope of function
* `joins`: combine dataframes based on a common variable
* `pivots`: transform dataframes into long and wide formats

## Load packages


```r
library(tidyverse)
## -- Attaching packages --------------------------------------- tidyverse 1.3.1 --
## v ggplot2 3.3.5     v purrr   0.3.4
## v tibble  3.1.4     v dplyr   1.0.7
## v tidyr   1.1.3     v stringr 1.4.0
## v readr   2.0.1     v forcats 0.5.1
## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
library(lubridate)
## 
## Attaching package: 'lubridate'
## The following objects are masked from 'package:base':
## 
##     date, intersect, setdiff, union
```

## Read in the data

### Lizard size measurement data

Our data sets are a curated subset from [Jornada Basin Long Term Ecological Research site](https://lter.jornada.nmsu.edu/) in New Mexico, part of the US Long Term Ecological Research (LTER) network: 

- Lightfoot, D. and W.G. Whitford. 2020. Lizard pitfall trap data from 11 NPP study locations at the Jornada Basin LTER site, 1989-2006 ver 37. Environmental Data Initiative. https://doi.org/10.6073/pasta/4a6e258fb49c31e222ecbbcfd128967f

From the data package: "This data package contains data on lizards sampled by pitfall traps located at 11 consumer plots at Jornada Basin LTER site from 1989-2006. The objective of this study is to observe how shifts in vegetation resulting from desertification processes in the Chihuahaun desert have changed the spatial and temporal availability of resources for consumers. Desertification changes in the Jornada Basin include changes from grass to shrub dominated communities and major soil changes. If grassland systems respond to rainfall without significant lags, but shrub systems do not, then consumer species should reflect these differences. In addition, shifts from grassland to shrubland results in greater structural heterogeneity of the habitats. We hypothesized that consumer populations, diversity, and densities of some consumers will be higher in grasslands than in shrublands and will be related to the NPP of the sites. Lizards were captured in pitfall traps at the 11 LTER II/III consumer plots (a subset of NPP plots) quarterly for 2 weeks per quarter. Variables measured include species, sex, recapture status, snout-vent length, total length, weight, and whether tail is broken or whole. This study is complete." 

There are 16 total variables in the lizards.csv data we'll read in. The ones we'll use in this workshop are:

* `date`: data collection date
* `scientific_name`: lizard scientific name
* `common_name`: lizard common name
* `site`: research site code
* `sex`: lizard sex (m = male; f = female; j = juvenile)
* `sv_length`: snout-vent length (millimeters)
* `total_length`: body length (millimeters)
* `toe_num`: toe mark number
* `weight`: body weight (grams)
* `tail`: tail condition (b = broken; w = whole)


```r
# to read the code in from github use the following:
# code <- read_csv("https://raw.githubusercontent.com/seaCatKim/CBCS-LIB_Rworkshop/main/content/post/2020-12-01-r-rmarkdown/data/jornada_lizards.csv")

lizards <- read_csv("data/jornada_lizards.csv", trim_ws = TRUE) %>% 
  mutate(date = as.Date(date, format = '%m/%d/%y')) %>% 
  mutate_if(is.character, as.factor)
glimpse(lizards)
## Rows: 4,091
## Columns: 14
## $ date         <date> 1989-06-16, 1989-06-16, 1989-06-16, 1989-06-16, 1989-06-~
## $ zone         <fct> C, C, C, C, C, G, G, G, G, G, G, G, G, G, M, M, M, T, T, ~
## $ site         <fct> CALI, CALI, SAND, SAND, SAND, BASN, BASN, BASN, BASN, BAS~
## $ plot         <fct> A, A, B, B, C, B, B, B, B, B, B, B, A, C, A, C, B, B, B, ~
## $ pit          <dbl> 4, 8, 2, 8, 2, 1, 2, 8, 9, 10, 11, 16, NA, 3, 15, 1, NA, ~
## $ spp          <fct> CNTI, UTST, CNTI, CNTI, CNTI, CNTI, UTST, CNTE, CNTE, CNT~
## $ sex          <fct> M, J, M, F, M, F, F, J, F, M, F, F, NA, F, F, F, NA, F, M~
## $ rcap         <fct> N, N, N, N, N, N, N, N, N, N, N, N, NA, N, N, N, NA, R, N~
## $ toe_num      <dbl> 240, 153, 241, 242, 243, 244, 154, 222, 22, 245, 250, 251~
## $ SV_length    <dbl> 92, 49, 91, 93, 94, 90, 42, 72, 86, 70, 82, 94, NA, 87, 1~
## $ total_length <dbl> 260, 86, 310, 305, 270, 304, 50, 265, 294, 240, 274, 308,~
## $ weight       <dbl> 26, 6, 24, 25, 24, 22, 3, 9, 16, 9, 16, 21, NA, 19, 26, 1~
## $ tail         <fct> B, B, W, W, B, W, B, W, W, W, W, W, NA, W, B, W, NA, W, B~
## $ pc           <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
class(lizards)
## [1] "spec_tbl_df" "tbl_df"      "tbl"         "data.frame"
```

### Annual mean estimates net primary production (NPP)

- Peters, D. and L. Huenneke. 2020. Annual mean estimates of aboveground net primary production (NPP) at 15 sites at Jornada Basin LTER, 1989-ongoing ver 104. Environmental Data Initiative. https://doi.org/10.6073/pasta/18dad6748af96c98b72cea3436bf7fe4 (Accessed 2021-11-02).

From the data package: "This package contains values of mean annual aboveground net primary production (NPP, in grams per square meter per year) at 15 NPP study sites on Jornada Experimental Range (JER) and Chihuahuan Desert Rangeland Research Center (CDRRC) lands. Sites were selected to represent the 5 major ecosystem types in the Chihuahuan Desert (upland grasslands, playa grasslands, mesquite-dominated shrublands, creosotebush-dominated shrublands, tarbush-dominated shrublands)."


```r
npp <- read_csv("data/jornada_npp.csv") %>% 
  mutate_if(is.character, as.factor)
glimpse(npp)
## Rows: 435
## Columns: 4
## $ year     <dbl> 1990, 1990, 1990, 1990, 1990, 1990, 1990, 1990, 1990, 1990, 1~
## $ zone     <fct> C, C, C, G, G, G, M, M, M, P, P, P, T, T, T, C, C, C, G, G, G~
## $ site     <fct> CALI, GRAV, SAND, BASN, IBPE, SUMM, NORT, RABB, WELL, COLL, S~
## $ npp_g_m2 <dbl> 28.6, 85.7, 103.3, 77.2, 34.1, 53.7, 57.9, 106.1, 79.8, 136.0~
```

# Basic dplyr verbs

The R package `dplyr` was developed by Hadley Wickham for data manipulation.

The book _[R for Data Science](https://r4ds.had.co.nz/)_ introduces the package as follows:

> You are going to learn the five key dplyr functions that allow you to solve the vast majority of your data manipulation challenges:
> 
> * Pick variables by their names with `select()`
> * Pick observations by their values with `filter()`
> * Reorder the rows with `arrange()`
> * Create new variables with functions of existing variables with `mutate()`
> * Collapse many values down to a single summary with `summarise()`
> 
> These can all be used in conjunction with `group_by()` which changes the scope of each function from operating on the entire dataset to operating on it group-by-group. These six functions provide the main **verbs for a language of data manipulation**.

### The pipe operator

We can make our code more readable and avoid creating useless intermediate objects by **piping** commands into each other. The pipe operator `%>%` **strings commands together**, using the left side's output as the first argument of the right side function.

For example, this command:


```r
round(1.23, digits = 1)
## [1] 1.2
```

... is equivalent to:


```r
1.23 %>% round(digits = 1)
## [1] 1.2
```

The pipe operator can be read as "then" and makes the code a lot **more readable** than when nesting functions into each other, and avoids the creation of several intermediate objects. It is also easier to trouble shoot as it makes it easy to execute the pipeline step by step.

> Note that this material uses the `magrittr` pipe. The `magrittr` package is the one that introduced the pipe operator to the R world, and `dplyr` automatically imports this useful operator when it is loaded. However, the pipe being such a widespread and popular concept in programming and data science, it ended up making it into Base R (the "native" pipe) in 2021 with the release of R 4.1, using a different operator: `|>`. You can switch your pipe shortcut to the native pipe in `Tools > Global options > Code > Use native pipe operator`.

## 1. Pick variables with `select()`

`select()` allows us to pick variables (i.e. columns) from the dataset. For example, to only keep the data about year, site, spp, sex, total_length, and weight:

> The columns are reordered in the order they are listed and columns can also be renamed.


```r
lizards %>% 
  select(date, zone, site, spp, sex, total_length, weight) -> lizards_small
lizards %>% 
  select(date, zone, site, spp, sex, length = total_length, weight)
## # A tibble: 4,091 x 7
##    date       zone  site  spp   sex   length weight
##    <date>     <fct> <fct> <fct> <fct>  <dbl>  <dbl>
##  1 1989-06-16 C     CALI  CNTI  M        260     26
##  2 1989-06-16 C     CALI  UTST  J         86      6
##  3 1989-06-16 C     SAND  CNTI  M        310     24
##  4 1989-06-16 C     SAND  CNTI  F        305     25
##  5 1989-06-16 C     SAND  CNTI  M        270     24
##  6 1989-06-16 G     BASN  CNTI  F        304     22
##  7 1989-06-16 G     BASN  UTST  F         50      3
##  8 1989-06-16 G     BASN  CNTE  J        265      9
##  9 1989-06-16 G     BASN  CNTE  F        294     16
## 10 1989-06-16 G     BASN  CNTI  M        240      9
## # ... with 4,081 more rows
```

There are several ways to select columns.

1. list the column names
2. list column numbers
3. use minus (-) notation to remove columns
4. a range using the ':'


```r
lizards %>% select(1,2,3)
## # A tibble: 4,091 x 3
##    date       zone  site 
##    <date>     <fct> <fct>
##  1 1989-06-16 C     CALI 
##  2 1989-06-16 C     CALI 
##  3 1989-06-16 C     SAND 
##  4 1989-06-16 C     SAND 
##  5 1989-06-16 C     SAND 
##  6 1989-06-16 G     BASN 
##  7 1989-06-16 G     BASN 
##  8 1989-06-16 G     BASN 
##  9 1989-06-16 G     BASN 
## 10 1989-06-16 G     BASN 
## # ... with 4,081 more rows
lizards %>% select(-date)
## # A tibble: 4,091 x 13
##    zone  site  plot    pit spp   sex   rcap  toe_num SV_length total_length
##    <fct> <fct> <fct> <dbl> <fct> <fct> <fct>   <dbl>     <dbl>        <dbl>
##  1 C     CALI  A         4 CNTI  M     N         240        92          260
##  2 C     CALI  A         8 UTST  J     N         153        49           86
##  3 C     SAND  B         2 CNTI  M     N         241        91          310
##  4 C     SAND  B         8 CNTI  F     N         242        93          305
##  5 C     SAND  C         2 CNTI  M     N         243        94          270
##  6 G     BASN  B         1 CNTI  F     N         244        90          304
##  7 G     BASN  B         2 UTST  F     N         154        42           50
##  8 G     BASN  B         8 CNTE  J     N         222        72          265
##  9 G     BASN  B         9 CNTE  F     N          22        86          294
## 10 G     BASN  B        10 CNTI  M     N         245        70          240
## # ... with 4,081 more rows, and 3 more variables: weight <dbl>, tail <fct>,
## #   pc <dbl>
lizards %>% select(5:9)
## # A tibble: 4,091 x 5
##      pit spp   sex   rcap  toe_num
##    <dbl> <fct> <fct> <fct>   <dbl>
##  1     4 CNTI  M     N         240
##  2     8 UTST  J     N         153
##  3     2 CNTI  M     N         241
##  4     8 CNTI  F     N         242
##  5     2 CNTI  M     N         243
##  6     1 CNTI  F     N         244
##  7     2 UTST  F     N         154
##  8     8 CNTE  J     N         222
##  9     9 CNTE  F     N          22
## 10    10 CNTI  M     N         245
## # ... with 4,081 more rows
lizards %>% select(-(date:zone))
## # A tibble: 4,091 x 12
##    site  plot    pit spp   sex   rcap  toe_num SV_length total_length weight
##    <fct> <fct> <dbl> <fct> <fct> <fct>   <dbl>     <dbl>        <dbl>  <dbl>
##  1 CALI  A         4 CNTI  M     N         240        92          260     26
##  2 CALI  A         8 UTST  J     N         153        49           86      6
##  3 SAND  B         2 CNTI  M     N         241        91          310     24
##  4 SAND  B         8 CNTI  F     N         242        93          305     25
##  5 SAND  C         2 CNTI  M     N         243        94          270     24
##  6 BASN  B         1 CNTI  F     N         244        90          304     22
##  7 BASN  B         2 UTST  F     N         154        42           50      3
##  8 BASN  B         8 CNTE  J     N         222        72          265      9
##  9 BASN  B         9 CNTE  F     N          22        86          294     16
## 10 BASN  B        10 CNTI  M     N         245        70          240      9
## # ... with 4,081 more rows, and 2 more variables: tail <fct>, pc <dbl>
```

### 2. Pick observations with `filter()`

The `filter()` function allows use to pick observations depending on one or several conditions. But to be able to define these conditions, we need to learn about logical operators.

**Logical operators** allow us to **compare things**. Here are some of the most important ones:

* `==`: equal
* `!=`: different or not equal
* `>`: greater than
* `<`: smaller than
* `>=`: greater or equal
* `<=`: smaller or equal

> Remember: `=` is used to pass on a value to an argument, whereas `==` is used to check for equality. Using `=` instead of `==` for a logical statment is one of the most common errors and R will give you a reminder in the console when this happens.

Filter lizard observations since 2000. There are also a lot of rows with NAs, can we filter those out too?


```r
range(lizards$date)
## [1] "1989-06-16" "2006-08-18"
lizards_small %>% 
  filter(date >= '2000-01-01', sex != 'NA') # remove rows with NAs
## # A tibble: 773 x 7
##    date       zone  site  spp   sex   total_length weight
##    <date>     <fct> <fct> <fct> <fct>        <dbl>  <dbl>
##  1 2000-03-13 C     SAND  UTST  F              109      2
##  2 2000-03-13 G     BASN  CNIN  F              126      1
##  3 2000-03-13 G     IBPE  CNUN  F              156      2
##  4 2000-03-13 G     IBPE  CNIN  F              132      1
##  5 2000-03-13 G     IBPE  CNIN  F              157      1
##  6 2000-03-13 G     IBPE  UTST  M              122      4
##  7 2000-03-13 G     IBPE  CNUN  F              137      1
##  8 2000-03-13 M     NORT  UTST  M              135      4
##  9 2000-03-13 M     RABB  UTST  M               93      4
## 10 2000-03-13 M     WELL  UTST  F               98      3
## # ... with 763 more rows
```

Filter using the or '|'.


```r
lizards_small %>% 
  filter(site == 'RABB' | site == 'GRAV')
## # A tibble: 797 x 7
##    date       zone  site  spp   sex   total_length weight
##    <date>     <fct> <fct> <fct> <fct>        <dbl>  <dbl>
##  1 1989-06-16 M     RABB  CNTI  F              250     26
##  2 1989-06-16 M     RABB  CNTI  F              265     16
##  3 1989-06-20 M     RABB  CNTI  F              290     21
##  4 1989-06-20 M     RABB  UTST  F               60      4
##  5 1989-06-20 M     RABB  CNTI  M              302     20
##  6 1989-06-20 M     RABB  CNTI  F              300     30
##  7 1989-06-20 M     RABB  CNTI  M              306     22
##  8 1989-06-23 M     RABB  CNTI  F              245     19
##  9 1989-06-23 M     RABB  CNTI  F              265     12
## 10 1989-06-27 M     RABB  CNTI  F              285     19
## # ... with 787 more rows
```

### 3. Reorder observations with `arrange()`

`arrange()` will reorder our rows according to a variable, by default in ascending order:

When/where was the biggest (total_length) lizard caught?


```r
range(lizards_small$total_length, na.rm = TRUE)
## [1]   8 414
lizards_small %>% arrange(total_length) 
## # A tibble: 4,091 x 7
##    date       zone  site  spp   sex   total_length weight
##    <date>     <fct> <fct> <fct> <fct>        <dbl>  <dbl>
##  1 1993-11-12 M     WELL  UTST  M                8      1
##  2 2005-11-18 M     RABB  UTST  F               11      3
##  3 1990-09-11 T     EAST  UTST  F               26      3
##  4 1990-09-11 T     EAST  UTST  M               27      2
##  5 1994-06-16 M     WELL  UTST  J               27     NA
##  6 1989-06-23 C     SAND  UTST  J               28      1
##  7 1989-11-08 M     WELL  UTST  F               29      1
##  8 1991-07-09 T     EAST  UTST  J               30      1
##  9 2002-08-22 G     SUMM  PHCO  J               30      1
## 10 2002-08-22 G     SUMM  PHCO  J               30      1
## # ... with 4,081 more rows
lizards_small %>% arrange(desc(total_length))
## # A tibble: 4,091 x 7
##    date       zone  site  spp   sex   total_length weight
##    <date>     <fct> <fct> <fct> <fct>        <dbl>  <dbl>
##  1 1996-03-15 C     SAND  UTST  M              414      6
##  2 1990-05-21 T     WEST  CNTI  F              340     25
##  3 2002-06-11 T     WEST  CNTI  M              340     23
##  4 2002-06-18 T     WEST  CNTI  M              340     23
##  5 1990-06-01 C     CALI  CNTI  M              333     26
##  6 1990-06-19 C     SAND  CNTI  F              330     24
##  7 1997-06-09 C     SAND  CNTI  F              327     28
##  8 1990-06-01 C     SAND  CNTI  M              325     28
##  9 1990-06-29 T     WEST  CNTI  M              325     29
## 10 1991-06-25 C     SAND  CNTI  M              321     11
## # ... with 4,081 more rows
lizards_small %>% arrange(-total_length)
## # A tibble: 4,091 x 7
##    date       zone  site  spp   sex   total_length weight
##    <date>     <fct> <fct> <fct> <fct>        <dbl>  <dbl>
##  1 1996-03-15 C     SAND  UTST  M              414      6
##  2 1990-05-21 T     WEST  CNTI  F              340     25
##  3 2002-06-11 T     WEST  CNTI  M              340     23
##  4 2002-06-18 T     WEST  CNTI  M              340     23
##  5 1990-06-01 C     CALI  CNTI  M              333     26
##  6 1990-06-19 C     SAND  CNTI  F              330     24
##  7 1997-06-09 C     SAND  CNTI  F              327     28
##  8 1990-06-01 C     SAND  CNTI  M              325     28
##  9 1990-06-29 T     WEST  CNTI  M              325     29
## 10 1991-06-25 C     SAND  CNTI  M              321     11
## # ... with 4,081 more rows
```

### 4. Create new variables with `mutate()`

We did some mutating when reading in our data at the start to convert columns to different data types.

`mutate()` is very versatile and useful! Few other uses include combining with `ifelse()` conditionals and transforming columns. 


```r
lizards_small %>% mutate(weight_kg = weight / 1000)
## # A tibble: 4,091 x 8
##    date       zone  site  spp   sex   total_length weight weight_kg
##    <date>     <fct> <fct> <fct> <fct>        <dbl>  <dbl>     <dbl>
##  1 1989-06-16 C     CALI  CNTI  M              260     26     0.026
##  2 1989-06-16 C     CALI  UTST  J               86      6     0.006
##  3 1989-06-16 C     SAND  CNTI  M              310     24     0.024
##  4 1989-06-16 C     SAND  CNTI  F              305     25     0.025
##  5 1989-06-16 C     SAND  CNTI  M              270     24     0.024
##  6 1989-06-16 G     BASN  CNTI  F              304     22     0.022
##  7 1989-06-16 G     BASN  UTST  F               50      3     0.003
##  8 1989-06-16 G     BASN  CNTE  J              265      9     0.009
##  9 1989-06-16 G     BASN  CNTE  F              294     16     0.016
## 10 1989-06-16 G     BASN  CNTI  M              240      9     0.009
## # ... with 4,081 more rows
```

###  5. Collapse to a single value with `summarise()`

`summarise()` collapses many values down to a single summary. For example, to find the mean weight for the whole dataset:


```r
lizards_small %>%
  summarise(meanW = mean(weight, na.rm = TRUE))
## # A tibble: 1 x 1
##   meanW
##   <dbl>
## 1  4.34
```

However, a single-value summary is not particularly interesting. `summarise()` becomes more powerful when used with `group_by()`.

### 6. Change the scope with `group_by()`

`group_by()` changes the scope of the following function(s) from operating on the entire dataset to operating on it group-by-group.

See the effect of the grouping step (in the console):


```r
lizards_small %>%
  group_by(spp) 
## # A tibble: 4,091 x 7
##    date       zone  site  spp   sex   total_length weight
##    <date>     <fct> <fct> <fct> <fct>        <dbl>  <dbl>
##  1 1989-06-16 C     CALI  CNTI  M              260     26
##  2 1989-06-16 C     CALI  UTST  J               86      6
##  3 1989-06-16 C     SAND  CNTI  M              310     24
##  4 1989-06-16 C     SAND  CNTI  F              305     25
##  5 1989-06-16 C     SAND  CNTI  M              270     24
##  6 1989-06-16 G     BASN  CNTI  F              304     22
##  7 1989-06-16 G     BASN  UTST  F               50      3
##  8 1989-06-16 G     BASN  CNTE  J              265      9
##  9 1989-06-16 G     BASN  CNTE  F              294     16
## 10 1989-06-16 G     BASN  CNTI  M              240      9
## # ... with 4,081 more rows
```

Summarize by site, and species for mean weight. Calculate standard deviation and standard error.


```r
lizards_small %>%
  group_by(site, spp) %>% 
  summarize(meanW = mean(weight, na.rm = TRUE),
            SD = sd(weight),
            SE = SD/sqrt(n()))
## `summarise()` has grouped output by 'site'. You can override using the `.groups` argument.
## # A tibble: 121 x 5
##    site  spp    meanW    SD    SE
##    <fct> <fct>  <dbl> <dbl> <dbl>
##  1 BASN  BUDE  NaN       NA    NA
##  2 BASN  CNEX    3       NA    NA
##  3 BASN  CNIN    2.99    NA    NA
##  4 BASN  CNNE    2       NA    NA
##  5 BASN  CNTE    9.29    NA    NA
##  6 BASN  CNTI   12       NA    NA
##  7 BASN  CNUN    3.1     NA    NA
##  8 BASN  HOMA    4.73    NA    NA
##  9 BASN  PHCO   11.5     NA    NA
## 10 BASN  PHMO    2       NA    NA
## # ... with 111 more rows
```

# Relational Data aka joins

Chapter 13 from _[R for Data Science](https://r4ds.had.co.nz/)_ covers relational data:

> It’s rare that a data analysis involves only a single table of data. Typically you have many tables of data, and you must combine them to answer the questions that you’re interested in. Collectively, multiple tables of data are called relational data because it is the relations, not just the individual datasets, that are important.

Joins stem from database concepts and there is a lot you can read about them. Here we will focus on the main inner and outer joins.

![diagram of different types of joins](joins.png)

Let's say we were interested in seeing if net primary productivity (NPP) had any influence over the length/weights of our lizards over time. The very first step would be to *join* our lizard data and NPP data into one dataframe so we could do some analysis.

A *key* is the variable used to connect each pair of variables.

Let's have a look at the variables of our two dataframes we are interested in joining:


```r
glimpse(lizards_small)
## Rows: 4,091
## Columns: 7
## $ date         <date> 1989-06-16, 1989-06-16, 1989-06-16, 1989-06-16, 1989-06-~
## $ zone         <fct> C, C, C, C, C, G, G, G, G, G, G, G, G, G, M, M, M, T, T, ~
## $ site         <fct> CALI, CALI, SAND, SAND, SAND, BASN, BASN, BASN, BASN, BAS~
## $ spp          <fct> CNTI, UTST, CNTI, CNTI, CNTI, CNTI, UTST, CNTE, CNTE, CNT~
## $ sex          <fct> M, J, M, F, M, F, F, J, F, M, F, F, NA, F, F, F, NA, F, M~
## $ total_length <dbl> 260, 86, 310, 305, 270, 304, 50, 265, 294, 240, 274, 308,~
## $ weight       <dbl> 26, 6, 24, 25, 24, 22, 3, 9, 16, 9, 16, 21, NA, 19, 26, 1~
glimpse(npp)
## Rows: 435
## Columns: 4
## $ year     <dbl> 1990, 1990, 1990, 1990, 1990, 1990, 1990, 1990, 1990, 1990, 1~
## $ zone     <fct> C, C, C, G, G, G, M, M, M, P, P, P, T, T, T, C, C, C, G, G, G~
## $ site     <fct> CALI, GRAV, SAND, BASN, IBPE, SUMM, NORT, RABB, WELL, COLL, S~
## $ npp_g_m2 <dbl> 28.6, 85.7, 103.3, 77.2, 34.1, 53.7, 57.9, 106.1, 79.8, 136.0~
```

### Inner join

The simplest join which matches pairs of observation whenever keys are equal. 

zone and site apear in each dataframe - but wouldn't date or year be useful to include too?


```r
lizards_small <-  lizards_small %>% mutate(year = year(date))
```

Now let's join using year, zone, and site:


```r
inner_join(lizards_small, npp, by = c('year', 'zone', 'site'))
## # A tibble: 3,670 x 9
##    date       zone  site  spp   sex   total_length weight  year npp_g_m2
##    <date>     <fct> <fct> <fct> <fct>        <dbl>  <dbl> <dbl>    <dbl>
##  1 1990-01-04 C     CALI  UKLI  <NA>            NA     NA  1990     28.6
##  2 1990-01-04 C     GRAV  UKLI  <NA>            NA     NA  1990     85.7
##  3 1990-01-04 C     SAND  UKLI  <NA>            NA     NA  1990    103. 
##  4 1990-01-04 C     SAND  UKLI  <NA>            NA     NA  1990    103. 
##  5 1990-01-04 G     BASN  UKLI  <NA>            NA     NA  1990     77.2
##  6 1990-01-04 G     IBPE  UKLI  <NA>            NA     NA  1990     34.1
##  7 1990-01-04 G     IBPE  UKLI  <NA>            NA     NA  1990     34.1
##  8 1990-01-04 M     RABB  UKLI  <NA>            NA     NA  1990    106. 
##  9 1990-01-04 M     RABB  UTST  F              114      2  1990    106. 
## 10 1990-01-04 M     WELL  UKLI  <NA>            NA     NA  1990     79.8
## # ... with 3,660 more rows
```

### Outer joins

A `left_join()` keeps the observations in the left (x argument) dataframe.


```r
left_join(lizards_small, npp, by = c('year', 'zone', 'site'))
## # A tibble: 4,091 x 9
##    date       zone  site  spp   sex   total_length weight  year npp_g_m2
##    <date>     <fct> <fct> <fct> <fct>        <dbl>  <dbl> <dbl>    <dbl>
##  1 1989-06-16 C     CALI  CNTI  M              260     26  1989       NA
##  2 1989-06-16 C     CALI  UTST  J               86      6  1989       NA
##  3 1989-06-16 C     SAND  CNTI  M              310     24  1989       NA
##  4 1989-06-16 C     SAND  CNTI  F              305     25  1989       NA
##  5 1989-06-16 C     SAND  CNTI  M              270     24  1989       NA
##  6 1989-06-16 G     BASN  CNTI  F              304     22  1989       NA
##  7 1989-06-16 G     BASN  UTST  F               50      3  1989       NA
##  8 1989-06-16 G     BASN  CNTE  J              265      9  1989       NA
##  9 1989-06-16 G     BASN  CNTE  F              294     16  1989       NA
## 10 1989-06-16 G     BASN  CNTI  M              240      9  1989       NA
## # ... with 4,081 more rows
```

A `right_join()` keeps the observation in the right (y argument) dataframe.


```r
right_join(lizards_small, npp, by = c('year', 'zone', 'site'))
## # A tibble: 3,928 x 9
##    date       zone  site  spp   sex   total_length weight  year npp_g_m2
##    <date>     <fct> <fct> <fct> <fct>        <dbl>  <dbl> <dbl>    <dbl>
##  1 1990-01-04 C     CALI  UKLI  <NA>            NA     NA  1990     28.6
##  2 1990-01-04 C     GRAV  UKLI  <NA>            NA     NA  1990     85.7
##  3 1990-01-04 C     SAND  UKLI  <NA>            NA     NA  1990    103. 
##  4 1990-01-04 C     SAND  UKLI  <NA>            NA     NA  1990    103. 
##  5 1990-01-04 G     BASN  UKLI  <NA>            NA     NA  1990     77.2
##  6 1990-01-04 G     IBPE  UKLI  <NA>            NA     NA  1990     34.1
##  7 1990-01-04 G     IBPE  UKLI  <NA>            NA     NA  1990     34.1
##  8 1990-01-04 M     RABB  UKLI  <NA>            NA     NA  1990    106. 
##  9 1990-01-04 M     RABB  UTST  F              114      2  1990    106. 
## 10 1990-01-04 M     WELL  UKLI  <NA>            NA     NA  1990     79.8
## # ... with 3,918 more rows
```

And a `full_join()` keeps all observation from both dataframes.


```r
full_join(lizards_small, npp, by = c('year', 'zone', 'site'))
## # A tibble: 4,349 x 9
##    date       zone  site  spp   sex   total_length weight  year npp_g_m2
##    <date>     <fct> <fct> <fct> <fct>        <dbl>  <dbl> <dbl>    <dbl>
##  1 1989-06-16 C     CALI  CNTI  M              260     26  1989       NA
##  2 1989-06-16 C     CALI  UTST  J               86      6  1989       NA
##  3 1989-06-16 C     SAND  CNTI  M              310     24  1989       NA
##  4 1989-06-16 C     SAND  CNTI  F              305     25  1989       NA
##  5 1989-06-16 C     SAND  CNTI  M              270     24  1989       NA
##  6 1989-06-16 G     BASN  CNTI  F              304     22  1989       NA
##  7 1989-06-16 G     BASN  UTST  F               50      3  1989       NA
##  8 1989-06-16 G     BASN  CNTE  J              265      9  1989       NA
##  9 1989-06-16 G     BASN  CNTE  F              294     16  1989       NA
## 10 1989-06-16 G     BASN  CNTI  M              240      9  1989       NA
## # ... with 4,339 more rows
```

# Tidy data

Tidy data makes it easy to transform and analyse data in R (and many other tools). Tidy data has observations in rows, and variables in columns. The whole Tidyverse is designed to work with tidy data.

Often, a dataset is organised in a way that makes it easy for humans to read and populate. This is usually called "wide format". Tidy data is _usually_ in "long" format.

The ultimate rules of tidy data are:

* Each row is an observation
* Each column is a variable
* Each cell contains one single value

Is the lizards dataset tidy?

> To learn more about Tidy Data, you can read [Hadley Wickham's 2014 article on the topic](https://www.jstatsoft.org/index.php/jss/article/view/v059i10/v59i10.pdf).

### Make the tidy data for the next session

Need to add the scientific and common name to our lizard dataset from the codelist file.


```r
code <- read_table("data/lizardcodelist.txt", skip = 1) %>% # remove the first descriptive line in text file
  slice(-1) # remove 1st line of -------
## Warning: Duplicated column names deduplicated: 'NAME' => 'NAME_1' [5]
## Warning: 17 parsing failures.
## row col  expected    actual                      file
##   1  -- 5 columns 3 columns 'data/lizardcodelist.txt'
##   2  -- 5 columns 6 columns 'data/lizardcodelist.txt'
##   3  -- 5 columns 6 columns 'data/lizardcodelist.txt'
##   4  -- 5 columns 6 columns 'data/lizardcodelist.txt'
##   5  -- 5 columns 6 columns 'data/lizardcodelist.txt'
## ... ... ......... ......... .........................
## See problems(...) for more details.
# to read the code in from github use the following:
# code <- read_csv("https://raw.githubusercontent.com/seaCatKim/CBCS-LIB_Rworkshop/main/content/post/2020-12-01-r-rmarkdown/data/lizardcodelist.txt") %>% slice(-1)

glimpse(code)
## Rows: 19
## Columns: 5
## $ CODE       <chr> "CNEX", "CNIN", "CNNE", "CNTE", "CNTI", "CNUN", "COTE", "CR~
## $ SCIENTIFIC <chr> "Cnemidophorus", "Cnemidophorus", "Cnemidophorus", "Cnemido~
## $ NAME       <chr> "exanguis", "inornatus", "neomexicanus", "tessalatus", "tig~
## $ COMMON     <chr> "Chihuahuan", "Little", "New", "Colorado", "Western", "Dese~
## $ NAME_1     <chr> "Spotted", "Striped", "Mexico", "Checkered", "Whiptail", "G~
```

First, we can combine the SCIENTIFIC and NAME; and COMMON and NAME_1 columns.


```r
code <- code %>% 
  mutate(scientific_name = paste(SCIENTIFIC, NAME, sep = " "),
         common_name = paste(COMMON, NAME_1, sep = " "),
         spp = CODE) %>% 
  select(-(CODE:NAME_1))
code
## # A tibble: 19 x 3
##    scientific_name            common_name          spp  
##    <chr>                      <chr>                <chr>
##  1 Cnemidophorus exanguis     Chihuahuan Spotted   CNEX 
##  2 Cnemidophorus inornatus    Little Striped       CNIN 
##  3 Cnemidophorus neomexicanus New Mexico           CNNE 
##  4 Cnemidophorus tessalatus   Colorado Checkered   CNTE 
##  5 Cnemidophorus tigrisatus   Western Whiptail     CNTI 
##  6 Cnemidophorus uniparens    Desert Grassland     CNUN 
##  7 Cophosuarus texanus        Greater Earless      COTE 
##  8 Crotaphytus collaris       Collared Lizard      CRCO 
##  9 Eumeces obsoletus          Great Plains         EUOB 
## 10 Gambelia wislizenii        Longnose Lepoard     GAWI 
## 11 Holbrookia maculata        Lesser Earless       HOMA 
## 12 Phrynosoma cornutum        Texas Horned         PHCO 
## 13 Phrynosoma modestum        Roundtail Horned     PHMO 
## 14 Sceloporus magisters       Desert Spiny         SCMA 
## 15 Sceloporus undulatus       Eastern Fence        SCUN 
## 16 Uta stansburiana           Side-blotched Lizard UTST 
## 17 UNKNOWN Cnemidophorus      NA NA                UKCN 
## 18 UNKNOWN lizard             NA NA                UKLI 
## 19 UNKNOWN Phrynosoma         NA NA                UKPH
```

Then we would want to join the two dataframes right? Which join should we use? What is the key?

What about reordering the columns in the same order and  changing characters to lower case?


```r
library(snakecase)
## Warning: package 'snakecase' was built under R version 4.0.5
left_join(lizards, code, by = 'spp') %>% 
  select(date, scientific_name, common_name, everything()) %>% 
  mutate_all(tolower)
## # A tibble: 4,091 x 16
##    date   scientific_name  common_name zone  site  plot  pit   spp   sex   rcap 
##    <chr>  <chr>            <chr>       <chr> <chr> <chr> <chr> <chr> <chr> <chr>
##  1 1989-~ cnemidophorus t~ western wh~ c     cali  a     4     cnti  m     n    
##  2 1989-~ uta stansburiana side-blotc~ c     cali  a     8     utst  j     n    
##  3 1989-~ cnemidophorus t~ western wh~ c     sand  b     2     cnti  m     n    
##  4 1989-~ cnemidophorus t~ western wh~ c     sand  b     8     cnti  f     n    
##  5 1989-~ cnemidophorus t~ western wh~ c     sand  c     2     cnti  m     n    
##  6 1989-~ cnemidophorus t~ western wh~ g     basn  b     1     cnti  f     n    
##  7 1989-~ uta stansburiana side-blotc~ g     basn  b     2     utst  f     n    
##  8 1989-~ cnemidophorus t~ colorado c~ g     basn  b     8     cnte  j     n    
##  9 1989-~ cnemidophorus t~ colorado c~ g     basn  b     9     cnte  f     n    
## 10 1989-~ cnemidophorus t~ western wh~ g     basn  b     10    cnti  m     n    
## # ... with 4,081 more rows, and 6 more variables: toe_num <chr>,
## #   SV_length <chr>, total_length <chr>, weight <chr>, tail <chr>, pc <chr>
```


