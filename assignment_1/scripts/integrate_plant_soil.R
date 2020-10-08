# ------------------------------------------------------------------------------
# MoCS: Assignment 1: Question 7: Integrate your made up model
# September 25, 2020
# L Shapiro, M Clark, & TS O'Leary
# ------------------------------------------------------------------------------

# Load required packages
require(tidyverse)

# Source all functions 
miceadds::source.all(here::here("assignment_1/functions"))

# Question 7: Integrate plant and soil model------------------------------------

# Define the number of steps and step size
n_steps <- 10000
h <- 0.01
  
# Define the set of numbers to test for beta and initial P
fs <- c(0.05, 0.1, 0.15)
p_inits <- c(10, 50, 90)

# Initialize an empty data.frame to store the outputs and information
df <- tibble()

# Initialize a counter to help with indexing the df
loops <- 0

# Iterate through all possible combinations of fs and h
for (j in 1:length(fs)){
  
  # Parameters
  parameters <- c(p = 0.2, f = fs[j], r_s = 0.1, s_r = 0.1)
  
  for (i in 1:length(p_inits)) {
    
    initial_state <- c(P = p_inits[i], S = 50)
    
    # Implement Heun's method
    out <- heun_method(plant_soil_model, 
                       h = h,
                       n_steps = n_steps, 
                       params = parameters, 
                       init_conds = initial_state)
    
    # Count loops
    loops <- loops + 1 
    
    # Save results with method and parameters in a tidy format
    comb <- out %>%
      pivot_longer(S:P, 
                   names_to = "Box", 
                   values_to = "Number")
    comb$f <- fs[j]
    comb$p_init <- p_inits[i]
    
    df <- bind_rows(df, comb)
    
  }
}
