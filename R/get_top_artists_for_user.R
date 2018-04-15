#' get_top_artists_for_user: Finds a users top artists over an input time range. Returns a dataframe containing summary information on each artist.
#' @importFrom glue httr jsonlite dplyr
#'
#' @param user_auth_token: a string corresponding to a valid Spotify API user authentication token
#' @param limit_num: an integer between 1 and 50 (inclusive)
#' @param time_range_opt: an integer, either 1,2 or 3.
#'      1 = `long_term` is last several years of data
#'      2 = `medium_term` is last 6 months
#'      3 = `short_term` last 4 weeks
#'
#' @return a dataframe of artist name, popularity, genres, and followers
#'      name = character
#'      popularity = integer between 1 and 100 corresponding to popularity
#'      genres = character vector of genres associated with artists
#'      followers = integer of number of followers of artist
#'
#' @export
#'
#' @examples
#' my_auth_token <- "BQDk6Yebn4V94Cbd121Rs73_q4Vtx1WotIX7o3spa5THlzfZi1pQn-jywCkz2XNld5Pa1H3jxo7EGL8JZ-1_G28Sg5as5ZaBeIfKCngrvoT52sLhkUYbplpgk6_G7MIyByENCv32oJAR4txcWgI0j5Bewds-cvR8foos2fz71Xob"
#' my_df <- get_top_artists_for_user(my_auth_token, 50, 2)



get_top_artists_for_user <- function(user_auth_token, limit_num, time_range_opt) {
  # Ensure valid input types
  if (!is.character(user_auth_token)) {
    stop("TypeError: user_auth_token is not a character")}
  if (!is.numeric(limit_num)) {
    stop("TypeError: limit_num is not numeric")}
  if (!(limit_num <= 50 & limit_num >=1)) {
    stop("TypeError: limit_num is not between 1 and 50 (inclusive)")}
  if (!(limit_num %% 1 == 0)) {
    stop("TypeError: limit_num is not an integer")}
  if (!(time_range_opt == 1 | time_range_opt == 2 | time_range_opt == 3)){
    stop("TypeError: time_range_opt is not either 1, 2, or 3")}


  base_url <- "https://api.spotify.com"
  instruction <-  "me/top" #"authorize"
  artist <- paste0("q=", "muse")
  type <- paste0("artists")
  limit <- glue("&limit=",limit_num)
  time_range_options = c("long_term", "medium_term", "short_term")
  time_range <- glue("time_range=", time_range_options[time_range_opt])

  auth_token <- user_auth_token

  request <- glue(base_url, "/v1", "/",
                  "{instruction}","/",
                  "{type}",
                  "?",
                  time_range,
                  limit)

  json_obj <- GET(request,
      add_headers(c(Authorization = glue("Bearer ", auth_token))))

  # Ensure valid authentication
  if (!(length(fromJSON(json_obj %>% content("text")) %>%
      .[[1]] %>% .$message) == 0)){
    if (fromJSON(json_obj %>% content("text")) %>%
        .[[1]] %>% .$message == "The access token expired") {
      stop("AuthenticationError: The access token expired")}

    if (fromJSON(json_obj %>% content("text")) %>%
        .[[1]] %>% .$message == "Invalid access token") {
      stop("AuthenticationError: Invalid access token")}

    if (!is.null(fromJSON(json_obj %>% content("text")) %>% .[[1]] %>% .$message)){
      stop("AuthenticationError: Unidentified access token error")}
  }




  df_from_get <- fromJSON(json_obj %>% content("text")) %>%
    .$items

  # Dataframe Tests
  if (!is.data.frame(df_from_get)){
    stop("DataFrameError: Object returned from GET call is not a DataFrame")}

  if (df_from_get %>% nrow() != limit_num){
    stop("DataFrameError: Dataframe does not have number of artists as requested")}
  df_obj <- df_from_get %>%
    flatten() %>%
    select(name, popularity, genres, followers.total) %>%
    rename(followers = "followers.total")
  if (!is.data.frame(df_obj)){
    stop("DataFrameError: Dataframe from Spotify Call has different names than during package development")}

  df_obj

}
