# ------------------------------------------------------------------------------
# Function: plant_soil_model
# Description: System of differential eqns on carbon cycling in plants and soil
# Inputs: state -- named vector of current values of P and S
#         params -- named vector of parameters for photosynthsis, litter fall
#                   and soil and plant respiration
# Outputs: named vector of derivative values at the state position

# Sample call:
# state <- c(P = 10, S = 90)
# params <- c(p = 0.1, f = 0.07, r_s = 0.03, s_r = 0.07)
# slope <- plant_soil_model(t = 0, state, params)

plant_soil_model <- function(t, state, params) {
  # Define the variables in the state and parameters
  with(as.list(c(state, params)), {
    
    dP_dt <- (p - f - r_s)*P
    dS_dt <-  f*P - s_r*S
    
    # Return data
    return(c(P = dP_dt, S = dS_dt))
  })
} 
# End function -----------------------------------------------------------------