---
title: "Part 1: Working with time series data"
slug: "timeseries data"
subtitle: "Pharmacy Australia Centre of Excellence x Library R workshop"
author: "Stéphane Guillou"
date: "2022-01-27"
categories: ["R"]
tags: [""]
output:
  blogdown::html_page:
    df_print: tibble
    toc: true
    number_sections: TRUE
---




**Stéphane Guillou**

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

In this first part of the workshop, we will learn how to:

* Read data from multiple sheets into an object
* Clean the data and extract information
* Explore the data visually


## Load packages


```r
library(tidyverse)
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
## ✓ ggplot2 3.3.5     ✓ purrr   0.3.4
## ✓ tibble  3.1.6     ✓ dplyr   1.0.7
## ✓ tidyr   1.1.4     ✓ stringr 1.4.0
## ✓ readr   2.1.2     ✓ forcats 0.5.1
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
library(lubridate)
## 
## Attaching package: 'lubridate'
## The following objects are masked from 'package:base':
## 
##     date, intersect, setdiff, union
```

## About the data

Sampling design: Atmospheric samples of the Compound X were collected each day during seven consecutive days for different month in the year. Some year and months had less samples due to technical problems.


### Read in the data

We have an XLSX workbook that contains several sheets. The first one is only documenting what the data is about, whereas the two other ones contain the data we are interested in.

The package [readxl](https://readxl.tidyverse.org/) is useful for importing data stored in XLS and XLSX files. For example, to have a look at a single sheet of data, we can do the following:


```r
# load the package
library(readxl)
# only import the second sheet
analytes <- read_excel("tailored_data.xlsx", sheet = 2)
```

We could also point to the correct sheet by using the sheet name instead of its index. For that, the `excel_sheets()` function is useful to find the names:


```r
# excel_sheets() shows the sheet names
excel_sheets("Data workshop.xlsx")
## [1] "infromation data " "Site_759"          "Site_1335"
analytes <- read_excel("tailored_data.xlsx", sheet = "Site_759")
```

Let's have a look at the first few rows of data:


```r
head(analytes)
## # A tibble: 6 × 7
##   `Site code` Analyte    `Real date`           Day Month  Year `mg/day`
##         <dbl> <chr>      <dttm>              <dbl> <dbl> <dbl>    <dbl>
## 1         759 Compound x 1991-11-29 00:00:00    29    11  1991    0.334
## 2         759 Compound x 1991-11-30 00:00:00    30    11  1991    0.231
## 3         759 Compound x 1991-12-01 00:00:00     1    12  1991    0.216
## 4         759 Compound x 1991-12-02 00:00:00     2    12  1991    0.219
## 5         759 Compound x 1991-12-03 00:00:00     3    12  1991    0.203
## 6         759 Compound x 1991-12-04 00:00:00     4    12  1991    0.206
```

### Bind several workbook sheets

Even though this workbook only has two sheets of data, we might want to automate the reading and binding of all data sheets to avoid repeating code. This comes in very handy if you have a workbook with a dozen sheets of data, or if your data is split between several files.

The purrr is a package that allows "mapping" functions (or set of operations) to several elements. Here, we will _map_ the reading of the sheet to each _element_ in a vector of sheet names.

Using the `map_dfr()` function makes sure we have a single dataframe as an output.


```r
# only keep sheet names that contain actual data
sheets <- excel_sheets("Data workshop.xlsx")[2:3]
# map the reading to each sheet
library(purrr)
analytes <- map_dfr(sheets,
                    ~ read_excel("Data workshop.xlsx", sheet = .x))
```

We could map a function by simply providing the name of the function. However, because we are doing something slightly more elaborate here (pointing to one single file, and using an extra argument to point to the sheet itself), we need to use the `~` syntax.

> For more information on the different options the `map` family offers, see `?map`.

## Data cleaning


```r
# all same compound
analytes$Analyte <- "x"

# easier names
library(dplyr)
analytes <- rename(analytes, Site = 1, Date = 3, mg_per_day = 7)

# site shouldn't be numeric
analytes <- mutate(analytes, Site = as.character(Site))
```

## Quick viz of the data


```r
library(ggplot2)
ggplot(analytes, 
       aes(x = Date, y = mg_per_day, colour = Site)) +
  geom_line()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-6-1.png" width="672" />

```r
# line plot is not great because of the periodicity (bursts of sampling)

# smooth line that doesn't smooth too much:
ggplot(analytes, aes(x = Date, y = mg_per_day, colour = Site)) +
  geom_point(size = 0.3) +
  geom_smooth(span = 0.05)
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-6-2.png" width="672" />

```r
# careful: creates artificial dip in site 1335 to fit the data.
# confidence interval shows uncertainty.
```


```r
chem <- read_csv("tailored_data_R.csv") 
## Rows: 720 Columns: 4
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (2): Analyte, Date
## dbl (2): Site code, mg/day
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
head(chem)
## # A tibble: 6 × 4
##   `Site code` Analyte   Date       `mg/day`
##         <dbl> <chr>     <chr>         <dbl>
## 1        1335 compund x 28/11/1991    0.253
## 2        1335 compund x 29/11/1991    0.239
## 3        1335 compund x 30/11/1991    0.197
## 4        1335 compund x 1/12/1991     0.173
## 5        1335 compund x 2/12/1991     0.222
## 6        1335 compund x 3/12/1991     0.191
```

Change columns to appropriate data type:


```r
chem$`Site code` <- as.factor(chem$`Site code`)
chem$Analyte <- as.factor(chem$Analyte)
chem$Date <- as.Date(chem$Date, format =  "%d/%m/%Y")

head(chem)
## # A tibble: 6 × 4
##   `Site code` Analyte   Date       `mg/day`
##   <fct>       <fct>     <date>        <dbl>
## 1 1335        compund x 1991-11-28    0.253
## 2 1335        compund x 1991-11-29    0.239
## 3 1335        compund x 1991-11-30    0.197
## 4 1335        compund x 1991-12-01    0.173
## 5 1335        compund x 1991-12-02    0.222
## 6 1335        compund x 1991-12-03    0.191
```

## Visualize the data


```r
ggplot(data = chem,
       aes(x = Date,
           y = `mg/day`)) +
   geom_point()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-9-1.png" width="672" />



