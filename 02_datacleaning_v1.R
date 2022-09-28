
####################################################################################
###########------- Effect of franchising on competitive balance--------#############
####################################################################################
### The main goal of this thesis is to analyse how the move from a non-franchised system to a franchised system in League
### of Legends (eSports) effected:
### 1. the probability of competing
### 2. whether the probability of competing changed via new people entering or old players leaving
### 3. the effect on the competitive balance in the league


####################################################################################
### Script to clean and prepare my data sets for each of my four models


# cleaned data set imported from excel
df_main <- read_excel("dataset_C_4_bday.xlsx")

#deleted id = 11, since Player name is NA and has played no games
df_main <- df_main %>%
  filter(!is.na(Player)) %>%
  select(-(CTR:SourceName)) %>%
  select(-(prob_remain:reg_dummy4))


  

## Model 2 probability of First entering into the League: reshaping ####
## I reshape the model s.t. I include observations in which the player does not compete (0) until he first enters (1)
## Observations after first entering are excluded

df_main[9] <- NULL

## deletes observations after having first entered

df_m2 <- df_main %>% 
  group_by(id) %>% 
  filter(cumsum(cumsum(GP > 0)) < 2) %>%
  ungroup

## define "entry" = 1 if player enters and 0 otherwise
df_m2$entry <- ifelse(df_m2$GP > 0, 1, 0)


## Model 3 probability of first entering into the League: reshaping ####
## I reshape the model s.t. I delete all observations before the player has entered into the game, after having first entered 
## I keep all observations until he stops playing for the first time. 
## After having stopped playing for the first time, observations are deleted.

df_main[9] <- NULL

df_m3 <- df_main %>%
  group_by(id) %>%
  filter(cumany(GP >0)) %>%
  slice(seq_len(match(0, GP, nomatch = n()))) %>%
  ungroup

# dummy variable that shows when a player first left (dependent variable for model 3)
df_m3$exit <- ifelse(df_m3$played == 0, 1, 0)

## Model 4: Effect on the Competitive Balance: reshaping ###
## I delete all obs. in which players do not actively play and calculate the standard deviation of wins (SDW)

#only keeping the rows in which players are actively playing
df_m4 <- df_main %>%
  filter(GP>0)







