spotifyr::get_spotify_access_token()
library(tidyverse)
library(spotifyr)

juditha <- get_track_audio_features(c("2M5b9YLAgFroqWzeaZf86e", "3DBKc4ioGnMQLlbGQcFDIO"))
alla <- get_album_tracks("7oI0E3DdTbD85rhMg19GSU")
gilberto <- get_artist_audio_features("gilberto gil")
ecm <- get_playlist_audio_features("", "1zN4nK6oHMo2dei2WWPtSL")
disney <- get_playlist_audio_features("", "37i9dQZF1DX8C9xQcOrE6T")

disney %>%
  summarize(meanLiveness = mean())
