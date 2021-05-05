
# load libraries ----------------------------------------------------------

library(tidyverse)


# get data from low-risk players ----------------------------------------

# create an empty tibble for saving all data from low-risk players
d_low_risk <- tibble()

# get a list of all sub-folders
folders_low_risk <- list.dirs(path = "../../data/data_non_addict_players", full.names = TRUE, recursive = FALSE)

# create a progress bar
pb <- txtProgressBar(min = 0, max = length(folders_low_risk), style = 3)

# loop through the list of all sub-folders
for (i in 1:length(folders_low_risk)) {
  
  # for each folder, read the meta_data.csv file and the rounds.csv file
  folder <- folders_low_risk[i]
  
  d_meta <- read_delim(file = file.path(folder, "meta_data.csv"), delim = "\t", 
                       col_names = c("id_player", "gender", "age", "zipcode", "income"), # new column names
                       col_types = "ccccc") # for now, set all column types to characters
  
  d_rounds <- read_delim(file = file.path(folder, "rounds.csv"), delim = ";", skip = 1,
                         col_names = c("id_session", "id_round", "stake", "win", "rt_start", 
                                       "rt1", "rt2", "rt3", "rt4", "rt5", "rt6", "rt7", "rt8", "rt9", "rt10", "rt11", "rt12", "bonus"), # new column names
                         col_types = "cccccccccccccccccc") # for now, set all column types to characters
  
  # add meta_data to the rounds data
  d_rounds <- d_rounds %>%
    mutate(id_player = d_meta$id_player, gender = d_meta$gender, age = d_meta$age, zipcode = d_meta$zipcode, income = d_meta$income)
  
  # add data from one player to the tibble containing all data
  d_low_risk <- bind_rows(d_low_risk,  d_rounds)
  
  # set progress bar
  setTxtProgressBar(pb, i)
  
}

# close progress bar
close(pb)

# get data from high-risk players --------------------------------------------

# create an empty tibble for saving all data from high_risk players
d_high_risk <- tibble()

# get a list of all sub-folders
folders_high_risk <- list.dirs(path = "../../data/data_addict_players", full.names = TRUE, recursive = FALSE)

# create a progress bar
pb <- txtProgressBar(min = 0, max = length(folders_high_risk), style = 3)

# loop through the list of all sub-folders
for (i in 1:length(folders_high_risk)) {
  
  # for each folder (player), read the meta_data.csv file
  folder <- folders_high_risk[i]
  
  d_meta <- read_delim(file = file.path(folder, "meta_data.csv"), delim = "\t", 
                       col_names = c("id_player", "gender", "age", "zipcode", "income"), # new column names
                       col_types = "ccccc") # for now, set all column types to characters
  
  # each addict player has one or more files for different levels, get all files
  file_all_levels <- list.files(path = folder, pattern = "rounds")
  
  d_rounds <- tibble() # an empty tibble for saving all rounds data for one player
  
  # loop through the list of all files containing rounds data
  for (file_one_level in file_all_levels) {
    
    # read data from one level
    d_rounds_one_level <- read_delim(file = file.path(folder, file_one_level), delim = ";", skip = 1,
                                     col_names = c("id_session", "id_round", "stake", "win", "rt_start", 
                                                   "rt1", "rt2", "rt3", "rt4", "rt5", "rt6", "rt7", "rt8", "rt9", "rt10", "rt11", "rt12", "bonus"), # new column names
                                     col_types = "cccccccccccccccccc") # for now, set all column types to characters
    
    # extract the level info from file name and add to data
    level <- str_sub(file_one_level, start = -5, end = -5) 
    d_rounds_one_level$level <- level
    
    # add data from one level to the overall data of one player
    d_rounds <- bind_rows(d_rounds, d_rounds_one_level)
    
  }
  
  # add meta_data to the rounds data
  d_rounds <- d_rounds %>%
    mutate(id_player = d_meta$id_player, gender = d_meta$gender, age = d_meta$age, zipcode = d_meta$zipcode, income = d_meta$income)
  
  # add data from one player to the tibble containing all data
  d_high_risk <- bind_rows(d_high_risk, d_rounds)
  
  # set progress bar
  setTxtProgressBar(pb, i)
  
}

# close progress bar
close(pb)


# clean data from low-risk players --------------------------------------

# some variables contain spaces, remove all spaces
str_remove_spaces <- function(string_vector){
  str_remove_all(string_vector, "\\ ")
}

d_low_risk <- d_low_risk %>%
  mutate_all(str_remove_spaces)

# change player id, session id and round id into integers
d_low_risk <- d_low_risk %>%
  # each player gets an unique number, starting from 1
  mutate(id_player = match(id_player, unique(id_player))) %>%
  # within each player, each session gets an unique number, starting from 1 
  group_by(id_player) %>%
  mutate(id_session = match(id_session, unique(id_session))) %>%
  # each round within each session gets an unique number, starting from 1
  group_by(id_player, id_session) %>%
  mutate(id_round = row_number()) %>%
  ungroup()

