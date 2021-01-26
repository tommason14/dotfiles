library(reticulate)
use_python("/usr/local/bin/python3", required = TRUE)
library(stats) # purely so dplyr::filter works
suppressWarnings(suppressPackageStartupMessages(library(tidyverse)))
library(readxl)
library(latex2exp)

options(
  languageserver.server_capabilities = list(
    object_name_linter = NULL,
    line_length_linter = lintr::line_length_linter(120)
  )
)

`%notin%` <- function(x, y) !(x %in% y)

# df_with_ci <- function(path) {
#   # select rows, convert to long format, then join
#   # maybe should pass order_by?
#   bw <- read_csv(path)
#   energies <- bw %>% select(Groups, Electrostatics, Dispersion)
#   intervals <- bw %>% select(Groups, Electro_CI, Dispersion_CI)
#
#   en_long <- energies %>%
#     group_by(Groups) %>%
#     gather("Interaction", "Energy", Electrostatics, Dispersion)
#   ci_long <- intervals %>%
#     group_by(Groups) %>%
#     gather("CI_type", "CI", Electro_CI, Dispersion_CI)
#
#   df <- cbind(en_long, ci_long)
#   df <- df %>% ungroup()
#   return(df)
# }

dopamine_theming <- theme_light() +
  theme(
    panel.grid = element_blank(),
    panel.spacing = unit(0.6, "cm"),
    text = element_text(size = 14),
    axis.title.y = element_text(margin = margin(c(0, 0.4, 0, 0), unit = "cm")),
    axis.title.x = element_text(margin = margin(c(0.4, 0, 0, 0), unit = "cm"))
  )

no_grid <- theme(panel.grid = element_blank())

no_x <- theme(
  axis.text.x = element_blank(),
  axis.ticks.x = element_blank()
)

no_y <- theme(
  axis.text.y = element_blank(),
  axis.ticks.y = element_blank()
)

y_scale <- function(y) {
  c(0, floor(max(y)) / 2, floor(max(y)))
}

# hrbrthemes::theme_ipsum, but loaded here to avoid font issues
theme_tom <- function(font = "Anonymous Pro", base_size = 11.5,
                      plot_title_family = font, plot_title_size = 18,
                      plot_title_face = "bold", plot_title_margin = 10,
                      subtitle_family = font, subtitle_size = 12,
                      subtitle_face = "plain", subtitle_margin = 15,
                      strip_text_family = font, strip_text_size = 12,
                      strip_text_face = "plain",
                      caption_family = font, caption_size = 9,
                      caption_face = "italic", caption_margin = 10,
                      axis_text_size = base_size,
                      axis_title_family = subtitle_family, axis_title_size = 9,
                      axis_title_face = "plain", axis_title_just = "rt",
                      plot_margin = margin(30, 30, 30, 30),
                      grid_col = "#cccccc", grid = TRUE,
                      axis_col = "#cccccc", axis = FALSE, ticks = FALSE) {
  ret <- ggplot2::theme_minimal(base_family = font, base_size = base_size)

  ret <- ret + theme(legend.background = element_blank())
  ret <- ret + theme(legend.key = element_blank())

  if (inherits(grid, "character") | grid == TRUE) {
    ret <- ret + theme(panel.grid = element_line(color = grid_col, size = 0.2))
    ret <- ret + theme(panel.grid.major = element_line(color = grid_col, size = 0.2))
    ret <- ret + theme(panel.grid.minor = element_line(color = grid_col, size = 0.15))

    if (inherits(grid, "character")) {
      if (regexpr("X", grid)[1] < 0) ret <- ret + theme(panel.grid.major.x = element_blank())
      if (regexpr("Y", grid)[1] < 0) ret <- ret + theme(panel.grid.major.y = element_blank())
      if (regexpr("x", grid)[1] < 0) ret <- ret + theme(panel.grid.minor.x = element_blank())
      if (regexpr("y", grid)[1] < 0) ret <- ret + theme(panel.grid.minor.y = element_blank())
    }
  } else {
    ret <- ret + theme(panel.grid = element_blank())
  }

  if (inherits(axis, "character") | axis == TRUE) {
    ret <- ret + theme(axis.line = element_line(color = "#2b2b2b", size = 0.15))
    if (inherits(axis, "character")) {
      axis <- tolower(axis)
      if (regexpr("x", axis)[1] < 0) {
        ret <- ret + theme(axis.line.x = element_blank())
      } else {
        ret <- ret + theme(axis.line.x = element_line(color = axis_col, size = 0.15))
      }
      if (regexpr("y", axis)[1] < 0) {
        ret <- ret + theme(axis.line.y = element_blank())
      } else {
        ret <- ret + theme(axis.line.y = element_line(color = axis_col, size = 0.15))
      }
    } else {
      ret <- ret + theme(axis.line.x = element_line(color = axis_col, size = 0.15))
      ret <- ret + theme(axis.line.y = element_line(color = axis_col, size = 0.15))
    }
  } else {
    ret <- ret + theme(axis.line = element_blank())
  }

  if (!ticks) {
    ret <- ret + theme(axis.ticks = element_blank())
    ret <- ret + theme(axis.ticks.x = element_blank())
    ret <- ret + theme(axis.ticks.y = element_blank())
  } else {
    ret <- ret + theme(axis.ticks = element_line(size = 0.15))
    ret <- ret + theme(axis.ticks.x = element_line(size = 0.15))
    ret <- ret + theme(axis.ticks.y = element_line(size = 0.15))
    ret <- ret + theme(axis.ticks.length = grid::unit(5, "pt"))
  }

  xj <- switch(tolower(substr(axis_title_just, 1, 1)), b = 0, l = 0, m = 0.5, c = 0.5, r = 1, t = 1)
  yj <- switch(tolower(substr(axis_title_just, 2, 2)), b = 0, l = 0, m = 0.5, c = 0.5, r = 1, t = 1)

  ret <- ret + theme(axis.text.x = element_text(size = axis_text_size, margin = margin(t = 0)))
  ret <- ret + theme(axis.text.y = element_text(size = axis_text_size, margin = margin(r = 0)))
  ret <- ret + theme(axis.title = element_text(size = axis_title_size, family = axis_title_family))
  ret <- ret + theme(axis.title.x = element_text(
    hjust = xj, size = axis_title_size,
    family = axis_title_family, face = axis_title_face
  ))
  ret <- ret + theme(axis.title.y = element_text(
    hjust = yj, size = axis_title_size,
    family = axis_title_family, face = axis_title_face
  ))
  ret <- ret + theme(axis.title.y.right = element_text(
    hjust = yj, size = axis_title_size, angle = 90,
    family = axis_title_family, face = axis_title_face
  ))
  ret <- ret + theme(strip.text = element_text(
    hjust = 0, size = strip_text_size,
    face = strip_text_face, family = strip_text_family
  ))
  ret <- ret + theme(panel.spacing = grid::unit(2, "lines"))
  ret <- ret + theme(plot.title = element_text(
    hjust = 0, size = plot_title_size,
    margin = margin(b = plot_title_margin),
    family = plot_title_family, face = plot_title_face
  ))
  ret <- ret + theme(plot.subtitle = element_text(
    hjust = 0, size = subtitle_size,
    margin = margin(b = subtitle_margin),
    family = subtitle_family, face = subtitle_face
  ))
  ret <- ret + theme(plot.caption = element_text(
    hjust = 0, size = caption_size,
    margin = margin(t = caption_margin),
    family = caption_family, face = caption_face
  ))
  ret <- ret + theme(plot.margin = plot_margin)

  ret
}


