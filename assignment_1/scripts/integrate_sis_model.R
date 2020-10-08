# ------------------------------------------------------------------------------
# MoCS: Assignment 1: Question 4: Implement Euler' and Heun's on SIS Model
# September 25, 2020
# L Shapiro, M Clark, & TS O'Leary
# ------------------------------------------------------------------------------

# Load required packages
require(tidyverse)

# Source all functions 
miceadds::source.all(here::here("assignment_1/functions"))

# Question 4: Implement Euler and Huen's Method on SIS model -------------------
# Test with the following parameters:
# N = 100, γ = 0.25, and each β ∈ {0.03, 0.06, 0.1}
# Using step sizes h ∈ {0.01, 0.5, 2.0}
# Run the model for 50 steps each time
# Use initial values of (S, I) = (90, 10)

# Inital state of the system
initial_state <- c(S = 90, I = 10)

# Define the set of numbers to test for beta and h
betas <- c(0.03, 0.06, 0.1)
hs <- c(0.01, 0.5, 2.0)

# Initialize an empty data.frame to store the outputs and information
df <- tibble()

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
    
    # Save results with method and parameters in a tidy format
    out_e$method <- "euler"
    out_h$method <- "heun"
    comb <- bind_rows(out_e, out_h) %>%
      pivot_longer(S:I, 
                   names_to = "Box", 
                   values_to = "Number")
    comb$beta <- betas[j]
    comb$h <- hs[i]
    comb$params <- paste0("beta = ", betas[j], "; h = ", hs[i])
    
    df <- bind_rows(df, comb)
    
  }
}
