---
title: "Day 1.2 Data visualization"
subtitle: "Customized Data Visualization in `ggplot2`"
date: '2021-11-02'
output: 
  blogdown::html_page:
    df_print: tibble
    toc: true
    number_sections: TRUE
  
---

**Caitie Kuempel, PhD**

Post-doctoral researcher, Coral Reef Ecosystems Lab, University of Queensland

- c.kuempel@uq.edu.au
- [\@cdkuempel](https://twitter.com/cdkuempel)


These materials were created by **Allison Horst, PhD**

Assistant Teaching Professor, Bren School, UC Santa Barbara

- ahorst@ucsb.edu
- [\@allison_horst](https://twitter.com/allison_horst)

## Topics

-  Conceptual hierarchy of data viz
- `ggplot2` basics review
    - Aesthetic mapping
    - Themes
    - Labels
    - Facets (& facet grids vs facet wraps)
    - Getting things in order (e.g. fct_reorder)
- Advanced customization in `ggplot2`
    - `scales` for thoughtful breaks and labels
    - ...and color schemes (+ `paletteer`!)
    - In the weeds of themes (gridlines, panel colors, margins, etc.)
    - Direct annotation (as an alternative to legends)
    - Repulsive labels (e.g. `ggrepel`)
    - Highlighting for clarity (e.g. with `gghighlight`)
- Compound figures with `patchwork`
- A few new graph types to consider
    - Marginal plot
    - Beeswarm plots with `ggbeeswarm`
    - Heatmaps with `geom_tile()`
- Export & save your graphs
- Keep learning


# Citations and data

## R packages

- `tidyverse`: Wickham et al., (2019). Welcome to the tidyverse. Journal of
  Open Source Software, 4(43), 1686,
  https://doi.org/10.21105/joss.01686
- `ggplot2`: H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New
  York, 2016.
- `ggrepel`: Kamil Slowikowski (2021). ggrepel: Automatically Position Non-Overlapping Text
  Labels with 'ggplot2'. R package version 0.9.1.
  https://github.com/slowkow/ggrepel
- `gghighlight`: Hiroaki Yutani (2020). gghighlight: Highlight Lines and Points in 'ggplot2'. R
  package version 0.3.1. https://github.com/yutannihilation/gghighlight/
- `R Markdown`: Yihui Xie and J.J. Allaire and Garrett Grolemund (2018). R Markdown: The
  Definitive Guide. Chapman and Hall/CRC. ISBN 9781138359338. URL
  https://bookdown.org/yihui/rmarkdown.
- `sf`: Pebesma, E., 2018. Simple Features for R: Standardized Support for Spatial Vector
  Data. The R Journal 10 (1), 439-446, https://doi.org/10.32614/RJ-2018-009
- `paletteer`: See AUTHORS file. (2021). paletteer: Comprehensive Collection of Color Palettes. R package version 1.3.0. https://github.com/EmilHvitfeldt/paletteer
- `gapminder`: Jennifer Bryan (2017). gapminder: Data from Gapminder.
  https://github.com/jennybc/gapminder, http://www.gapminder.org/data/,
  https://doi.org/10.5281/zenodo.594018.
- `janitor`:Sam Firke (2021). janitor: Simple Tools for Examining and Cleaning Dirty Data. R
  package version 2.1.0. https://github.com/sfirke/janitor
  
## Lizard size measurement data

Our data are a curated subset from [Jornada Basin Long Term Ecological Research site](https://lter.jornada.nmsu.edu/) in New Mexico, part of the US Long Term Ecological Research (LTER) network: 

- Lightfoot, D. and W.G. Whitford. 2020. Lizard pitfall trap data from 11 NPP study locations at the Jornada Basin LTER site, 1989-2006 ver 37. Environmental Data Initiative. https://doi.org/10.6073/pasta/4a6e258fb49c31e222ecbbcfd128967f

From the data package: "This data package contains data on lizards sampled by pitfall traps located at 11 consumer plots at Jornada Basin LTER site from 1989-2006. The objective of this study is to observe how shifts in vegetation resulting from desertification processes in the Chihuahaun desert have changed the spatial and temporal availability of resources for consumers. Desertification changes in the Jornada Basin include changes from grass to shrub dominated communities and major soil changes. If grassland systems respond to rainfall without significant lags, but shrub systems do not, then consumer species should reflect these differences. In addition, shifts from grassland to shrubland results in greater structural heterogeneity of the habitats. We hypothesized that consumer populations, diversity, and densities of some consumers will be higher in grasslands than in shrublands and will be related to the NPP of the sites. Lizards were captured in pitfall traps at the 11 LTER II/III consumer plots (a subset of NPP plots) quarterly for 2 weeks per quarter. Variables measured include species, sex, recapture status, snout-vent length, total length, weight, and whether tail is broken or whole. This study is complete." 

There are 16 total variables in the `lizards.csv` data we'll read in. The ones we'll use in this workshop are: 

- `date`: data collection date
- `scientific_name`: lizard scientific name
- `common_name`: lizard common name
- `site`: research site code
- `sex`: lizard sex (m = male; f = female; j = juvenile)
- `sv_length`: snout-vent length (millimeters)
- `total_length`: body length (millimeters)
- `toe_num`: toe mark number
- `weight`: body weight (grams)
- `tail`: tail condition (b = broken; w = whole)

## Jornada vegetation spatial data

From [Jornada Basin LTER Spatial Data](https://lter.jornada.nmsu.edu/spatial-data/): Dominant Vegetation of the JER and CDRRC in 1998  (Download KMZ 3972 KB) Dominant and subdominant vegetation on the Jornada Experimental Range and Chihuahuan Desert Rangeland Research Center in 1998. Published in Gibbens, R. P., McNeely, R. P., Havstad, K. M., Beck, R. F., & Nolen, B. (2005). Vegetation changes in the Jornada Basin from 1858 to 1998. Journal of Arid Environments, 61(4), 651-668.  

# Set-up

## Get workshop materials

You can get the workshop materials in two ways:

1. Clone the workshop repo from GitHub to work locally
2. Create an RStudio Cloud account, and click [HERE](https://rstudio.cloud/project/2181259) to get to the project. Make sure you click on 'Make permanent copy' so your updates & notes will be stored.

## Create a new R Markdown document or R script

I will be working in R Markdown, but you can follow along in either an .Rmd or R script. 

## Attach R packages




```r
# General use packages:
library(tidyverse)
library(here)
library(janitor)
# Specifically for plots:
library(patchwork)
library(ggrepel)
library(gghighlight)
library(paletteer)
library(ggExtra)
library(ggbeeswarm)
# And for another dataset we'll explore:
library(gapminder)
# Spatial
library(sf)
```

## Read in the lizard data
































































































































