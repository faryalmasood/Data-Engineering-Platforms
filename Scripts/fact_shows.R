#clean data before putting into MySQL
library(readr)
library(dplyr)
raw_netflix <- read_csv("/Users/abhiniti/OneDrive - The University of Chicago/Spring 2020/Data Engineering Platforms - MSCA 31012/Final Project/Netflix/Step 2 Data Storage/raw_netflix.csv")

final <- raw_netflix %>% select(-title_id,-director_id,-cast_id,-country_id,-listed_in_id,category=listed_in,-imdb_rating)
table(final$duration)
final$duration <- gsub("min", "", final$duration)
final$duration <- gsub("Seasons", "", final$duration)
final$duration <- gsub("Season", "", final$duration)

sum(is.na(final$duration)) #39805

final$duration <- as.integer(final$duration)

#fact_records
#join reviews 
reviews <- read_csv("/Users/abhiniti/OneDrive - The University of Chicago/Spring 2020/Data Engineering Platforms - MSCA 31012/Final Project/Netflix/Step 2 Data Storage/reviews.csv")
sum(is.na(reviews$imdb_user_review))

#reviews
reviews$title <- tolower(reviews$title)
reviews1 <- reviews %>% group_by(title) %>% summarise(imdb_user_review=max(imdb_user_review,na.rm=T),
                                                      imdb_critic_review=max(imdb_critic_review,na.rm=T),
                                                      tomato_critic_review=max(tomato_critic_review,na.rm=T),
                                                      tomato_user_review=max(tomato_user_review,na.rm=T))

#dim_show
dim_show <- final %>% select(show_id) %>% distinct() 
dim_show <- left_join(dim_show,final %>% select(show_id,title,description) %>% filter(is.na(description)==FALSE))

final_test <- dim_show
final_test$title  <- tolower(final_test$title)
final_test1 <- left_join(final_test,reviews1)

#join all
needed_facts <- final
needed_facts$date_added <- as.Date(needed_facts$date_added, "%b %d,%Y",na.rm=T)
needed_facts <- needed_facts %>% select(show_id, type, date_added, release_year, duration, rating) %>% distinct()
needed_facts <- needed_facts %>% group_by(show_id) %>% summarise(type=max(type,na.rm = T),
                                                                 date_added=max(date_added,na.rm = T),
                                                                 release_year=max(release_year,na.rm = T),
                                                                 duration=max(duration,na.rm = T),
                                                                 rating=max(rating,na.rm = T))

fact_records <- left_join(final_test1, needed_facts)

#dim_type
dim_type <- final %>% select(type) %>% distinct()
id <- 1:(nrow(dim_type))
dim_type <- cbind(type_id=id, dim_type)
#dim_date_added
dim_date_added <- final %>% select(date_added) %>% distinct() %>% filter(is.na(date_added)==FALSE)
dim_date_added$date_added <- as.Date(dim_date_added$date_added, "%b %d,%Y")
id <- 1:(nrow(dim_date_added))
dim_date_added <- cbind(date_added_id=id, dim_date_added)
#dim_release_year
dim_release_year <- final %>% select(release_year) %>% distinct() %>% filter(is.na(release_year)==FALSE)
id <- 1:(nrow(dim_release_year))
dim_release_year <- cbind(release_year_id=id, dim_release_year)
#dim_rating
dim_rating <- final %>% select(rating) %>% distinct() %>% filter(is.na(rating)==FALSE)
id <- 1:(nrow(dim_rating))
dim_rating <- cbind(rating_id=id, dim_rating)

#join for ids
fact_records <- left_join(fact_records,dim_type)
fact_records <- left_join(fact_records,dim_date_added)
fact_records <- left_join(fact_records,dim_release_year)
fact_records <- left_join(fact_records,dim_rating)

#create fact table
fact_records <- fact_records %>% select(show_id,type_id,date_added_id,release_year_id,rating_id, duration, imdb_user_review, imdb_critic_review, rt_user_review=tomato_user_review, rt_critic_review=tomato_critic_review, title, description)

id <- 1:(nrow(fact_records))
fact_records <- cbind(record_id=id, fact_records)

test <- fact_records

#imdb user
test$imdb_user_review <- case_when(
  test$imdb_user_review=="N/A" | is.na(test$imdb_user_review)==TRUE ~ -999,
  TRUE ~ test$imdb_user_review)

sum(is.na(fact_records$imdb_user_review))
sum(is.na(test$imdb_user_review))
test %>% select(imdb_user_review) %>% filter(imdb_user_review==-999) %>% tally()

#imdb critic
test$imdb_critic_review <- case_when(
  test$imdb_critic_review=="N/A" | is.na(test$imdb_critic_review)==TRUE ~ "-999",
  TRUE ~ test$imdb_critic_review)

sum(is.na(fact_records$imdb_critic_review))
fact_records %>% select(imdb_critic_review) %>% filter(imdb_critic_review=="N/A") %>% tally()
sum(is.na(test$imdb_critic_review))
test %>% select(imdb_critic_review) %>% filter(imdb_critic_review=="-999") %>% tally()

#rotten tomatoes user
test$rt_user_review <- case_when(
  test$rt_user_review=="N/A" | is.na(test$rt_user_review)==TRUE ~ "-999",
  TRUE ~ test$rt_user_review)

sum(is.na(fact_records$rt_user_review))
fact_records %>% select(rt_user_review) %>% filter(rt_user_review=="N/A") %>% tally()
sum(is.na(test$rt_user_review))
test %>% select(rt_user_review) %>% filter(rt_user_review=="-999") %>% tally()

#rotten tomatoes critic 
test$rt_critic_review <- case_when(
  test$rt_critic_review=="N/A" | is.na(test$rt_critic_review)==TRUE ~ "-999",
  TRUE ~ test$rt_critic_review)

sum(is.na(fact_records$rt_critic_review))
fact_records %>% select(rt_critic_review) %>% filter(rt_critic_review=="N/A") %>% tally()
sum(is.na(test$rt_critic_review))
test %>% select(rt_critic_review) %>% filter(rt_critic_review=="-999") %>% tally()

#how many are NA?
test %>% select(imdb_user_review) %>% filter(imdb_user_review==-999) %>% tally()
test %>% select(imdb_critic_review) %>% filter(imdb_critic_review=="-999") %>% tally()
test %>% select(rt_user_review) %>% filter(rt_user_review=="-999") %>% tally()
test %>% select(rt_critic_review) %>% filter(rt_critic_review=="-999") %>% tally()

test %>% select(show_id) %>% distinct() %>% tally()

### FINAL FILE = test

write_csv(test,"/Users/abhiniti/OneDrive - The University of Chicago/Spring 2020/Data Engineering Platforms - MSCA 31012/Final Project/Netflix/Step 2 Data Storage/dim_tables/fact_records.csv")