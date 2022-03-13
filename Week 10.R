library(flexdashboard)
library(tidyverse)
library(spotifyr)
library(ggplot2)
library(plotly)
library(compmus)

westernPop <- get_playlist_audio_features("", "3lro0N5fTyoXFZFbowlcdM")
westernPop <- westernPop[!is.na(westernPop$tempo), ][1:100,] %>%
  add_audio_analysis()
koreanPop <- get_playlist_audio_features("", "30EtqO7XgA36lwcdj1Uuex") %>%
  add_audio_analysis()
allPop <- 
  koreanPop %>%
  mutate(genre = "Korean Pop") %>%
  bind_rows(westernPop %>% mutate(genre="Western Pop"))

allPop %>%
  mutate(
    sections =
      map(
        sections,                                    # sections or segments
        summarise_at,
        vars(tempo, loudness, duration),             # features of interest
        list(section_mean = mean, section_sd = sd)   # aggregation functions
      )
  ) %>%
  unnest(sections) %>%
  ggplot(
    aes(
      x = tempo,
      y = tempo_section_sd,
      colour = genre,
      alpha = loudness
    )
  ) +
  geom_point(aes(size = duration / 60)) +
  geom_rug() +
  theme_minimal() +
  ylim(0, 5) +
  labs(
    x = "Mean Tempo (bpm)",
    y = "SD Tempo",
    colour = "Genre",
    size = "Duration (min)",
    alpha = "Volume (dBFS)"
  )

ggplotly(comp)
