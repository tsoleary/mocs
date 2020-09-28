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

# Need to figure out how to make the eulers method generalizable beyond sis model

# Create Euler's method function ----

# ------------------------------------------------------------------------------
# Function: euler_method
# Description: Euler's method
# Inputs: function, 
# Outputs: data.frame

euler_method <- function(funct, h, n_steps, state, params) {
  
  # Initialize vectors
  s <- vector(mode = "numeric", length = n_steps)
  i <- vector(mode = "numeric", length = n_steps)
  t <- vector(mode = "numeric", length = n_steps)
  s[1] <- state["S"]
  i[1] <- state["I"]
  t[1] <- 0

  # Iterate through the function for n_steps
  for (n in 1:n_steps) {
    s[n + 1] <- s[n] + h * funct(t[n], state, params)[[1]]["S"]
    i[n + 1] <- i[n] + h * funct(t[n], state, params)[[1]]["I"]
    t[n + 1] <- t[n] + h
    state["S"] <- s[n + 1]
    state["I"] <- i[n + 1]
  }
  
  # Return resulting vectors in a data.frame
  return(data.frame(S = s, I = i, Time = t))
  
} 
# End function -----------------------------------------------------------------

# Create Heun's method function ----

# ------------------------------------------------------------------------------
# Function: heun_method
# Description: description
# Inputs: input_description
# Outputs: output_description

heun_method <- function() {
  # function body

} 
# End function -----------------------------------------------------------------



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

# Create SIS model function -----

# ------------------------------------------------------------------------------
# Function: sis_model
# Description: description
# Inputs: input_description
# Outputs: output_description

sis_model <- function(t, state, params) {
  
  with(as.list(c(state, params)), {
    
    S_dot <- (-beta * S * I) + (gamma * I)
    I_dot <- (beta * S * I) - (gamma * I)
    
    return(list(c(S = S_dot, I = I_dot)))
    
  })
  
} 
# End function -----------------------------------------------------------------





# Inital state of the system
state <- c(S = 90, I = 10)

# Infection and Recovery parameters
params <- c(beta = 0.03, gamma = 0.25)


out <- euler_method(sis_model, h = 0.1, n_steps = 50, params = params, state = state)

require(tidyverse)


out <- out %>%
  pivot_longer(S:I, names_to = "Box", values_to = "Number")


# Plotting ----
ggplot(data = out) +
  geom_line(aes(x = Time, y = Number, color = Box)) +
  ylim(c(0, 100)) +
  theme_classic()








# 
