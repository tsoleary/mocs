# ------------------------------------------------------------------------------
# MoCS: Assignment 1
# September 25, 2020
# M Clark & TS O'Leary
# ------------------------------------------------------------------------------

################################################################################
# Question 3: Create an implementation of Euler's Method and Huen's Method in R
################################################################################
# Each function should have a tunable parameter h which represents the step size
# What is the relationship between Euler’s method and a discrete time model? 

# See individual function files!

# Source all functions 
miceadds::source.all(here::here("functions"))


################################################################################
# Question 4: Implement Euler and Huen's Method on SIS model -------------------
################################################################################

# Test with the following parameters -----
# N = 100, γ = 0.25, and each β ∈ {0.03, 0.06, 0.1}
# Using step sizes h ∈ {0.01, 0.5, 2.0}
# Run the model for 50 steps each time
# Use initial values of (S, I) = (90, 10)

# Create the following plot
# Create 9 different plots showing time series from both your 
# Euler’s and Heun’s method with each of these parameter combinations

# Is there a noticeable difference between the two methods? What might be going on?


# Inital state of the system
initial_state <- c(S = 90, I = 10)

# Infection and Recovery parameters
parameters <- c(beta = 0.03, gamma = 0.25)

# Implement Euler's method
out <- euler_method(sis_model, 
                    h = .1,
                    n_steps = 50, 
                    params = parameters, 
                    init_conds = initial_state)

out <- heun_method(sis_model, 
                   h = .1,
                   n_steps = 50, 
                   params = parameters, 
                   init_conds = initial_state)


# Plotting the results
require(tidyverse)

# Tidy the data frame
out <- out %>%
  pivot_longer(S:I, names_to = "Box", values_to = "Number")

# Plotting ----
ggplot(data = out) +
  geom_line(aes(x = t, y = Number, color = Box)) +
  ylim(c(0, 100)) +
  labs(x = "Time", y = "Number of People in a Box") +
  theme_classic()

# 
