library(httr)
library(ggplot2)
library(dplyr)
library(jsonlite)

compare_artists <- function(user_auth_token, artist1, artist2){

  #artist 1 GET
  artistName1 = artist1

  HeaderValue = paste0('Bearer ', my_token)

  URI1 <-paste0('https://api.spotify.com/v1/search?query=',artistName1,'&offset=0&limit=20&type=artist')
  response1 <-  GET(url = URI1, add_headers(Authorization = HeaderValue))
  Artist1 <-  content(response1)
  Artist1$artists$items[[1]]$popularity

  # artist 2 GET
  artistName2 = artist2

  URI2 <-paste0('https://api.spotify.com/v1/search?query=',artistName2,'&offset=0&limit=20&type=artist')
  response2 <-  GET(url = URI2, add_headers(Authorization = HeaderValue))
  Artist2 <-  content(response2)
  paste(Artist1$artists$items[[1]]$popularity,Artist2$artists$items[[1]]$popularity)
}
