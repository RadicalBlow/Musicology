library(tidyverse)
library(spotifyr)
library(compmus)


dc <-
  get_tidy_audio_analysis("3L74uwShK0JqEUZ5Y2JoDW") %>% # Change URI.
  compmus_align(bars, segments) %>%                     # Change `bars`
  select(bars) %>%                                      #   in all three
  unnest(bars) %>%                                      #   of these lines.
  mutate(
    pitches =
      map(segments,
          compmus_summarise, pitches,
          method = "rms", norm = "euclidean"              # Change summary & norm.
      )
  ) %>%
  mutate(
    timbre =
      map(segments,
          compmus_summarise, timbre,
          method = "rms", norm = "euclidean"              # Change summary & norm.
      )
  )

timbreDF <- dc %>% compmus_self_similarity(timbre, "cosine")
timbreDF$name <- "Timbre"
pitchesDF <- dc %>% compmus_self_similarity(pitches, "cosine")
pitchesDF$name <- "Chroma"
together <- rbind(pitchesDF, timbreDF)

together %>%
  ggplot(
    aes(
      x = xstart + xduration / 2,
      width = xduration,
      y = ystart + yduration / 2,
      height = yduration,
      fill = d
    )
  ) +
  geom_tile() +
  coord_fixed() +
  scale_fill_viridis_c(guide = "none") +
  theme_classic() +
  labs(x = "", y = "") +
  facet_wrap(~name)

dc %>%
  compmus_self_similarity(timbre, "angular") %>%
  ggplot(
    aes(
      x = xstart + xduration / 2,
      width = xduration,
      y = ystart + yduration / 2,
      height = yduration,
      fill = d
    )
  ) +
  geom_tile() +
  coord_fixed() +
  scale_fill_viridis_c(guide = "none") +
  theme_classic() +
  labs(x = "", y = "")
