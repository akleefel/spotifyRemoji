
## This function takes in a user authentication token and three artists, and returns a ggplot showing
## the popularity (out of 100) and the genre of each artist respectively.


artist_popularity <- function(user_auth_token, artist1, artist2, artist3){

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

  # artist 3 GET
  artistName3 = artist3

  URI3 <-paste0('https://api.spotify.com/v1/search?query=',artistName3,'&offset=0&limit=20&type=artist')
  response3 <-  GET(url = URI3, add_headers(Authorization = HeaderValue))
  Artist3 <-  content(response3)

  pop <- c(Artist1$artists$items[[1]]$popularity,
           Artist2$artists$items[[1]]$popularity,
           Artist3$artists$items[[1]]$popularity)

  genre <- c(Artist1$artists$items[[1]]$genres[[1]],
             Artist2$artists$items[[1]]$genres[[1]],
             Artist3$artists$items[[1]]$genres[[1]])

  artist_name <- c(Artist1$artists$items[[1]]$name,
                   Artist2$artists$items[[1]]$name,
                   Artist3$artists$items[[1]]$name)

  artist_df <- data.frame(artist_name, pop, genre)

  ggplot(artist_df, aes(artist_name, pop)) +
    geom_col(fill = "#1ED760") +
    geom_text(aes(label=genre), position = position_stack(vjust = 0.5), colour="white", size=7) +
    theme(panel.background = element_rect(fill = "black"),
          plot.background = element_rect(fill = "black"),
          axis.title.x = element_text(colour = "white"),
          axis.title.y = element_text(colour = "white"),
          axis.text.x = element_text(colour = "white"),
          axis.text.y = element_text(colour = "white"),
          panel.grid = element_blank(),
          panel.border = element_blank()) +
    labs(x = "Artist", y = "Popularity")
}

