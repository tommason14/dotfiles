library(reticulate)
use_python(Sys.which('python3'), required = TRUE)
library(tidyverse)
library(magrittr)
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

y_scale <- function(y){
  c(0, floor(max(y)) / 2, floor(max(y)))
}


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

# formatting strings for ggplot graphs

formatted <- function(...){
  vals <- c(...)
  replacements <- c()
  for (val in vals) {
    val = str_replace_all(val, '_(?=\\{?\\d)', '$_') # subscripts followed by digit, _4_ -> $_4_
    val = str_replace_all(val, '(?<=\\d\\}?)_', '$') # subscripts preceeded by digit, $_4_ -> $_4$
    val = str_replace_all(val, '\\[', '\\\\[')
    val = str_replace_all(val, '\\]', '\\\\]')
    replacements <- c(replacements, parse(text=TeX(val))) # add to vector
  }
  return(replacements)
}

# theming

my_orange <- '#EF8A62'
my_red <- '#B22121'
my_light_blue <- '#67A9CF'
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
# Config,Root,Iteration,Transition Energies (eV),Wavelength (nm),Intensity (au)

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

  min_transition_energy = min(df$`Transition Energies (eV)`) - (5 * sigma)
  max_transition_energy = max(df$`Transition Energies (eV)`) + (5 * sigma)

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
                                                         df$`Transition Energies (eV)`[i],
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
    labs(x = 'Wavelength (nm)', y = 'Intensity (au)')
  )}

# Call it:
# df <- read_csv('uv-vis.csv')
# df %>% group_by(Config) %>% do(add_gaussians(.)) %>% plot_gaussians() + facet_wrap(.~Config)

# To add different sigma and step values:
# sigma = 0.06
# step = 0.1
# df %>% group_by(Config) %>% do(add_gaussians(., sigma, step)) %>% plot_gaussians() + facet_wrap(.~Config)

# IR spectra
# Adding lorentzians

lorentz <- function(rel_offset) {
  return(1.0 / (1.0 + rel_offset * rel_offset))
}

gauss <- function(rel_offset) {
  nln2 = -log(2.0)
  return(exp(nln2 * rel_offset * rel_offset))
}


fit_lorentzians <- function(old_spectra, xvals, half_width){
  ints = rep(0, length(xvals))
  # need to reference intensity and frequencies at same time; use numerical index
  for (i in 1:length(xvals)) { 
    intensity = 0.0
    # Fit a lorentzian to every peak, and sum up intensity at each new wavelength,
    # with the offset from the original wavelength describing the new intensity
    for (j in 1:length(old_spectra$Frequencies)) {
      rel_offset = (xvals[i] - old_spectra$Frequencies[j]) / half_width
      intensity = intensity + old_spectra$Intensities[j] * lorentz(rel_offset) 
    }
    ints[i] = intensity
  }
  return(list(new_freqs = xvals, new_ints = ints))
}

ir_with_lorentzians <- function(orig_df, half_width, npts){
  # Expects a dataframe with headers of File, Frequencies, Intensities  

  if (missing(npts)) {
    npts=4000
  }

  if (missing(half_width)) {
    half_width=20
  }
  new_wavenumbers <- seq(0, npts, 1)
  new_df <- fit_lorentzians(orig_df, new_wavenumbers, half_width)

  ret <- data.frame(
    Wavenumber = new_df$new_freqs,
    Intensity  = new_df$new_ints
  )

  # extend original df to make it the same length as the new one
  rows_to_add <-  nrow(ret) - nrow(orig_df)
  ret$raw_freqs <- c(orig_df$`Frequencies`, rep(NA, rows_to_add))
  ret$raw_ints <- c(orig_df$`Intensities`, rep(NA, rows_to_add))
  return(ret)
}

raw_frequencies <- geom_segment(aes(x=raw_freqs, xend=raw_freqs,
                              y=0, yend=raw_ints), color=my_blue)

plot_ir_spectra <- function(df){
  return(
    ggplot(df) +
    aes(Wavenumber, Intensity, color=File) +
    geom_line(show.legend=F) +
    facet_wrap(File~.)
  )
}

plot_ir_spectra_no_colour <- function(df){
  return(
    ggplot(df) +
    aes(Wavenumber, Intensity) +
    geom_line(show.legend=F)
  )
}

cat("\nThis is the last line of .Rprofile.\n")

