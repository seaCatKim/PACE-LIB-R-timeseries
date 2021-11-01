# Package ID: knb-lter-mcr.6.57 Cataloging System:https://pasta.edirepository.org.
# Data set title: MCR LTER: Coral Reef: Long-term Population and Community Dynamics: Fishes, ongoing since 2005.
# Data set creator:    - Moorea Coral Reef LTER 
# Data set creator:  Andrew Brooks - Moorea Coral Reef LTER 
# Contact:    - Information Manager Moorea Coral Reef LTER  - mcrlter@msi.ucsb.edu
# Stylesheet v2.11 for metadata conversion into program: John H. Porter, Univ. Virginia, jporter@virginia.edu 

inUrl1  <- "https://pasta.lternet.edu/package/data/eml/knb-lter-mcr/6/57/ac2c7a859ce8595ec1339e8530b9ba50" 
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
                 "Start_time",     
                 "End_time",     
                 "Location",     
                 "Site",     
                 "Habitat",     
                 "Transect",     
                 "Transect_Width",     
                 "Taxonomy",     
                 "Family",     
                 "Fish_Count",     
                 "Total_Length",     
                 "Length_Anomaly",     
                 "Biomass",     
                 "Coarse_Trophic",     
                 "Fine_Trophic",     
                 "Cloud_Cover",     
                 "Wind_Velocity",     
                 "Sea_State",     
                 "Swell",     
                 "Visibility",     
                 "Surge",     
                 "Diver"    ), check.names=TRUE)

unlink(infile1)

# Fix any interval or ratio columns mistakenly read in as nominal and nominal columns read as numeric or dates read as strings

# attempting to convert dt1$Date dateTime string to R date structure (date or POSIXct)                                
tmpDateFormat<-"%Y-%m-%d"
tmp1Date<-as.Date(dt1$Date,format=tmpDateFormat)
# Keep the new dates only if they all converted correctly
if(length(tmp1Date) == length(tmp1Date[!is.na(tmp1Date)])){dt1$Date <- tmp1Date } else {print("Date conversion failed for dt1$Date. Please inspect the data and do the date conversion yourself.")}                                                                    
rm(tmpDateFormat,tmp1Date) 
if (class(dt1$Start_time)!="factor") dt1$Start_time<- as.factor(dt1$Start_time)
if (class(dt1$End_time)!="factor") dt1$End_time<- as.factor(dt1$End_time)
if (class(dt1$Location)!="factor") dt1$Location<- as.factor(dt1$Location)
if (class(dt1$Site)!="factor") dt1$Site<- as.factor(dt1$Site)
if (class(dt1$Habitat)!="factor") dt1$Habitat<- as.factor(dt1$Habitat)
if (class(dt1$Transect)!="factor") dt1$Transect<- as.factor(dt1$Transect)
if (class(dt1$Transect_Width)=="factor") dt1$Transect_Width <-as.numeric(levels(dt1$Transect_Width))[as.integer(dt1$Transect_Width) ]               
if (class(dt1$Transect_Width)=="character") dt1$Transect_Width <-as.numeric(dt1$Transect_Width)
if (class(dt1$Taxonomy)!="factor") dt1$Taxonomy<- as.factor(dt1$Taxonomy)
if (class(dt1$Family)!="factor") dt1$Family<- as.factor(dt1$Family)
if (class(dt1$Fish_Count)=="factor") dt1$Fish_Count <-as.numeric(levels(dt1$Fish_Count))[as.integer(dt1$Fish_Count) ]               
if (class(dt1$Fish_Count)=="character") dt1$Fish_Count <-as.numeric(dt1$Fish_Count)
if (class(dt1$Total_Length)=="factor") dt1$Total_Length <-as.numeric(levels(dt1$Total_Length))[as.integer(dt1$Total_Length) ]               
if (class(dt1$Total_Length)=="character") dt1$Total_Length <-as.numeric(dt1$Total_Length)
if (class(dt1$Length_Anomaly)!="factor") dt1$Length_Anomaly<- as.factor(dt1$Length_Anomaly)
if (class(dt1$Biomass)=="factor") dt1$Biomass <-as.numeric(levels(dt1$Biomass))[as.integer(dt1$Biomass) ]               
if (class(dt1$Biomass)=="character") dt1$Biomass <-as.numeric(dt1$Biomass)
if (class(dt1$Coarse_Trophic)!="factor") dt1$Coarse_Trophic<- as.factor(dt1$Coarse_Trophic)
if (class(dt1$Fine_Trophic)!="factor") dt1$Fine_Trophic<- as.factor(dt1$Fine_Trophic)
if (class(dt1$Cloud_Cover)=="factor") dt1$Cloud_Cover <-as.numeric(levels(dt1$Cloud_Cover))[as.integer(dt1$Cloud_Cover) ]               
if (class(dt1$Cloud_Cover)=="character") dt1$Cloud_Cover <-as.numeric(dt1$Cloud_Cover)
if (class(dt1$Swell)=="factor") dt1$Swell <-as.numeric(levels(dt1$Swell))[as.integer(dt1$Swell) ]               
if (class(dt1$Swell)=="character") dt1$Swell <-as.numeric(dt1$Swell)
if (class(dt1$Visibility)=="factor") dt1$Visibility <-as.numeric(levels(dt1$Visibility))[as.integer(dt1$Visibility) ]               
if (class(dt1$Visibility)=="character") dt1$Visibility <-as.numeric(dt1$Visibility)
if (class(dt1$Surge)=="factor") dt1$Surge <-as.numeric(levels(dt1$Surge))[as.integer(dt1$Surge) ]               
if (class(dt1$Surge)=="character") dt1$Surge <-as.numeric(dt1$Surge)
if (class(dt1$Diver)!="factor") dt1$Diver<- as.factor(dt1$Diver)

