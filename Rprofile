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
  return(df)
}

cat("\nThis is the last line of .Rprofile.\n")

