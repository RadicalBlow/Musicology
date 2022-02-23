library(tidyverse)
library(spotifyr)
library(ggplot2)

westernPop <- get_playlist_audio_features("", "3lro0N5fTyoXFZFbowlcdM")
westernPop <- westernPop[!is.na(westernPop$tempo), ][1:100,]
koreanPop <- get_playlist_audio_features("", "30EtqO7XgA36lwcdj1Uuex")
allPop <- rbind(westernPop, koreanPop)

test <- get_playlist_audio_features("", "45EFycwtfRhnDPWbc2mClK")
ggplot(allPop, aes(x=energy)) +
  geom_histogram(bins=20) +
  facet_wrap(~ playlist_name)