bp <- function(series) {
  # Takes in energies in Hartrees, returns
  # probabilities according to a Boltzmann distribution,
  # in kJ/mol. Also works with group by objects.
  R <- 8.3145
  T <- 298.15
  h_to_kJ <- 2625.5
  series <- series * h_to_kJ
  diffs <- series - min(series)
  exponent <- exp((-1 * diffs * 1000) / (R * T))
  summed <- sum(exponent)
  return(exponent / summed)
}

# formatting strings for ggplot graphs

formatted <- function(...) {
  vals <- c(...)
  replacements <- c()
  for (val in vals) {
    val <- str_replace_all(val, "_(?=\\{?\\d)", "$_") # subscripts followed by digit, _4_ -> $_4_ or _{40}_ -> $_{40}_
    val <- str_replace_all(val, "(?<=\\d\\}?)_", "$") # subscripts preceeded by digit, $_4_ -> $_4$
    val <- str_replace_all(val, "\\[", "\\\\[")
    val <- str_replace_all(val, "\\]", "\\\\]")
    replacements <- c(replacements, parse(text = TeX(val))) # add to vector
  }
  return(replacements)
}

# theming

my_orange <- "#EF8A62"
my_red <- "#B22121"
my_light_blue <- "#67A9CF"
my_blue <- "#4545E5"


theme_default <- theme_bw() +
  theme(
    legend.title = element_blank(),
    legend.background = element_blank(),
    legend.key = element_rect(colour = NA, fill = NA),
    text = element_text(size = 14),
    axis.title = element_text(size = 12),
    legend.text.align = 0
  ) +
  no_grid


# UV-Vis/Fluorescence
# Note that functions are expecting output from chem_assist/qcp, in the form
# Config,Root,Iteration,Transition Energies (eV),Wavelength (nm),Intensity (au)

normpdf <- function(x, mu, sigma) {
  u <- (x - mu) / abs(sigma)
  y <- (1 / (sqrt(2 * pi) * abs(sigma))) * exp(-u**2 / 2)
  return(y)
}