# Convert Missing Values to NA for non-dates

dt1$Taxonomy <- as.factor(ifelse((trimws(as.character(dt1$Taxonomy))==trimws("No fish observed")),NA,as.character(dt1$Taxonomy)))
dt1$Total_Length <- ifelse((trimws(as.character(dt1$Total_Length))==trimws("-1")),NA,dt1$Total_Length)               
suppressWarnings(dt1$Total_Length <- ifelse(!is.na(as.numeric("-1")) & (trimws(as.character(dt1$Total_Length))==as.character(as.numeric("-1"))),NA,dt1$Total_Length))
dt1$Length_Anomaly <- as.factor(ifelse((trimws(as.character(dt1$Length_Anomaly))==trimws("na")),NA,as.character(dt1$Length_Anomaly)))
dt1$Biomass <- ifelse((trimws(as.character(dt1$Biomass))==trimws("-1")),NA,dt1$Biomass)               
suppressWarnings(dt1$Biomass <- ifelse(!is.na(as.numeric("-1")) & (trimws(as.character(dt1$Biomass))==as.character(as.numeric("-1"))),NA,dt1$Biomass))
dt1$Coarse_Trophic <- as.factor(ifelse((trimws(as.character(dt1$Coarse_Trophic))==trimws("na")),NA,as.character(dt1$Coarse_Trophic)))
dt1$Fine_Trophic <- as.factor(ifelse((trimws(as.character(dt1$Fine_Trophic))==trimws("na")),NA,as.character(dt1$Fine_Trophic)))
dt1$Visibility <- ifelse((trimws(as.character(dt1$Visibility))==trimws("-1")),NA,dt1$Visibility)               
suppressWarnings(dt1$Visibility <- ifelse(!is.na(as.numeric("-1")) & (trimws(as.character(dt1$Visibility))==as.character(as.numeric("-1"))),NA,dt1$Visibility))


# Here is the structure of the input data frame:
str(dt1)                            
attach(dt1)                            
# The analyses below are basic descriptions of the variables. After testing, they should be replaced.                 

summary(Year)
summary(Date)
summary(Start_time)
summary(End_time)
summary(Location)
summary(Site)
summary(Habitat)
summary(Transect)
summary(Transect_Width)
summary(Taxonomy)
summary(Family)
summary(Fish_Count)
summary(Total_Length)
summary(Length_Anomaly)
summary(Biomass)
summary(Coarse_Trophic)
summary(Fine_Trophic)
summary(Cloud_Cover)
summary(Wind_Velocity)
summary(Sea_State)
summary(Swell)
summary(Visibility)
summary(Surge)
summary(Diver) 
# Get more details on character variables