# check the unique values of variables stake, win and bonus
unique(d_low_risk$stake)
unique(d_low_risk$win)
unique(d_low_risk$bonus)

# turn stake, win, bonus, and income into numeric variables
d_low_risk <- d_low_risk %>%
  mutate(income = recode(income, "N/A" = NA_character_)) %>% # some players do not have income info ("N/A" in the data); replace it with NA
  mutate_at(c("stake", "win", "age", "income"), as.numeric)

# check if all rt variables contain only numbers
all_numbers <- function(string_vector){
  all(str_detect(string_vector, "^[0-9]*$"))
}

d_low_risk %>%
  select(contains("rt")) %>%
  map_lgl(all_numbers)

# rt1 and rt9 have rows that contain non-numeric characters
rt1_non_num <- d_low_risk %>%
  filter(!str_detect(rt1, "^[0-9]*$"))

# the first round in each session has 0 for start rt, and a comma within rt1

rt9_non_num <- d_low_risk %>%
  filter(!str_detect(rt9, "^[0-9]*$"))

# one row has negative value for rt9

# turn all rt data into numeric
d_low_risk <- d_low_risk %>%
  mutate(rt1 = str_replace(rt1, ",", ".")) %>% # replace comma with decimal point
  mutate_at(vars(contains("rt")), as.numeric)


# create new variables for the stake, win, and whether there is bonus or not on the previous round
d_low_risk <- d_low_risk %>%
  group_by(id_player, id_session) %>%
  mutate(
    prev_stake = lag(stake),
    prev_win = lag(win),
    prev_bonus = lag(bonus)
  ) %>%
  ungroup() %>%
  select(id_player, everything()) # put player id in the first column



# clean data from high-risk players ------------------------------------------

# some variables contain spaces, remove all spaces
d_high_risk <- d_high_risk %>%
  mutate_all(str_remove_spaces)

# change player id, session id and round id into integers
d_high_risk <- d_high_risk %>%
  # each player gets an unique number, starting from 1
  mutate(id_player = match(id_player, unique(id_player))) %>%
  # within each player, each session gets an unique number, starting from 1 
  group_by(id_player) %>%
  mutate(id_session = match(id_session, unique(id_session))) %>%
  # each round within each session gets an unique number, starting from 1
  group_by(id_player, id_session) %>%
  mutate(id_round = row_number()) %>%
  ungroup()

# check the unique values of variables stake, win and bonus
unique(d_high_risk$stake)
unique(d_high_risk$win)
unique(d_high_risk$bonus)

# turn stake, win, bonus, income and level into numeric variables
d_high_risk <- d_high_risk %>%
  mutate(income = recode(income, "N/A" = NA_character_)) %>% # some players do not have income info ("N/A" in the data); replace it with NA
  mutate_at(c("stake", "win", "age", "income", "level"), as.numeric)

# check if all rt variables contain only numbers
d_high_risk %>%
  select(contains("rt")) %>%
  map_lgl(all_numbers)

# rt1, rt2, rt3, rt7, rt8, rt10 and rt11 have rows that contain non-numeric characters
# for rt1, this is again because the first round contains a comma
# for the rest, it's because one round contains negative values
rt1_non_num <- d_high_risk %>%
  filter(!str_detect(rt1, "^[0-9]*$"))

rt2_non_num <- d_high_risk %>%
  filter(!str_detect(rt2, "^[0-9]*$"))

rt3_non_num <- d_high_risk %>%
  filter(!str_detect(rt3, "^[0-9]*$"))

rt7_non_num <- d_high_risk %>%
  filter(!str_detect(rt7, "^[0-9]*$"))

rt8_non_num <- d_high_risk %>%
  filter(!str_detect(rt8, "^[0-9]*$"))

rt10_non_num <- d_high_risk %>%
  filter(!str_detect(rt10, "^[0-9]*$"))

rt11_non_num <- d_high_risk %>%
  filter(!str_detect(rt11, "^[0-9]*$"))

# turn all rt data into numeric
d_high_risk <- d_high_risk %>%
  mutate(rt1 = str_replace(rt1, ",", ".")) %>% # replace comma with decimal point
  mutate_at(vars(contains("rt")), as.numeric)

# create new variables for the stake, win, and whether there is bonus or not on the previous round
d_high_risk <- d_high_risk %>%
  group_by(id_player, id_session) %>%
  mutate(
    prev_stake = lag(stake),
    prev_win = lag(win),
    prev_bonus = lag(bonus)
  ) %>%
  ungroup() %>%
  select(id_player, everything()) # put player id in the first column

# save data ---------------------------------------------------------------


if (!dir.exists("../../data/processed")){
  dir.create("../../data/processed")
}

save(d_low_risk, file = "../../data/processed/d_low_risk.RData")
save(d_high_risk, file = "../../data/processed/d_high_risk.RData")
