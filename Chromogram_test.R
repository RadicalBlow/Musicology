remotes::install_github('jaburgoyne/compmus')

library(tidyverse)
library(spotifyr)
library(compmus)

wood <-
  get_tidy_audio_analysis("6IQILcYkN2S2eSu5IHoPEH") %>%
  select(segments) %>%
  unnest(segments) %>%
  select(start, duration, pitches)

# manhattan, euclidean, or chebyshev

wood %>%
  mutate(pitches = map(pitches, compmus_normalise, "chebyshev")) %>%
  compmus_gather_chroma() %>% 
  ggplot(
    aes(
      x = start + duration / 2,
      width = duration,
      y = pitch_class,
      fill = value
    )
  ) +
  geom_tile() +
  labs(x = "Time (s)", y = NULL, fill = "Magnitude") +
  theme_minimal() +
  scale_fill_viridis_c()

blik <-
  get_tidy_audio_analysis("3mafhqH8nGsvyZTN86IEOc") %>%
  select(segments) %>%
  unnest(segments) %>%
  select(start, duration, pitches)

# manhattan, euclidean, or chebyshev

blik %>%
  mutate(pitches = map(pitches, compmus_normalise, "chebyshev")) %>%
  compmus_gather_chroma() %>% 
  ggplot(
    aes(
      x = start + duration / 2,
      width = duration,
      y = pitch_class,
      fill = value
    )
  ) +
  geom_tile() +
  labs(x = "Time (s)", y = NULL, fill = "Magnitude") +
  theme_minimal() +
  scale_fill_viridis_c()
