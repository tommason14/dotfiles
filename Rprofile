library(reticulate)
use_python(Sys.which('python3'), required = TRUE)
library(tidyverse)
library(latex2exp) 
dfilter <- dplyr::filter # namespace issues- base stats overrides dplyr filter 

df_with_ci <- function(path) {
  # select rows, convert to long format, then join
  # maybe should pass order_by?
  bw <- read_csv(path)
  energies <- bw %>% select(Groups, Electrostatics, Dispersion)
  intervals <- bw %>% select(Groups, Electro_CI, Dispersion_CI)

  en_long <- energies %>% group_by(Groups) %>%
    gather('Interaction', 'Energy', Electrostatics, Dispersion)
  ci_long <- intervals %>% group_by(Groups) %>%
    gather('CI_type', 'CI', Electro_CI, Dispersion_CI)

  df <- cbind(en_long, ci_long)
  df <- df %>% ungroup()
  return(df)
}

dopamine_theming <- theme_light() +
                theme(panel.grid = element_blank(),
                 panel.spacing = unit(0.6, 'cm'),
                 text = element_text(size = 14),
                 axis.title.y = element_text(margin = margin(c(0,0.4,0,0), unit='cm')),
                 axis.title.x = element_text(margin = margin(c(0.4,0,0,0), unit='cm')))

no_bg <- theme(panel.grid = element_blank())

cat("\nThis is the last line of .Rprofile.\n")