summary(as.factor(dt1$Start_time)) 
summary(as.factor(dt1$End_time)) 
summary(as.factor(dt1$Location)) 
summary(as.factor(dt1$Site)) 
summary(as.factor(dt1$Habitat)) 
summary(as.factor(dt1$Transect)) 
summary(as.factor(dt1$Taxonomy)) 
summary(as.factor(dt1$Family)) 
summary(as.factor(dt1$Length_Anomaly)) 
summary(as.factor(dt1$Coarse_Trophic)) 
summary(as.factor(dt1$Fine_Trophic)) 
summary(as.factor(dt1$Wind_Velocity)) 
summary(as.factor(dt1$Sea_State)) 
summary(as.factor(dt1$Diver))
detach(dt1)               


inUrl2  <- "https://pasta.lternet.edu/package/data/eml/knb-lter-mcr/6/57/7e98ebd18e0455d1a73ed6049a07fab2" 
infile2 <- tempfile()
try(download.file(inUrl2,infile2,method="curl"))
if (is.na(file.size(infile2))) download.file(inUrl2,infile2,method="auto")


dt2 <-read.csv(infile2,header=F 
               ,skip=1
               ,sep=","  
               ,quot='"' 
               , col.names=c(
                 "Year",     
                 "Date",     
                 "Start_time",     
                 "End_time",     
                 "Location",     
                 "Site",     
                 "Habitat",     
                 "Transect",     
                 "Transect_Width",     
                 "Taxonomy",     
                 "Family",     
                 "Fish_Count",     
                 "Cloud_Cover",     
                 "Wind_Velocity",     
                 "Sea_State",     
                 "Swell",     
                 "Visibility",     
                 "Surge",     
                 "Diver"    ), check.names=TRUE)

unlink(infile2)

# Fix any interval or ratio columns mistakenly read in as nominal and nominal columns read as numeric or dates read as strings

# attempting to convert dt2$Date dateTime string to R date structure (date or POSIXct)                                
tmpDateFormat<-"%Y-%m-%d"
tmp2Date<-as.Date(dt2$Date,format=tmpDateFormat)
# Keep the new dates only if they all converted correctly
if(length(tmp2Date) == length(tmp2Date[!is.na(tmp2Date)])){dt2$Date <- tmp2Date } else {print("Date conversion failed for dt2$Date. Please inspect the data and do the date conversion yourself.")}                                                                    
rm(tmpDateFormat,tmp2Date) 
if (class(dt2$Location)!="factor") dt2$Location<- as.factor(dt2$Location)
if (class(dt2$Site)!="factor") dt2$Site<- as.factor(dt2$Site)
if (class(dt2$Habitat)!="factor") dt2$Habitat<- as.factor(dt2$Habitat)
if (class(dt2$Transect)!="factor") dt2$Transect<- as.factor(dt2$Transect)
if (class(dt2$Transect_Width)=="factor") dt2$Transect_Width <-as.numeric(levels(dt2$Transect_Width))[as.integer(dt2$Transect_Width) ]               
if (class(dt2$Transect_Width)=="character") dt2$Transect_Width <-as.numeric(dt2$Transect_Width)
if (class(dt2$Taxonomy)!="factor") dt2$Taxonomy<- as.factor(dt2$Taxonomy)
if (class(dt2$Family)!="factor") dt2$Family<- as.factor(dt2$Family)
if (class(dt2$Fish_Count)=="factor") dt2$Fish_Count <-as.numeric(levels(dt2$Fish_Count))[as.integer(dt2$Fish_Count) ]               
if (class(dt2$Fish_Count)=="character") dt2$Fish_Count <-as.numeric(dt2$Fish_Count)
if (class(dt2$Cloud_Cover)=="factor") dt2$Cloud_Cover <-as.numeric(levels(dt2$Cloud_Cover))[as.integer(dt2$Cloud_Cover) ]               
if (class(dt2$Cloud_Cover)=="character") dt2$Cloud_Cover <-as.numeric(dt2$Cloud_Cover)
if (class(dt2$Swell)=="factor") dt2$Swell <-as.numeric(levels(dt2$Swell))[as.integer(dt2$Swell) ]               
if (class(dt2$Swell)=="character") dt2$Swell <-as.numeric(dt2$Swell)
if (class(dt2$Visibility)=="factor") dt2$Visibility <-as.numeric(levels(dt2$Visibility))[as.integer(dt2$Visibility) ]               
if (class(dt2$Visibility)=="character") dt2$Visibility <-as.numeric(dt2$Visibility)
if (class(dt2$Surge)=="factor") dt2$Surge <-as.numeric(levels(dt2$Surge))[as.integer(dt2$Surge) ]               
if (class(dt2$Surge)=="character") dt2$Surge <-as.numeric(dt2$Surge)
if (class(dt2$Diver)!="factor") dt2$Diver<- as.factor(dt2$Diver)

