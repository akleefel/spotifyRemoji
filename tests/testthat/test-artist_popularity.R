context("artist_popularity")

user_auth_token  <-  Sys.getenv("SPOTIFY_TOKEN")

# Check that artist1 is not numeric
test_that("non-numeric artist1?", {
  expect_error(artist_popularity(user_auth_token,46, "madonna", "slayer"), "Invalid data type")
})

# Check that artist2 is not numeric
test_that("non-numeric artist2?", {
  expect_error(artist_popularity(user_auth_token,"madonna", 46, "slayer"), "Invalid data type")
})

# Check that artist3 is not numeric
test_that("non-numeric artist3?", {
  expect_error(artist_popularity(user_auth_token, "madonna", "slayer", 328), "Invalid data type")
})

# Check that artist1 is not boolean
test_that("non-boolean artist1?", {
  expect_error(artist_popularity(user_auth_token,TRUE, "madonna", "slayer"), "Invalid data type")
})

# Check that artist2 is not boolean
test_that("non-boolean artist2?", {
  expect_error(artist_popularity(user_auth_token,'madonna', TRUE, "slayer"), "Invalid data type")
})

# Check that artist3 is not boolean
test_that("non-boolean artist3?", {
  expect_error(artist_popularity(user_auth_token,'madonna', 'slayer', TRUE), "Invalid data type")
})

# Check if user token a non-string
test_that("user token a string?", {
  expect_error(artist_popularity(46,'madonna', 'slayer', 'kmfdm'), "Invalid data type")
  expect_error(artist_popularity(TRUE,'madonna', 'slayer', 'kmfdm'), "Invalid data type")
  expect_error(artist_popularity(NaN,'madonna', 'slayer', 'kmfdm'), "Invalid data type")
})

# Check that a plot is produced

test_that("Output is a plot?", {
  expect_equal(
    is.ggplot(artist_popularity(user_auth_token,'madonna', 'slayer', 'combichrist')))
})
