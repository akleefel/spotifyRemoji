context("related_artists")

auth <- Sys.getenv("SPOTIFY_TOKEN")

#Test A

test_that("Passing valid authentication and artist name leads to correct shape of dataframe output",{
  expect_equal(dim(related_artists(auth, "haftbefehl"))[1],20)
})


#Test B

test_that("Passing invalid artist name leads to empty dataframe", {

  expect_equal(dim(related_artists(auth, "Hafti"))[1],0)
})

#Test C

test_that("Passing invalid authentication leads to empty dataframe",{

  auth <- "hello"
  expect_equal(dim(related_artists(auth, "Haftbefehl"))[1],0)
})




#Test B
test_that("Both arguments were passed", {

  expect_error(related_artists(user_auth_token = auth, artistName = ""), "One of 'user_auth_token' or 'artistName' is missing")
})


