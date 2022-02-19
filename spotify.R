# Code for Top Pop 2021: 6BRn3JO4cq5PQhA92koAD3
# Code for Top K-Pop 2021: 37i9dQZF1DX9Ja3hVYaZeE
library(tidyverse)
library(spotifyr)
library(ggplot2)

westernPop <- get_playlist_audio_features("", "6BRn3JO4cq5PQhA92koAD3")
koreanPop <- get_playlist_audio_features("", "37i9dQZF1DX9Ja3hVYaZeE")


ggplot() +
  geom_point(data=koreanPop, aes(x=track.popularity, y=tempo),
             color="red") +
  geom_point(data=westernPop, aes(x=track.popularity, y=tempo), 
             color="blue")

