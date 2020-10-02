# ------------------------------------------------------------------------------
# MoCS: Assignment 1
# September 25, 2020
# M Clark & TS O'Leary
# ------------------------------------------------------------------------------

# Load required packages
require(tidyverse)

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

# Define the set of numbers to test for beta and h
betas <- c(0.03, 0.06, 0.1)
# Some thing is going on when h is high -- not sure if there is something wrong
# Also it seems like a am getting similar solutions to Euler and Huens
hs <- c(0.01, 0.5, 2.0)
#hs <- c(0.01, 0.1, .2)

# Initialize an empty data.frame to store the outputs and information
df <- tibble(beta = vector(mode = "numeric", length = length(betas)*length(hs)),
             h = vector(mode = "numeric", length = length(betas)*length(hs)), 
             euler = vector(mode = "list", length = length(betas)*length(hs)),
             heun = vector(mode = "list", length = length(betas)*length(hs)))
# Initialize a counter to help with indexing the df
loops <- 0

# Iterate through all possible combinations of beta and h
for (j in 1:length(betas)){
  
  # Infection and Recovery parameters
  parameters <- c(beta = betas[j], gamma = 0.25)
  
  for (i in 1:length(hs)) {
    # Implement Euler's method
    out_e <- euler_method(sis_model, 
                          h = hs[i],
                          n_steps = 50, 
                          params = parameters, 
                          init_conds = initial_state)
    
    # Implement Heun's method
    out_h <- heun_method(sis_model, 
                         h = hs[i],
                         n_steps = 50, 
                         params = parameters, 
                         init_conds = initial_state)
    
    # Count loops
    loops <- loops + 1 
    
    # Save results as a nested data.frame with beta and h value in their row
    df$beta[loops] <- betas[j]
    df$h[loops] <- hs[i] 
    df$euler[loops] <- nest(out_e, data = everything())
    df$heun[loops] <- nest(out_h, data = everything())
  }
}


# Plotting ----
# Need to rethink the plotting to do more of a facet_wrap approach!
plot_list <- vector(mode = "list", length = nrow(df))

for (i in 1:nrow(df)) {
  
  # Merge and tidy the nested data.frames for easier ggplotting
  df_e <- df$euler[i][[1]][[1]]
  df_e$method <- "euler"
  df_h <- df$heun[i][[1]][[1]]
  df_h$method <- "heun"
  
  df_tidy <- bind_rows(df_e, df_h) %>%
               pivot_longer(S:I, 
                            names_to = "Box", 
                            values_to = "Number")
  
  p <- si_plot(df_tidy)
  plot_list[[i]] <- p
  
}


