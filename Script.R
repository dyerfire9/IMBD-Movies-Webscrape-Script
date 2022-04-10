library(rvest)
library(dplyr)

# Website we want to scrape
link <- "https://www.imdb.com/search/title/?genres=horror&sort=num_votes,desc&explore=title_type,genres"

# website in html code
# Given a url, it returns an html document
page <- read_html(link)

# download selector gadget chrome extension
# html_nodes() - Gets the data from the specified html tag(s).
# Then we call
# html_text() - Parses (extract) the text from the tags returned from html_nodes.

# Get horror movie name, release year, and rating and synopsis
name <- page %>%  html_nodes(".lister-item-header a") %>%  html_text()
year <- page %>%  html_nodes(".text-muted.unbold") %>% html_text() 
rating <- page %>%  html_nodes(".ratings-imdb-rating strong") %>% html_text() 
synopsis <- page %>% html_nodes(".ratings-bar+ .text-muted") %>% html_text()

# Get the movie page links on IMBD
# Links will need to be parsed through the - html_attr("href") function and then
# html_attr("href") - will return the movie link (not the including base site Eg: www.imdb.com)
# paste() - concatenates strings together - we concatenate the base imdb website + movie_url
# The '.' tells the function that the 1st arg will be the 2nd arg
# PASTE BY DEFAULT ADDS SPACE IN BETWEEN SO ADD SEP = "" OR paste0()
movies_link <- page %>%  html_nodes(".lister-item-header a") %>% html_attr("href") %>% paste("https://www.imdb.com/", ., sep = "")

# We will get the cast members
# we create a function which takes in a movie link and scrapes the cast members
get_cast <- function(movies_link) {
  movie_page <- read_html(movies_link)
  movie_cast <- movie_page 
  # Did not finsh it
}

# stringsAsFactors = FALSE - Makes all columns into factors
movies <- data.frame("Movie name" = name, "year" = year, "Rating" = rating, "Synopsis" = synopsis)


# Scrape Multiple Pages
# Figure out how the url changes
horror_movies = data.frame()

# We scraped 250 movies
for (page_result in seq(from = 1, to = 201, by = 50)) {
  # We need to make sure the link changes
  mlink <- paste("https://www.imdb.com/search/title/?genres=horror&sort=num_votes,desc&start=", page_result, "&explore=title_type,genres&ref_=adv_nxt", sep = "")
  page <- read_html(mlink)
  
  name <- page %>%  html_nodes(".lister-item-header a") %>%  html_text()
  year <- page %>%  html_nodes(".text-muted.unbold") %>% html_text() 
  rating <- page %>%  html_nodes(".ratings-imdb-rating strong") %>% html_text() 
  synopsis <- page %>% html_nodes(".ratings-bar+ .text-muted") %>% html_text()
  
  movies_link <- page %>%  html_nodes(".lister-item-header a") %>% html_attr("href") %>% paste("https://www.imdb.com/", ., sep = "")
  
  
  # horror_movies is a dataframe and everytime the loop runs, it will be reset if we put it inside it so we create a new movies dataframe
  horror_movies <- rbind(horror_movies, data.frame("Movie name" = name, "year" = year, "Rating" = rating, "Synopsis" = synopsis))
  
  # To track progress
  print(paste("Page:", page_result))
}

# To save this as a csv file, we set the working directory to our source files
# write.csv(DATAFRAME, NAME OF CSV FILE)
write.csv(horror_movies, "horror_movies.csv")



