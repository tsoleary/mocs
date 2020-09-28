# ------------------------------------------------------------------------------
# MoCS: Assignment 1
# September 25, 2020
# M Clark & TS O'Leary
# ------------------------------------------------------------------------------


# Question 3: Create 

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

# ------------------------------------------------------------------------------
# Function: s_dot
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

ggplot(data = out) +
  geom_line(aes(x = Time, y = Number, color = Box)) +
  ylim(c(0, 100)) +
  theme_classic()