# Convert Missing Values to NA for non-dates

dt2$Taxonomy <- as.factor(ifelse((trimws(as.character(dt2$Taxonomy))==trimws("No fish observed")),NA,as.character(dt2$Taxonomy)))
dt2$Visibility <- ifelse((trimws(as.character(dt2$Visibility))==trimws("-1")),NA,dt2$Visibility)               
suppressWarnings(dt2$Visibility <- ifelse(!is.na(as.numeric("-1")) & (trimws(as.character(dt2$Visibility))==as.character(as.numeric("-1"))),NA,dt2$Visibility))


# Here is the structure of the input data frame:
str(dt2)                            
attach(dt2)                            
# The analyses below are basic descriptions of the variables. After testing, they should be replaced.                 

summary(Year)
summary(Date)
summary(Start_time)
summary(End_time)
summary(Location)
summary(Site)
summary(Habitat)
summary(Transect)
summary(Transect_Width)
summary(Taxonomy)
summary(Family)
summary(Fish_Count)
summary(Cloud_Cover)
summary(Wind_Velocity)
summary(Sea_State)
summary(Swell)
summary(Visibility)
summary(Surge)
summary(Diver) 
# Get more details on character variables

summary(as.factor(dt2$Location)) 
summary(as.factor(dt2$Site)) 
summary(as.factor(dt2$Habitat)) 
summary(as.factor(dt2$Transect)) 
summary(as.factor(dt2$Taxonomy)) 
summary(as.factor(dt2$Family)) 
summary(as.factor(dt2$Wind_Velocity)) 
summary(as.factor(dt2$Sea_State)) 
summary(as.factor(dt2$Diver))
detach(dt2)               


inUrl3  <- "https://pasta.lternet.edu/package/data/eml/knb-lter-mcr/6/57/ce86f12e1bf9b1827e06894244c6148e" 
infile3 <- tempfile()
try(download.file(inUrl3,infile3,method="curl"))
if (is.na(file.size(infile3))) download.file(inUrl3,infile3,method="auto")


dt3 <-read.csv(infile3,header=F 
               ,skip=1
               ,sep=","  
               ,quot='"' 
               , col.names=c(
                 "taxon_phylum",     
                 "taxon_subphylum",     
                 "taxon_infraphylum",     
                 "taxon_class",     
                 "taxon_subclass",     
                 "taxon_division",     
                 "taxon_subdivision",     
                 "taxon_order",     
                 "taxon_family",     
                 "taxon_genus",     
                 "taxon_species_binomial",     
                 "common_name"    ), check.names=TRUE)

unlink(infile3)

# Fix any interval or ratio columns mistakenly read in as nominal and nominal columns read as numeric or dates read as strings

if (class(dt3$taxon_phylum)!="factor") dt3$taxon_phylum<- as.factor(dt3$taxon_phylum)
if (class(dt3$taxon_subphylum)!="factor") dt3$taxon_subphylum<- as.factor(dt3$taxon_subphylum)
if (class(dt3$taxon_infraphylum)!="factor") dt3$taxon_infraphylum<- as.factor(dt3$taxon_infraphylum)
if (class(dt3$taxon_class)!="factor") dt3$taxon_class<- as.factor(dt3$taxon_class)
if (class(dt3$taxon_subclass)!="factor") dt3$taxon_subclass<- as.factor(dt3$taxon_subclass)
if (class(dt3$taxon_division)!="factor") dt3$taxon_division<- as.factor(dt3$taxon_division)
if (class(dt3$taxon_subdivision)!="factor") dt3$taxon_subdivision<- as.factor(dt3$taxon_subdivision)
if (class(dt3$taxon_order)!="factor") dt3$taxon_order<- as.factor(dt3$taxon_order)
if (class(dt3$taxon_family)!="factor") dt3$taxon_family<- as.factor(dt3$taxon_family)
if (class(dt3$taxon_genus)!="factor") dt3$taxon_genus<- as.factor(dt3$taxon_genus)
if (class(dt3$taxon_species_binomial)!="factor") dt3$taxon_species_binomial<- as.factor(dt3$taxon_species_binomial)
if (class(dt3$common_name)!="factor") dt3$common_name<- as.factor(dt3$common_name)

