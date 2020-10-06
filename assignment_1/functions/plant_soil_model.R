# ------------------------------------------------------------------------------
# Function: plant_soil_model
# Description: System of differential eqns on carbon cycling in plants and soil
# Inputs: state -- named vector of current values of P and S
#         params -- named vector of parameters for photosynthsis, litter fall
#                   and soil and plant respiration
# Outputs: named vector of derivative values at the state position

# Sample call:
# state <- c(P = 10, S = 90)
# params <- c(photo = 0.1, l_fall = 0.07, p_resp = 0.03, s_resp = 0.07)
# slope <- plant_soil_model(t = 0, state, params)

plant_soil_model <- function(t, state, params) {
  # Define the variables in the state and parameters
  with(as.list(c(state, params)), {
    
    dP_dt <- (photo - l_fall - p_resp)*P
    dS_dt <-  l_fall*P - s_resp*S
    
    # Return data
    return(c(P = dP_dt, S = dS_dt))
  })
} 
# End function -----------------------------------------------------------------