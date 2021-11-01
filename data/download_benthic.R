# Package ID: knb-lter-mcr.8.31 Cataloging System:https://pasta.edirepository.org.
# Data set title: MCR LTER: Coral Reef: Long-term Population and Community Dynamics: Benthic Algae and Other Community Components, ongoing since 2005.
# Data set creator:    - Moorea Coral Reef LTER 
# Data set creator:  Robert Carpenter - Moorea Coral Reef LTER 
# Metadata Provider:    - Moorea Coral Reef LTER 
# Contact:    - Information Manager Moorea Coral Reef LTER  - mcrlter@msi.ucsb.edu
# Stylesheet v2.11 for metadata conversion into program: John H. Porter, Univ. Virginia, jporter@virginia.edu 

inUrl1  <- "https://pasta.lternet.edu/package/data/eml/knb-lter-mcr/8/31/54d54c25616a48b9ec684118df9d6fca" 
infile1 <- tempfile()
try(download.file(inUrl1,infile1,method="curl"))
if (is.na(file.size(infile1))) download.file(inUrl1,infile1,method="auto")


dt1 <-read.csv(infile1,header=F 
               ,skip=1
               ,sep=","  
               ,quot='"' 
               , col.names=c(
                 "Year",     
                 "Date",     
                 "Location",     
                 "Site",     
                 "Habitat",     
                 "Transect",     
                 "Quadrat",     
                 "Taxonomy_Substrate_Functional_Group",     
                 "Percent_Cover"    ), check.names=TRUE)

unlink(infile1)

# Fix any interval or ratio columns mistakenly read in as nominal and nominal columns read as numeric or dates read as strings

# attempting to convert dt1$Date dateTime string to R date structure (date or POSIXct)                                
tmpDateFormat<-"%Y-%m-%d"
tmp1Date<-as.Date(dt1$Date,format=tmpDateFormat)
# Keep the new dates only if they all converted correctly
if(length(tmp1Date) == length(tmp1Date[!is.na(tmp1Date)])){dt1$Date <- tmp1Date } else {print("Date conversion failed for dt1$Date. Please inspect the data and do the date conversion yourself.")}                                                                    
rm(tmpDateFormat,tmp1Date) 
if (class(dt1$Location)!="factor") dt1$Location<- as.factor(dt1$Location)
if (class(dt1$Site)!="factor") dt1$Site<- as.factor(dt1$Site)
if (class(dt1$Habitat)!="factor") dt1$Habitat<- as.factor(dt1$Habitat)
if (class(dt1$Transect)!="factor") dt1$Transect<- as.factor(dt1$Transect)
if (class(dt1$Quadrat)!="factor") dt1$Quadrat<- as.factor(dt1$Quadrat)
if (class(dt1$Taxonomy_Substrate_Functional_Group)!="factor") dt1$Taxonomy_Substrate_Functional_Group<- as.factor(dt1$Taxonomy_Substrate_Functional_Group)
if (class(dt1$Percent_Cover)=="factor") dt1$Percent_Cover <-as.numeric(levels(dt1$Percent_Cover))[as.integer(dt1$Percent_Cover) ]               
if (class(dt1$Percent_Cover)=="character") dt1$Percent_Cover <-as.numeric(dt1$Percent_Cover)

# Convert Missing Values to NA for non-dates

dt1$Percent_Cover <- ifelse((trimws(as.character(dt1$Percent_Cover))==trimws("-1")),NA,dt1$Percent_Cover)               
suppressWarnings(dt1$Percent_Cover <- ifelse(!is.na(as.numeric("-1")) & (trimws(as.character(dt1$Percent_Cover))==as.character(as.numeric("-1"))),NA,dt1$Percent_Cover))


# Here is the structure of the input data frame:
str(dt1)                            
attach(dt1)                            
# The analyses below are basic descriptions of the variables. After testing, they should be replaced.                 

summary(Year)
summary(Date)
summary(Location)
summary(Site)
summary(Habitat)
summary(Transect)
summary(Quadrat)
summary(Taxonomy_Substrate_Functional_Group)
summary(Percent_Cover) 
# Get more details on character variables

summary(as.factor(dt1$Location)) 
summary(as.factor(dt1$Site)) 
summary(as.factor(dt1$Habitat)) 
summary(as.factor(dt1$Transect)) 
summary(as.factor(dt1$Quadrat)) 
summary(as.factor(dt1$Taxonomy_Substrate_Functional_Group))
detach(dt1)               

write.csv(dt1, "data/benthic.csv", row.names = FALSE)



