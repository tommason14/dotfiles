library(reticulate)
use_python(Sys.which('python3'), required = TRUE)
library(tidyverse)
library(readxl)
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

no_grid <- theme(panel.grid = element_blank())

no_x <- theme(axis.text.x = element_blank(),
              axis.ticks.x = element_blank())

no_y <- theme(axis.text.y = element_blank(),
              axis.ticks.y = element_blank())

bp <- function(series) {
  # Takes in energies in Hartrees, returns
  # probabilities according to a Boltzmann distribution,
  # in kJ/mol. Also works with group by objects.
    R = 8.3145
    T = 298.15
    h_to_kJ = 2625.5
    series = series * h_to_kJ
    diffs = series - min(series)
    exponent = exp((-1 * diffs * 1000) / (R * T))
    summed = sum(exponent)
    return(exponent / summed)
}

my_red <- '#B22121'
my_blue <- '#4545E5'


theme_default <- theme_bw() +
  theme(
  legend.title = element_blank(),
  legend.background = element_blank(),
  legend.key=element_rect(colour=NA, fill =NA),
  text = element_text(size = 14),
  axis.title = element_text(size=12),
  legend.text.align = 0) +
  no_grid


# UV-Vis/Fluorescence
# Note that functions are expecting output from chem_assist/qcp, in the form
# Config,Root,Iteration,Oscillator Strength (eV),Wavelength (nm),Intensity (au)

normpdf <- function(x, mu, sigma){
    u = (x-mu)/abs(sigma)
    y = (1/(sqrt(2*pi)*abs(sigma)))*exp(-u**2/2)
    return(y)
}

smooth_with_gaussians <- function(df, sigma, step){
  if (missing(sigma)) {
    sigma=0.05
  }
  if (missing(step)) {
    step=0.01
  }

  h = 6.62607004e-34
  c = 299792458
  e = 1.6021766208e-19
  
  min_transition_energy = min(df$`Oscillator Strength (eV)`) - (5 * sigma)
  max_transition_energy = max(df$`Oscillator Strength (eV)`) + (5 * sigma)

  # create new energy scale based on transition energies
  # (makes sense; no transition = no absorbance = no peak)
  new_energies = seq(min_transition_energy, max_transition_energy, step)
  # convert to wavelengths (eV -> nm)
  new_waves = (h * c * 1e9 / (new_energies * e))
  
  # take number of x values, set to 0, then move along the 
  # line and fill values of intensity as you go, using the index of the 
  # intensity list to find the oscillator strength.
  
  new_ints = rep(0, length(new_waves))
  
  for(i in 1:length(df$`Intensity (au)`)){ # want the index
    new_ints = new_ints + df$`Intensity (au)`[i] * normpdf(new_energies, 
                                                         df$`Oscillator Strength (eV)`[i],
                                                         sigma)
  }
  return(list(new_waves = new_waves, new_ints=new_ints))
}

add_gaussians <- function(original_df, sigma, step) {
  new <- smooth_with_gaussians(original_df, sigma, step)
  ret <- data.frame(
    new_waves=new$new_waves,
    new_ints=new$new_ints
  )
  # extend original df to make it the same length as the new one
  rows_to_add <-  nrow(ret) - nrow(original_df)
  ret$raw_waves <- c(original_df$`Wavelength (nm)`, rep(NA, rows_to_add))
  ret$raw_ints <- c(original_df$`Intensity (au)`, rep(NA, rows_to_add))
  return(ret)
}

plot_gaussians <- function(df){
  return(
    ggplot(df) +
    theme_default +
    geom_line(aes(new_waves, new_ints), color='red') +
    geom_segment(aes(x = raw_waves, xend = raw_waves,
                     y = 0, yend = raw_ints), color = 'blue') +
    labs(x = 'Wavelength (nm)', y = 'Intensity (au)') +
    facet_wrap(.~Config)
  )
}

# Call it:
# df <- read_csv('uv-vis.csv')
# df %>% group_by(Config) %>% do(add_gaussians(.)) %>% plot_gaussians()

cat("\nThis is the last line of .Rprofile.\n")

