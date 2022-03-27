library(tidyverse)
library(spotifyr)
library(compmus)
library(tidymodels)
library(modeldata)
library(recipes)
library(heatmaply)
library(ggdendro)

get_pr <- function(fit) {
  fit %>% 
    conf_mat_resampled() %>% 
    group_by(Prediction) %>% mutate(precision = Freq / sum(Freq)) %>% 
    group_by(Truth) %>% mutate(recall = Freq / sum(Freq)) %>% 
    ungroup() %>% filter(Prediction == Truth) %>% 
    select(class = Prediction, precision, recall)
}  

westernPop <- get_playlist_audio_features("", "3lro0N5fTyoXFZFbowlcdM")
westernPop <- westernPop[!is.na(westernPop$tempo), ][1:100,] %>%
  add_audio_analysis()
koreanPop <- get_playlist_audio_features("", "30EtqO7XgA36lwcdj1Uuex") %>%
  add_audio_analysis()
allPop <- 
  koreanPop %>%
  mutate(genre = "Korean Pop") %>%
  bind_rows(westernPop %>% mutate(genre="Western Pop"))


features <-
  allPop %>%
  mutate(
    genre = factor(genre),
    segments = map2(segments, key, compmus_c_transpose),
    pitches =
      map(
        segments,
        compmus_summarise, pitches,
        method = "mean", norm = "manhattan"
      ),
    timbre =
      map(
        segments,
        compmus_summarise, timbre,
        method = "mean",
      )
  ) %>%
  mutate(pitches = map(pitches, compmus_normalise, "clr")) %>%
  mutate_at(vars(pitches, timbre), map, bind_rows) %>%
  unnest(cols = c(pitches, timbre))

pop_recipe <-
  recipe(
    genre ~
      danceability +
      energy +
      loudness +
      speechiness +
      acousticness +
      instrumentalness +
      liveness +
      valence +
      tempo +
      duration +
      C + `C#|Db` + D + `D#|Eb` +
      E + `F` + `F#|Gb` + G +
      `G#|Ab` + A + `A#|Bb` + B +
      c01 + c02 + c03 + c04 + c05 + c06 +
      c07 + c08 + c09 + c10 + c11 + c12,
    data = features,          # Use the same name as the previous block.
  )

pop_cv <- features %>% vfold_cv(5)

forest_model <-
  rand_forest() %>%
  set_mode("classification") %>% 
  set_engine("ranger", importance = "impurity")
pop_forest <- 
  workflow() %>% 
  add_recipe(pop_recipe) %>% 
  add_model(forest_model) %>% 
  fit_resamples(
    pop_cv, 
    control = control_resamples(save_pred = TRUE)
  )

pop_forest %>% get_pr()

workflow() %>% 
  add_recipe(pop_recipe) %>% 
  add_model(forest_model) %>% 
  fit(features) %>% 
  pluck("fit", "fit", "fit") %>%
  ranger::importance() %>% 
  enframe() %>% 
  mutate(name = fct_reorder(name, value)) %>% 
  ggplot(aes(name, value)) + 
  geom_col() + 
  coord_flip() +
  theme_minimal() +
  labs(x = NULL, y = "Importance")

plot_diff <- features %>%
  ggplot(aes(x = c01, y = loudness, colour = genre, size = duration)) +
  geom_point(alpha = 0.8) +
  scale_color_viridis_d() +
  labs(
    x = "Timbre Component 1",
    y = "Loudness",
    size = "Duration",
    colour = "Genre"
  )

ggplotly(plot_diff)
