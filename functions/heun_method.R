# ------------------------------------------------------------------------------
# Function: heun_method
# Inputs: function - function to numerically integrate
#         h - the step-size (i.e. delta time)
#         init_conds - a named vector of initial conditions
#         params - a named vector of parameters to be passed to the function
# Outputs: data.frame with soln values with 
#            n_step + 1 rows and n_dims + 1 columns

# Example call:
# # Inital state of the system
# initial_state <- c(S = 90, I = 10)
# 
# # Infection and Recovery parameters
# parameters <- c(beta = 0.03, gamma = 0.25)
# 
# # Implement Euler's method
# out <- heun_method(sis_model, 
#                    h = 0.1,
#                    n_steps = 50, 
#                    params = parameters, 
#                    init_conds = initial_state)



heun_method <- function(funct, h, n_steps, init_conds, params, t_0 = 0) {
  
  # Create an empty solution matrix with n_step + 1 rows and n_dims + 1 columns
  mat <- matrix(nrow = n_steps + 1, ncol = length(init_conds) + 1)
  
  # Initialize values
  mat[1, ] <- c(t_0, init_conds)
  state <- init_conds
  
  # Iterate through the function for n_steps
  for (n in 2:(n_steps + 1)) {
    state_euler <- state + h * funct(t[n], state, params)
    state <- state + h * ((funct(t[n], state, params) + 
                             funct(t[n], state_euler, params))/2)
    t <- mat[n - 1, 1] + h
    mat[n, ] <- c(t, state)
  }
  
  # Return data.frame with column names
  df <- data.frame(mat)
  colnames(df) <- c("t", names(init_conds))
  return(df)
  
} 
# End function -----------------------------------------------------------------