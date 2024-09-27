#### Preamble ####
# Purpose: Tests for Toronto Beaches Observations [...UPDATE THIS...]
# Author: Yuanting Han [...UPDATE THIS...]
# Date: 26 September 2024 [...UPDATE THIS...]
# Contact: yuanting.han@mail.utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(ggplot2)
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