# Convert Missing Values to NA for non-dates

dt3$taxon_phylum <- as.factor(ifelse((trimws(as.character(dt3$taxon_phylum))==trimws("NA")),NA,as.character(dt3$taxon_phylum)))
dt3$taxon_subphylum <- as.factor(ifelse((trimws(as.character(dt3$taxon_subphylum))==trimws("NA")),NA,as.character(dt3$taxon_subphylum)))
dt3$taxon_infraphylum <- as.factor(ifelse((trimws(as.character(dt3$taxon_infraphylum))==trimws("NA")),NA,as.character(dt3$taxon_infraphylum)))
dt3$taxon_class <- as.factor(ifelse((trimws(as.character(dt3$taxon_class))==trimws("NA")),NA,as.character(dt3$taxon_class)))
dt3$taxon_subclass <- as.factor(ifelse((trimws(as.character(dt3$taxon_subclass))==trimws("NA")),NA,as.character(dt3$taxon_subclass)))
dt3$taxon_division <- as.factor(ifelse((trimws(as.character(dt3$taxon_division))==trimws("NA")),NA,as.character(dt3$taxon_division)))
dt3$taxon_subdivision <- as.factor(ifelse((trimws(as.character(dt3$taxon_subdivision))==trimws("NA")),NA,as.character(dt3$taxon_subdivision)))
dt3$taxon_order <- as.factor(ifelse((trimws(as.character(dt3$taxon_order))==trimws("NA")),NA,as.character(dt3$taxon_order)))
dt3$taxon_family <- as.factor(ifelse((trimws(as.character(dt3$taxon_family))==trimws("NA")),NA,as.character(dt3$taxon_family)))
dt3$taxon_genus <- as.factor(ifelse((trimws(as.character(dt3$taxon_genus))==trimws("NA")),NA,as.character(dt3$taxon_genus)))
dt3$taxon_species_binomial <- as.factor(ifelse((trimws(as.character(dt3$taxon_species_binomial))==trimws("NA")),NA,as.character(dt3$taxon_species_binomial)))
dt3$common_name <- as.factor(ifelse((trimws(as.character(dt3$common_name))==trimws("NA")),NA,as.character(dt3$common_name)))


# Here is the structure of the input data frame:
str(dt3)                            
attach(dt3)                            
# The analyses below are basic descriptions of the variables. After testing, they should be replaced.                 

summary(taxon_phylum)
summary(taxon_subphylum)
summary(taxon_infraphylum)
summary(taxon_class)
summary(taxon_subclass)
summary(taxon_division)
summary(taxon_subdivision)
summary(taxon_order)
summary(taxon_family)
summary(taxon_genus)
summary(taxon_species_binomial)
summary(common_name) 
# Get more details on character variables

summary(as.factor(dt3$taxon_phylum)) 
summary(as.factor(dt3$taxon_subphylum)) 
summary(as.factor(dt3$taxon_infraphylum)) 
summary(as.factor(dt3$taxon_class)) 
summary(as.factor(dt3$taxon_subclass)) 
summary(as.factor(dt3$taxon_division)) 
summary(as.factor(dt3$taxon_subdivision)) 
summary(as.factor(dt3$taxon_order)) 
summary(as.factor(dt3$taxon_family)) 
summary(as.factor(dt3$taxon_genus)) 
summary(as.factor(dt3$taxon_species_binomial)) 
summary(as.factor(dt3$common_name))
detach(dt3)               


inUrl4  <- "https://pasta.lternet.edu/package/data/eml/knb-lter-mcr/6/57/6b6c320424eace066ae8f4181df13378" 
infile4 <- tempfile()
try(download.file(inUrl4,infile4,method="curl"))
if (is.na(file.size(infile4))) download.file(inUrl4,infile4,method="auto")


