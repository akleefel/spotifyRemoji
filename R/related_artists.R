library(httr)
library(jsonlite)
library(dplyr)
library(glue)




related_artists <- function(user_auth_token, artistName){
  #' Prints dataframe of artist's related artists.
  #'
  #' @param user_auth_token: String containing the users authentication tokent. See README for details
  #' @param artistName: String specifyign an arists name
  #' @return dataframe object
  #' 
  #' @import httr
  #' @import jsonlite
  #' @import dplyr
  #' @import glue
  #' 
  #' @export
  #'
  #' @examples 
  #' 
  #' related_artists(auth, "Haftbefehl")
  #' 
  
  #replace spaces in artist name with +
  artistName <- gsub(" ", "+", artistName)
  
  #get artist ID
  artistID <- get_artistID(user_auth_token,artistName)
  
  #get related artists 
  string_related  = paste0("https://api.spotify.com/v1/artists/",artistID,"/related-artists")
  
  related_return <- GET(url = string_related, add_headers(Authorization = glue('Bearer {auth}')))
  text_content_rel <-  content(related_return, "text")
  json_content_rel <-  text_content_rel %>% fromJSON
  
  print(data.frame('Related Artists'=json_content_rel$artists$name))
}


#funciton that gets artist ID based on artist name

get_artistID <- function(user_auth_token, artistName){
  
  auth <- user_auth_token
  string_name <- paste0("https://api.spotify.com/v1/search?q=",artistName,"&type=artist")
  
  id_return <- GET(url = string_name, add_headers(Authorization = glue('Bearer {auth}')))
  
  text_content1 <-  content(id_return, "text")
  json_content1 <-  text_content1 %>% fromJSON
  
  return(json_content1$artists$items$id[1])
}




