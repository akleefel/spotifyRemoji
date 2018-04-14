context("get_top_artists_for_user")

# Variables for Testing

valid_auth_token <- Sys.getenv("SPOTIFY_TOKEN")
expired_auth_token <- "BQDk6Yebn4V94Cbd121Rs73_q4Vtx1WotIX7o3spa5THlzfZi1pQn-jywCkz2XNld5Pa1H3jxo7EGL8JZ-1_G28Sg5as5ZaBeIfKCngrvoT52sLhkUYbplpgk6_G7MIyByENCv32oJAR4txcWgI0j5Bewds-cvR8foos2fz71Xob"
invalid_token <- "hi,I'm-not-really-a-token"

# Check for valid inputs
test_that("Valid Inputs", {
  expect_error(get_top_artists_for_user(592321, 50, 2),
               "TypeError: user_auth_token is not a character")
  expect_error(get_top_artists_for_user(valid_auth_token, "hi", 2),
               "TypeError: limit_num is not numeric")
  expect_error(get_top_artists_for_user(valid_auth_token, 0, 2),
               "TypeError: limit_num is not between 1 and 50 (inclusive)", fixed = TRUE)
  expect_error(get_top_artists_for_user(valid_auth_token, 51, 2),
               "TypeError: limit_num is not between 1 and 50 (inclusive)", fixed = TRUE)
  expect_error(get_top_artists_for_user(valid_auth_token, 31.5, 2),
               "TypeError: limit_num is not an integer")
  expect_error(get_top_artists_for_user(valid_auth_token, 50, 0),
               "TypeError: time_range_opt is not either 1, 2, or 3")
  expect_error(get_top_artists_for_user(valid_auth_token, 50, 1.3),
               "TypeError: time_range_opt is not either 1, 2, or 3")
})


# Check authentication token is string
test_that("Authentication Token Errors", {
  expect_error(get_top_artists_for_user(expired_auth_token, 50, 2),
               'AuthenticationError: The access token expired')
  expect_error(get_top_artists_for_user(invalid_token, 50, 2),
               'AuthenticationError: Invalid access token')
})

# Check that dataframe returned is valid
## Other if statements will only kick in if Spotify changes their API infrastructure
test_that("DataFrame that's returned from Request Error", {
  expect_equal(get_top_artists_for_user(valid_auth_token, 50, 2) %>% nrow(), 50)
})
