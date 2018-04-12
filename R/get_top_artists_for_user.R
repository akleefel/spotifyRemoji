get_top_artists_for_user <- function(user_auth_token, limit_num, time_range_opt) {

  base_url <- "https://api.spotify.com"
  instruction <-  "me/top" #"authorize"
  artist <- paste0("q=", "muse")
  type <- paste0("artists")
  limit <- glue("&limit=",limit_num)
  time_range_options = c("long_term", "medium_term", "short_term")
  time_range <- glue("time_range=", time_range_options[2])
  
  # Where:
  ## `long_term` is last several years of data
  ## `medium_term` is last 6 months
  ## `short_term` last 4 weeks  
  
  auth_token <- user_auth_token
  
  header_auth <- add_headers(c(Authorization = glue("Bearer ", auth_token)))
  
  request <- glue(base_url, "/v1", "/", 
                  "{instruction}","/",
                  "{type}", 
                  "?", 
                  time_range, 
                  limit)
  
  json_obj <- GET(request, 
      add_headers(c(Authorization = glue("Bearer ", auth_token))))
  
  df_obj <- fromJSON(json_obj %>% content("text")) %>% 
    .$items %>% 
    flatten() %>% 
    select(name, popularity, genres, followers.total) %>% 
    rename(followers = "followers.total")
  df_obj

}