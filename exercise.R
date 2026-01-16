# loading necessary library
library(dplyr)

# defining path to the dataset
path <- "C:/Users/DELL/Documents/Ice_detention_data_analysis/data/messy_ice_detention.csv"

# loading the csv file
df <- read.csv(path, skip=6, na.strings = c("", "NA", "N/A", "n/a", "na", " "))

# Data Cleaning
# lets first check the object type of our headers
str(df)

# Last.Inspection.End.Date is character type so lets change it into numeric type
# and finally convert to standard date type

df$Last.Inspection.End.Date <- as.numeric(df$Last.Inspection.End.Date) # convert to numeric

df_clean <- df %>%
  mutate(
    Last.Inspection.End.Date = as.Date(Last.Inspection.End.Date, origin = "1899-12-30")
  )

# cleaning the name column 
#first lets fill up the missing values 
df_clean$Name[df$City == "DOVER" & df$State == "NH"] <- "Strafford County Jail"
df_clean$Name[df$City == "ELK RIVER" & df$State == "MN"] <- "Sherburne County Jail"
df_clean <- df_clean %>%
  mutate(Name = iconv(Name, from = "", to = "UTF-8", sub = " "),
         Name = gsub("[^A-Za-z ]", "", Name)
  )
colSums(is.na(df_clean))

# Manually filling the missing city
df_clean$City[df_clean$Name == "GEAUGA COUNTY JAIL" & df_clean$State == "OH"] <- "Chardon"

# manually filling the states
df_clean$State[df_clean$Name == "ATLANTA US PEN"] <- "GA" #Georgia
df_clean$State[df_clean$Name == "LA SALLE COUNTY REGIONAL DETENTIO[N CENTER"] <- "TX"  #texas

colSums(is.na(df_clean))
#finding the top 10 avg population facilities

df_clean <- df_clean %>%
  mutate(population = Level.A + Level.B + Level.C + Level.D) %>%
  arrange(desc(population))

#getting only top ten facilities 
df_top_10 <- df_clean %>%
  select(Name, population) %>%
  slice_head(n=10)

# Visualization

library(ggplot2)
