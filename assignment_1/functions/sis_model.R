# ------------------------------------------------------------------------------
# Function: sis_model
# Description: SIS epidemic model system of differential eqns
# Inputs: state -- named vector of current values of S and I
#         params -- named vector of parameters for beta and gamma
# Outputs: named vector of derivative values at the state position

# Sample call:
# state <- c(S = 90, I = 10)
# params <- c(beta = 0.03, gamma = 0.25)
# slope <- sis_model(t = 0, state, params)

sis_model <- function(t, state, params) {
  # Define the variables in the state and parameters
  with(as.list(c(state, params)), {
    
    dS_dt <- -beta*S*I + gamma*I
    dI_dt <-  beta*S*I - gamma*I
    
    # Return data
    return(c(S = dS_dt, I = dI_dt))
  })
} 
# End function -----------------------------------------------------------------