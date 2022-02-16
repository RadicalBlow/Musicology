install.packages("tidyverse")
install.packages("remotes")
install.packages("usethis")
remotes::install_github('charlie86/spotifyr')

usethis::edit_r_environ()

spotifyr::get_spotify_access_token()
