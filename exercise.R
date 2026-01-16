# loading necessary library
# dplyr for data manipulation and
# ggplot2 for data visualization
library(dplyr)
library(ggplot2)

# defining path to the dataset
path <- "C:/Users/DELL/Documents/Ice_detention_data_analysis/data/messy_ice_detention.csv"

# loading the csv file
# here we skip the first 6 rows from our csv file and
# na.strings handles different representations of missing values
df <- read.csv(path, skip=6, na.strings = c("", "NA", "N/A", "n/a", "na", " "))

# lets first check the structure of our dataset
str(df)


# Last.Inspection.End.Date is character type 
# changed the chr type into numeric type and
# and finally convert to standard date type
# and for this date part, taken help from chatgpt and here's the prompt link
# link: ""

df$Last.Inspection.End.Date <- as.numeric(df$Last.Inspection.End.Date) # convert to numeric

df_clean <- df %>%
  mutate(
    Last.Inspection.End.Date = as.Date(Last.Inspection.End.Date, origin = "1899-12-30")
  )

# checking the count of null values in columns
colSums(is.na(df_clean))

# Cleaning the Name column
# 2 missing values 
# searched in google with the help of state and city name and verified in ICE
# manually filled
df_clean$Name[df$City == "DOVER" & df$State == "NH"] <- "Strafford County Jail"
df_clean$Name[df$City == "ELK RIVER" & df$State == "MN"] <- "Sherburne County Jail"

# then Name column is transformed to remove the unnecessary characters
# Name column contained non-ASCII characters (like smart spaces, special Unicode symbols, or invisible characters)
# Used iconv() to convert all text to UTF-8 and replace invalid char with space " "
# taken help from chatgpt prompt link is the same: 
df_clean <- df_clean %>%
  mutate(Name = iconv(Name, from = "", to = "UTF-8", sub = " "),
         Name = gsub("[^A-Za-z ]", "", Name)
  )

# Manually filling the missing city
df_clean$City[df_clean$Name == "GEAUGA COUNTY JAIL" & df_clean$State == "OH"] <- "Chardon"

# manually filling the states
df_clean$State[df_clean$Name == "ATLANTA US PEN"] <- "GA" #Georgia
df_clean$State[df_clean$Name == "LA SALLE COUNTY REGIONAL DETENTIO[N CENTER"] <- "TX"  #texas

#final checking of missing values
colSums(is.na(df_clean))
# only the date part is missing 
# since it is a date which cannot be filled in random, and it doesn't contribute to our final top 19 data so I decided to leave it empty with NA


# created new column 'population': total of level A to D
df_clean <- df_clean %>%
  mutate(population = Level.A + Level.B + Level.C + Level.D) %>%
  arrange(desc(population))

# Selected only top ten facilities Name and population 
df_top_10 <- df_clean %>%
  select(Name, population) %>%
  slice_head(n=10)

# Visualization
# Plotted a horizontal bar graph with respective data labels

ggplot(df_top_10, aes(x = reorder(Name, population), y = population)) +
  geom_bar(stat = "identity", fill = "steelblue") + 
  geom_text(aes(label = population),
            hjust= 1,
            size = 3.5) +
  coord_flip() + 
  labs(
    title = "Top 10 Largest Detention Facilities",
    x = "Facility Name",
    y = "Total Average Population"
  ) + 
  theme_minimal()