smooth_with_gaussians <- function(df, sigma, step) {
  if (missing(sigma)) {
    sigma <- 0.05
  }
  if (missing(step)) {
    step <- 0.01
  }

  h <- 6.62607004e-34
  c <- 299792458
  e <- 1.6021766208e-19

  min_transition_energy <- min(df$`Transition Energies (eV)`) - (5 * sigma)
  max_transition_energy <- max(df$`Transition Energies (eV)`) + (5 * sigma)

  # create new energy scale based on transition energies
  # (makes sense; no transition = no absorbance = no peak)
  new_energies <- seq(min_transition_energy, max_transition_energy, step)
  # convert to wavelengths (eV -> nm)
  new_waves <- (h * c * 1e9 / (new_energies * e))

  # take number of x values, set to 0, then move along the
  # line and fill values of intensity as you go, using the index of the
  # intensity list to find the oscillator strength.

  new_ints <- rep(0, length(new_waves))

  for (i in 1:length(df$`Intensity (au)`)) { # want the index
    new_ints <- new_ints + df$`Intensity (au)`[i] * normpdf(
      new_energies,
      df$`Transition Energies (eV)`[i],
      sigma
    )
  }
  return(list(new_waves = new_waves, new_ints = new_ints))
}

add_gaussians <- function(original_df, sigma, step) {
  new <- smooth_with_gaussians(original_df, sigma, step)
  ret <- data.frame(
    new_waves = new$new_waves,
    new_ints = new$new_ints
  )
  # extend original df to make it the same length as the new one
  rows_to_add <- nrow(ret) - nrow(original_df)
  ret$raw_waves <- c(original_df$`Wavelength (nm)`, rep(NA, rows_to_add))
  ret$raw_ints <- c(original_df$`Intensity (au)`, rep(NA, rows_to_add))
  return(ret)
}

# curve, lines are colours
plot_gaussians <- function(df, curve, lines) {
  if (missing(curve)) {
    curve <- "red"
  }
  if (missing(lines)) {
    lines <- "blue"
  }
  return(
    ggplot(df) +
      theme_default +
      geom_line(aes(new_waves, new_ints), color = curve) +
      geom_segment(aes(
        x = raw_waves, xend = raw_waves,
        y = 0, yend = raw_ints
      ), color = lines) +
      labs(x = "Wavelength (nm)", y = "Intensity (au)")
  )
}

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
  nln2 <- -log(2.0)
  return(exp(nln2 * rel_offset * rel_offset))
}


fit_lorentzians <- function(old_spectra, xvals, half_width) {
  ints <- rep(0, length(xvals))
  # need to reference intensity and frequencies at same time; use numerical index
  for (i in seq_along(xvals)) {
    intensity <- 0.0
    # Fit a lorentzian to every peak, and sum up intensity at each new wavelength,
    # with the offset from the original wavelength describing the new intensity
    for (j in seq_along(old_spectra$Frequencies)) {
      rel_offset <- (xvals[i] - old_spectra$Frequencies[j]) / half_width
      intensity <- intensity + old_spectra$Intensities[j] * lorentz(rel_offset)
    }
    ints[i] <- intensity
  }
  return(list(new_freqs = xvals, new_ints = ints))
}

ir_with_lorentzians <- function(orig_df, half_width, npts) {
  # Expects a dataframe with headers of File, Frequencies, Intensities

  if (missing(npts)) {
    npts <- 4000
  }

  if (missing(half_width)) {
    half_width <- 20
  }
  new_wavenumbers <- seq(0, npts, 1)
  new_df <- fit_lorentzians(orig_df, new_wavenumbers, half_width)

  ret <- data.frame(
    Wavenumber = new_df$new_freqs,
    Intensity = new_df$new_ints
  )

  # extend original df to make it the same length as the new one
  rows_to_add <- nrow(ret) - nrow(orig_df)
  ret$raw_freqs <- c(orig_df$`Frequencies`, rep(NA, rows_to_add))
  ret$raw_ints <- c(orig_df$`Intensities`, rep(NA, rows_to_add))
  return(ret)
}

raw_frequencies <- geom_segment(aes(
  x = raw_freqs, xend = raw_freqs,
  y = 0, yend = raw_ints
), color = my_blue)

plot_ir_spectra <- function(df) {
  return(
    ggplot(df) +
      aes(Wavenumber, Intensity, color = File) +
      geom_line(show.legend = F) +
      facet_wrap(File ~ .)
  )
}

plot_ir_spectra_no_colour <- function(df) {
  return(
    ggplot(df) +
      aes(Wavenumber, Intensity) +
      geom_line(show.legend = F)
  )
}

##############
#  defaults  #
##############
theme_set(theme_bw() +
  theme(text = element_text(family = "Roboto Condensed")))
scale_colour_discrete <- function(...) {
  scale_colour_brewer(..., palette = "Dark2")
}
scale_fill_discrete <- function(...) {
  scale_fill_brewer(..., palette = "Dark2")
}

# cat("\nThis is the last line of .Rprofile.\n")
