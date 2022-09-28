#libaries
library("readxl")
library(TwoWayFEWeights)
library(DIDmultiplegt)
library(dplyr)
library(ggplot2)


###################################








####################################
########------Plots--------#########
####################################


# calculating mean professional career using the dataset of model 3 (Exit Model)
df_m3 <- read_excel("C:\\Users\\aedan\\OneDrive\\Uni\\Masters\\Barcelona\\Thesis\\Gaming\\Esports\\Data\\Regressions\\Survival Model\\Exit Model\\dataset_C_4_exit.xlsx")

avg_career_length <- (mean(df_m3$played)*4900)/1198     # 4900 obs and 1198 individual players

# bar plot showing distribution of players career length
splits_played <- df_m3 %>%
  count(id)

counts <- table(splits_played$n)

barplot(counts, main = "distribution of players career length", xlab = "number of splits played") 


# same bar plot as above using ggplot 2
ggplot(data = splits_played, aes(x=n)) +
  geom_bar(stat = "count", fill = "steelblue") +
  theme_minimal()

ggplot(data = splits_played , aes(x=n))+
  geom_histogram(binwidth = 1, fill = "steelblue", colour = "black") +
  theme_minimal()





# Standard Deviation of Wins
rm(list = ls())

# data
df_main <- read_excel("C:\\Users\\aedan\\OneDrive\\Uni\\Masters\\Barcelona\\Thesis\\Gaming\\Esports\\Data\\Regressions\\Survival Model\\dataset_C_4_bday.xlsx")

df_4 <- subset(df_main, GP >= 1)

# creating a subset of df_4 for clarity
df_4_sub_0 <- subset(df_4, select = c("id", "hy", "franchise", "Region", "region_n", "WR", "eligible"))


# defining dependent variable: Standard deviation of Wins across seasons per year
df_4_sub <- df_4_sub_0 %>% 
  group_by(hy, Region) %>%
  mutate(SDW = sd(WR, na.rm = TRUE),
         treatment_date = ifelse(2018, hy == 2018-01-01 & Region == "NA", 0)) # need to work on this to create a 
# treatment vertical x axis in my grid plot

# removing df_main to clear things up and remove ambiguity
rm(df_main, df_4_sub_0, df_4)

ggplot(data = df_4_sub, aes(x = hy, y = SDW)) + 
  geom_line(stat = "identity", aes(group = Region))

# all SDW in one graph
ggplot(df_4_sub) + 
  geom_line(aes(hy, SDW, group = Region, colour = Region)) +
  
  
# SDW all in one grid by region (work in this with vertical treatment variables)
ggplot(df_4_sub, aes(hy, SDW)) + 
  geom_line() +
  facet_grid(~ Region)



# vline gives me a vertical line for the treatment timing  
ggplot(df_4_sub, aes(hy, SDW)) +
  geom_line() +
  geom_vline(xintercept = as.POSIXct(as.Date("2020-11-20")), 
             color = "red", 
             lwd = 2)







#####################################
#######------Regressions------#######
#####################################


#Import data that has been reshaped in Stata and attach

df_main <- read_excel("C:\\Users\\aedan\\OneDrive\\Uni\\Masters\\Barcelona\\Thesis\\Gaming\\Esports\\Data\\Regressions\\Survival Model\\dataset_C_4_bday.xlsx")
attach(df_main) #accesses my variables of the df



# Model 1, Probability of Competing

Y = "played"
G = "id"
T = "hy"
D = "franchise"

#calculating weights attached to my DiD analysis
twowayfeweights(df_main, Y, G, T, D, cmd_type = "feTR")

#Did analysis: Model 1, Probability of Competing
did_multiplegt(df_main, Y, G, T, D)

#dynamic effects

placebo = 4
dynamic = 4

#did_multiplegt(df_main, Y, G, T, D, placebo = placebo, dynamic = dynamic, brep = 50, cluster = G) 
#breps 50 takes very long
model_1 <- did_multiplegt(df_main, Y, G, T, D, placebo = placebo, dynamic = dynamic, brep = 2, cluster = G) 









# Model 2, Probability of Entering

rm(list = ls())

#data
df_m2 <- read_excel("C:\\Users\\aedan\\OneDrive\\Uni\\Masters\\Barcelona\\Thesis\\Gaming\\Esports\\Data\\Regressions\\Survival Model\\Entry Model\\dataset_C_4_entry.xlsx")

#defining variables
Y_2 = "entry"
G_2 = "id" 
T_2 = "hy"
D_2 = "franchise"

placebo = 4
dynamic = 4

#regression
model_2 <- did_multiplegt(df_m2, Y_2, G_2, T_2, D_2, placebo = placebo, dynamic = dynamic, brep = 2, cluster = "id")







#Model 3, Probability of Exit

rm(list = ls())

#data
df_m3 <- read_excel("C:\\Users\\aedan\\OneDrive\\Uni\\Masters\\Barcelona\\Thesis\\Gaming\\Esports\\Data\\Regressions\\Survival Model\\Exit Model\\dataset_C_4_exit.xlsx")

#defining variables
Y_3 = "exit"
G_3 = "id" 
T_3 = "hy"
D_3 = "franchise"

placebo = 4
dynamic = 4

#regression
model_3 <- did_multiplegt(df_m3, Y_3, G_3, T_3, D_3, placebo = placebo, dynamic = dynamic, brep = 2, cluster = G_3)









# Model 4, Effect on Competitive Balance

rm(list = ls())

#date
df_main <- read_excel("C:\\Users\\aedan\\OneDrive\\Uni\\Masters\\Barcelona\\Thesis\\Gaming\\Esports\\Data\\Regressions\\Survival Model\\dataset_C_4_bday.xlsx")

df_4 <- subset(df_main, GP >= 1)

# creating a subset of df_4 for clarity
df_4_sub_0 <- subset(df_4, select = c("id", "hy", "franchise", "Region", "region_n", "WR", "eligible"))


# defining dependent variable: Standard deviation of Wins across seasons per year
df_4_sub <- df_4_sub_0 %>% 
  group_by(hy, Region) %>%
  mutate(SDW = sd(WR, na.rm = TRUE))

# removing df_main to clear things up and remove ambiguity
rm(df_main, df_4_sub_0, df_4)


Y_4 = "SDW"
G_4 = "id" 
T_4 = "hy"
D_4 = "franchise"

placebo = 4
dynamic = 4

model_4 <- did_multiplegt(df_4_sub, Y_4, G_4, T_4, D_4, placebo = placebo, dynamic = dynamic, brep = 2, cluster = G_4)













