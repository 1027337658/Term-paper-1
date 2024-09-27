#### Preamble ####
# Purpose: Simulates data for Toronto Beaches Observations [...UPDATE THIS...]
# Author: Yuanting Han [...UPDATE THIS...]
# Date: 26 September 2024 [...UPDATE THIS...]
# Contact: yuanting.han@mail.utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: n/a[...UPDATE THIS...]
# Any other information needed? n/a[...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(opendatatoronto)
library(ggplot2)

data_package <- show_package("toronto-beaches-observations")
data_resources <- list_package_resources("toronto-beaches-observations")
datastore_resources <- filter(data_resources, tolower(format) %in% c('csv'))
data <- filter(datastore_resources, row_number()==1) %>% get_resource()
write.csv(data, "raw_data.csv")
data1 <- data %>%
  select(-"_id", -"airTemp", -"rain", -"rainAmount", -"waveAction")
data1 <- data1 %>%
  filter(!is.na(waterFowl) & !is.na(turbidity) & waterTemp >= 0 & waterTemp <= 50) 
write.csv(data1, "analysis_data.csv")

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
ggplot(data1, aes(x = dataCollectionDate, y = waterFowl, color = beachName)) +
  geom_point(size = 3) +  
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") + 
  labs(x = "Sampling Date", y = "WaterFowl Count", title = "WaterFowl Count Over Time by Beach") +
  theme_minimal() +  
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  
ggsave("data_waterfowl.png",  width = 30, height = 15, units = "cm", dpi = 300)

waterFowl_turbidity <- cor.test(data1$waterFowl, data1$turbidity, method = "pearson")
print(waterFowl_turbidity)

ggplot(data1, aes(x = turbidity, y = waterFowl)) +
  geom_point(color = "green", size = 3) + 
  geom_smooth(method = "lm", color = "red", se =T) +  
  labs(x = "Turbidity", y = "WaterFowl Count", title = "WaterFowl Count vs Turbidity") +
  theme_minimal() + 
  annotate("text", x = Inf, y = Inf, label = paste("R = 0.04","p<0.05"),
           hjust = 1, vjust = 1, size = 5, color = "black") 
ggsave("waterFowl_turbidity.png",  width = 30, height = 15, units = "cm", dpi = 300)

average_waterfowl <- data1 %>%
  group_by(beachName) %>%
  summarise(avg_waterFowl = mean(waterFowl, na.rm = TRUE))
ggplot(average_waterfowl, aes(x = beachName, y = avg_waterFowl, group = 1)) +
  geom_line(color = "blue", size = 1) +  
  geom_point(color = "red", size = 3) +  
  labs(x = "beachName", y = "waterFowl_avg") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  
ggsave("beach_waterfowl.png",  width = 30, height = 15, units = "cm", dpi = 300)


avg_waterTemp <- data1 %>%
  group_by(beachName) %>%
  summarise(mean_waterTemp = mean(waterTemp, na.rm = TRUE))
ggplot(avg_waterTemp, aes(x = beachName, y = mean_waterTemp)) +
  geom_point(color = "blue", size = 3) +  
  labs(
    x = "beachName",
    y = "avg_waterTemp (°C)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  
ggsave("beach_watertemp.png",  width = 30, height = 15, units = "cm", dpi = 300)


ggplot(data1, aes(x = waterTemp, y = waterFowl)) +
  geom_point(color = "blue", size = 3) +  
  geom_smooth(method = "lm", color = "red", se = T) + 
  labs( x = "Temp (°C)",
        y = "waterFowl") +
  theme_minimal()
ggsave("waterfowl_watertemp.png",  width = 30, height = 15, units = "cm", dpi = 300)