dt4 <-read.csv(infile4,header=F 
               ,skip=1
               ,sep=","  
               ,quot='"' 
               , col.names=c(
                 "Year",     
                 "Date",     
                 "Start_time",     
                 "End_time",     
                 "Location",     
                 "Site",     
                 "Habitat",     
                 "Transect",     
                 "Transect_Width",     
                 "Taxonomy",     
                 "Family",     
                 "Fish_Count",     
                 "Total_Length",     
                 "Length_Anomaly",     
                 "Biomass",     
                 "Coarse_Trophic",     
                 "Fine_Trophic",     
                 "Cloud_Cover",     
                 "Wind_Velocity",     
                 "Sea_State",     
                 "Swell",     
                 "Visibility",     
                 "Surge",     
                 "Diver"    ), check.names=TRUE)

unlink(infile4)

# Fix any interval or ratio columns mistakenly read in as nominal and nominal columns read as numeric or dates read as strings

# attempting to convert dt4$Date dateTime string to R date structure (date or POSIXct)                                
tmpDateFormat<-"%Y-%m-%d"
tmp4Date<-as.Date(dt4$Date,format=tmpDateFormat)
# Keep the new dates only if they all converted correctly
if(length(tmp4Date) == length(tmp4Date[!is.na(tmp4Date)])){dt4$Date <- tmp4Date } else {print("Date conversion failed for dt4$Date. Please inspect the data and do the date conversion yourself.")}                                                                    
rm(tmpDateFormat,tmp4Date) 
if (class(dt4$Start_time)!="factor") dt4$Start_time<- as.factor(dt4$Start_time)
if (class(dt4$End_time)!="factor") dt4$End_time<- as.factor(dt4$End_time)
if (class(dt4$Location)!="factor") dt4$Location<- as.factor(dt4$Location)
if (class(dt4$Site)!="factor") dt4$Site<- as.factor(dt4$Site)
if (class(dt4$Habitat)!="factor") dt4$Habitat<- as.factor(dt4$Habitat)
if (class(dt4$Transect)!="factor") dt4$Transect<- as.factor(dt4$Transect)
if (class(dt4$Transect_Width)=="factor") dt4$Transect_Width <-as.numeric(levels(dt4$Transect_Width))[as.integer(dt4$Transect_Width) ]               
if (class(dt4$Transect_Width)=="character") dt4$Transect_Width <-as.numeric(dt4$Transect_Width)
if (class(dt4$Taxonomy)!="factor") dt4$Taxonomy<- as.factor(dt4$Taxonomy)
if (class(dt4$Family)!="factor") dt4$Family<- as.factor(dt4$Family)
if (class(dt4$Fish_Count)=="factor") dt4$Fish_Count <-as.numeric(levels(dt4$Fish_Count))[as.integer(dt4$Fish_Count) ]               
if (class(dt4$Fish_Count)=="character") dt4$Fish_Count <-as.numeric(dt4$Fish_Count)
if (class(dt4$Total_Length)=="factor") dt4$Total_Length <-as.numeric(levels(dt4$Total_Length))[as.integer(dt4$Total_Length) ]               
if (class(dt4$Total_Length)=="character") dt4$Total_Length <-as.numeric(dt4$Total_Length)
if (class(dt4$Length_Anomaly)!="factor") dt4$Length_Anomaly<- as.factor(dt4$Length_Anomaly)
if (class(dt4$Biomass)=="factor") dt4$Biomass <-as.numeric(levels(dt4$Biomass))[as.integer(dt4$Biomass) ]               
if (class(dt4$Biomass)=="character") dt4$Biomass <-as.numeric(dt4$Biomass)
if (class(dt4$Coarse_Trophic)!="factor") dt4$Coarse_Trophic<- as.factor(dt4$Coarse_Trophic)
if (class(dt4$Fine_Trophic)!="factor") dt4$Fine_Trophic<- as.factor(dt4$Fine_Trophic)
if (class(dt4$Cloud_Cover)=="factor") dt4$Cloud_Cover <-as.numeric(levels(dt4$Cloud_Cover))[as.integer(dt4$Cloud_Cover) ]               
if (class(dt4$Cloud_Cover)=="character") dt4$Cloud_Cover <-as.numeric(dt4$Cloud_Cover)
if (class(dt4$Swell)=="factor") dt4$Swell <-as.numeric(levels(dt4$Swell))[as.integer(dt4$Swell) ]               
if (class(dt4$Swell)=="character") dt4$Swell <-as.numeric(dt4$Swell)
if (class(dt4$Visibility)=="factor") dt4$Visibility <-as.numeric(levels(dt4$Visibility))[as.integer(dt4$Visibility) ]               
if (class(dt4$Visibility)=="character") dt4$Visibility <-as.numeric(dt4$Visibility)
if (class(dt4$Surge)=="factor") dt4$Surge <-as.numeric(levels(dt4$Surge))[as.integer(dt4$Surge) ]               
if (class(dt4$Surge)=="character") dt4$Surge <-as.numeric(dt4$Surge)
if (class(dt4$Diver)!="factor") dt4$Diver<- as.factor(dt4$Diver)

