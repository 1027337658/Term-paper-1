#### Preamble ####
# Purpose: Downloads and saves the data from Toronto Beaches Observations [...UPDATE THIS...]
# Author: Yuanting Han [...UPDATE THIS...]
# Date: 26 September 2024 [...UPDATE THIS...]
# Contact: yuanting.han@mail.utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: n/a[...UPDATE THIS...]
# Any other information needed?  n/a [...UPDATE THIS...]


#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)
# [...UPDATE THIS...]

#### Download data ####

data_package <- show_package("toronto-beaches-observations")
data_resources <- list_package_resources("toronto-beaches-observations")
datastore_resources <- filter(data_resources, tolower(format) %in% c('csv'))


#### Save data ####
# [...UPDATE THIS...]
# change the_raw_data to whatever name you assigned when you downloaded it.
write.csv(data, "raw_data.csv")

         
