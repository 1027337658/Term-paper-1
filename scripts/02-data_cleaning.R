#### Preamble ####
# Purpose: Cleans the raw plane data for Toronto Beaches Observations [...UPDATE THIS...]
# Author: Yuanting Han [...UPDATE THIS...]
# Date: 26 September 2024 [...UPDATE THIS...]
# Contact: yuanting.han@mail.utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(tidyverse)

#### Clean data ####data <- filter(datastore_resources, row_number()==1) %>% get_resource()
data1 <- data %>%
  select(-"_id", -"airTemp", -"rain", -"rainAmount", -"waveAction")
data1 <- data1 %>%
  filter(!is.na(waterFowl) & !is.na(turbidity) & waterTemp >= 0 & waterTemp <= 50) 


clean_table <- data1 %>%
  group_by(beachName) %>%
  summarise(
    mean_waterFowl = mean(waterFowl, na.rm = TRUE),
    median_waterFowl = median(waterFowl, na.rm = TRUE),
    max_waterFowl = max(waterFowl, na.rm = TRUE),
    min_waterFowl = min(waterFowl, na.rm = TRUE),
    
    mean_turbidity = mean(turbidity, na.rm = TRUE),
    median_turbidity = median(turbidity, na.rm = TRUE),
    max_turbidity = max(turbidity, na.rm = TRUE),
    min_turbidity = min(turbidity, na.rm = TRUE)
  )
data1$dataCollectionDate <- as.Date(data1$dataCollectionDate)

#### Save data ####
write.csv(data1, "analysis_data.csv")
