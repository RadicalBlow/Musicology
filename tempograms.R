library(flexdashboard)
library(tidyverse)
library(spotifyr)
library(ggplot2)
library(plotly)
library(compmus)

shape <- get_tidy_audio_analysis("7qiZfU4dY1lWllzX7mPBI3") %>%
  tempogram(window_size = 8, hop_size = 1, cyclic = TRUE) %>%
  mutate(song="Shape of You")
stop <- get_tidy_audio_analysis("37ZtpRBkHcaq6hHy0X98zn") %>%
  tempogram(window_size = 8, hop_size = 1, cyclic = TRUE) %>%
  mutate(song="I can't stop me")

together <- rbind(shape, stop)

together%>%
  ggplot(aes(x = time, y = bpm, fill = power)) +
  geom_raster() +
  scale_fill_viridis_c(guide = "none") +
  labs(x = "Time (s)", y = "Tempo (BPM)") +
  theme_classic() +
  facet_wrap(~song)