# Convert Missing Values to NA for non-dates

dt4$Taxonomy <- as.factor(ifelse((trimws(as.character(dt4$Taxonomy))==trimws("No fish observed")),NA,as.character(dt4$Taxonomy)))
dt4$Total_Length <- ifelse((trimws(as.character(dt4$Total_Length))==trimws("-1")),NA,dt4$Total_Length)               
suppressWarnings(dt4$Total_Length <- ifelse(!is.na(as.numeric("-1")) & (trimws(as.character(dt4$Total_Length))==as.character(as.numeric("-1"))),NA,dt4$Total_Length))
dt4$Length_Anomaly <- as.factor(ifelse((trimws(as.character(dt4$Length_Anomaly))==trimws("na")),NA,as.character(dt4$Length_Anomaly)))
dt4$Biomass <- ifelse((trimws(as.character(dt4$Biomass))==trimws("-1")),NA,dt4$Biomass)               
suppressWarnings(dt4$Biomass <- ifelse(!is.na(as.numeric("-1")) & (trimws(as.character(dt4$Biomass))==as.character(as.numeric("-1"))),NA,dt4$Biomass))
dt4$Coarse_Trophic <- as.factor(ifelse((trimws(as.character(dt4$Coarse_Trophic))==trimws("na")),NA,as.character(dt4$Coarse_Trophic)))
dt4$Fine_Trophic <- as.factor(ifelse((trimws(as.character(dt4$Fine_Trophic))==trimws("na")),NA,as.character(dt4$Fine_Trophic)))
dt4$Visibility <- ifelse((trimws(as.character(dt4$Visibility))==trimws("-1")),NA,dt4$Visibility)               
suppressWarnings(dt4$Visibility <- ifelse(!is.na(as.numeric("-1")) & (trimws(as.character(dt4$Visibility))==as.character(as.numeric("-1"))),NA,dt4$Visibility))


# Here is the structure of the input data frame:
str(dt4)                            
attach(dt4)                            
# The analyses below are basic descriptions of the variables. After testing, they should be replaced.                 

summary(Year)
summary(Date)
summary(Start_time)
summary(End_time)
summary(Location)
summary(Site)
summary(Habitat)
summary(Transect)
summary(Transect_Width)
summary(Taxonomy)
summary(Family)
summary(Fish_Count)
summary(Total_Length)
summary(Length_Anomaly)
summary(Biomass)
summary(Coarse_Trophic)
summary(Fine_Trophic)
summary(Cloud_Cover)
summary(Wind_Velocity)
summary(Sea_State)
summary(Swell)
summary(Visibility)
summary(Surge)
summary(Diver) 
# Get more details on character variables

summary(as.factor(dt4$Start_time)) 
summary(as.factor(dt4$End_time)) 
summary(as.factor(dt4$Location)) 
summary(as.factor(dt4$Site)) 
summary(as.factor(dt4$Habitat)) 
summary(as.factor(dt4$Transect)) 
summary(as.factor(dt4$Taxonomy)) 
summary(as.factor(dt4$Family)) 
summary(as.factor(dt4$Length_Anomaly)) 
summary(as.factor(dt4$Coarse_Trophic)) 
summary(as.factor(dt4$Fine_Trophic)) 
summary(as.factor(dt4$Wind_Velocity)) 
summary(as.factor(dt4$Sea_State)) 
summary(as.factor(dt4$Diver))
detach(dt4)               

write.csv(dt1, "data/fish_annual.csv")



