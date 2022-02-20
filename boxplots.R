library(tidyverse)
library(spotifyr)
library(ggplot2)

westernPop <- get_playlist_audio_features("", "3lro0N5fTyoXFZFbowlcdM")
westernPop <- westernPop[!is.na(westernPop$tempo), ][1:100,]
koreanPop <- get_playlist_audio_features("", "30EtqO7XgA36lwcdj1Uuex")
allPop <- rbind(westernPop, koreanPop)

ggplot(allPop, aes(x=playlist_name, y=danceability)) +
  geom_boxplot()

# 1
ggplot(allPop, aes(x=playlist_name, y=energy)) +
  geom_boxplot()

ggplot(allPop, aes(x=playlist_name, y=loudness)) +
  geom_boxplot()

ggplot(allPop, aes(x=playlist_name, y=speechiness)) +
  geom_boxplot()

# 2
ggplot(allPop, aes(x=playlist_name, y=acousticness)) +
  geom_boxplot()

ggplot(allPop, aes(x=playlist_name, y=instrumentalness)) +
  geom_boxplot()


ggplot(allPop, aes(x=playlist_name, y=liveness)) +
  geom_boxplot()


ggplot(allPop, aes(x=playlist_name, y=valence)) +
  geom_boxplot()


ggplot(allPop, aes(x=playlist_name, y=tempo)) +
  geom_boxplot()


ggplot(allPop, aes(x=playlist_name, y=track.duration_ms)) +
  geom_boxplot()


ggplot(allPop, aes(x=playlist_name, y=track.popularity)) +
  geom_boxplot()
