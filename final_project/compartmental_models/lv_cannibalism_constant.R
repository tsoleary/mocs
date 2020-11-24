# ------------------------------------------------------------------------------
# Function: lv_cannibalism_constant
# Description: a modified Lotka-Volterra Model with constant level of predator 
#              cannibalism
# Inputs: time - a vector of time
#         state - current state of the system, pred and prey levels
#         params - r_prey, r_pred, K_prey, p, death_pred, c
# Outputs: list of time derivatives for pred and prey

lv_cannibalism_constant <- function (time, state, params) {
  with(as.list(c(state, params)), {
    d_prey = prey*(r_prey*(1 - prey/K_prey) - p*pred)
    d_pred = pred*(p*con_pred*prey - c*pred - death_pred)
    return(list(c(d_prey, d_pred)))
  })
}
# End function -----------------------------------------------------------------