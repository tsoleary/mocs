# ------------------------------------------------------------------------------
# Function: lv_cannibalism_func_prey
# Description: a modified Lotka-Volterra Model with cannabalism based on the 
#              amount of prey around
# Inputs: time - a vector of time
#         state - current state of the system, pred and prey levels
#         params - r_prey, r_pred, K_prey, p, death_pred, c
# Outputs: list of time derivatives for pred and prey

lv_cannibalism_complex <- function (time, state, params) {
  with(as.list(c(state, params)), {
    d_prey = prey*(r_prey*(1 - prey/K_prey) - p*pred)
    d_pred = pred*(p*r_pred*prey - (K_prey/(K_prey + prey^2))*pred - death_pred)
    return(list(c(d_prey, d_pred)))
  })
}
# End function -----------------------------------------------------------------