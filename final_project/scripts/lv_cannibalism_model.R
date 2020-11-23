# ------------------------------------------------------------------------------
# Modeling Complex Systems: Final Project
# November 19, 2020
# M Clark, TS O'Leary, J Rubin, & L Shapiro
# ------------------------------------------------------------------------------

# Load packages
require(tidyverse)
require(deSolve)

# Source all functions 
miceadds::source.all(here::here("final_project/functions"))

# Run the model ----------------------------------------------------------------

# Fixed Parameters
t_final <- 1000
prop_pred <- 0.10

# Parameters to sweep through
cannibalism <- c(0, 0.01, 0.1, 0.5)
prey_inits <- c(150, 250, 350) 

# Integrate the models
result_total <- tibble()

# Integrate the models
for (i in 1:length(prey_inits)) {
  # Set the parameters
  params <- c(r_prey = 0.5, 
              r_pred = 0.5, 
              K_prey = 250, 
              p = .1, 
              death_pred = .2, 
              c = cannibalism[1])
  
  # Integrate the model and then tidy the data.frame for plotting ease
  result <- as_tibble(ode(func = lv_cannibalism_constant, 
                          y = c(prey = prey_inits[i], 
                                pred = prey_inits[i]*prop_pred), 
                          parms = params, 
                          times = seq(0, t_final, by = 1))) %>%
    pivot_longer(pred:prey, names_to = "type", values_to = "N") %>%
    mutate(time = as.numeric(time),
           N = as.numeric(N),
           params = paste(paste0("model:constant,", 
                                 "prey_inits:", prey_inits[i]),
                          paste0("prop_pred:", prop_pred),
                          paste(names(params), 
                          params, 
                          sep = ":", 
                          collapse = ","),
                          sep = ","))
  
  result_total <- bind_rows(result_total, result)
}



ggplot(data = result[[3]]) +
  geom_line(aes(x = time, y = N, color = type)) +
  theme_classic()



