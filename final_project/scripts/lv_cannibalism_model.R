# ------------------------------------------------------------------------------
# Modeling Complex Systems: Final Project
# November 19, 2020
# M Clark, TS O'Leary, J Rubin, & L Shapiro
# ------------------------------------------------------------------------------

# Load packages
require(tidyverse)
require(deSolve)

# Source all compartmental_models 
miceadds::source.all(here::here("final_project/compartmental_models"))

# Run the models ---------------------------------------------------------------

# Fixed Parameters
t_final <- 1000         # Total time to run the model
r_prey_fixed <- 0.5     # Reproduction rate of the prey
K_prey_fixed <- 1000    # Prey's carrying capacity
death_pred_fixed <- 0.1 # Death rate of the predator
prey_inits <- 30        # Initial number of prey individuals
prop_preds <- 1         # The proportion of predators based on the number of prey

# Parameters to sweep through
cannibalism <- c(0, 0.1) # Constant level of cannibalism for constant model
con_preds <- c(0.1, 0.5)   # Conversion factors for predation
ps <- c(0.1, 0.5)          # Predation rates

# Integrate the models -----

# Initialize a tibble to save the data in the for loop
result_total <- tibble()

for (n in 1:length(ps)) {
  for (m in 1:length(con_preds)) {
    for (k in 1:length(prop_preds)) {
      for (i in 1:length(prey_inits)) {
        # Set the parameters for the constant model
        params <- c(r_prey = r_prey_fixed, 
                    con_pred = con_preds[m], 
                    K_prey = K_prey_fixed, 
                    p = ps[n], 
                    death_pred = death_pred_fixed)
        
        # Integrate the constant model and then tidy the data.frame for plotting ease
        result <- as_tibble(ode(func = lv_cannibalism_func_prey, 
                                y = c(prey = prey_inits[i], 
                                      pred = prey_inits[i]*prop_preds[k]), 
                                parms = params, 
                                times = seq(0, t_final, by = 1))) %>%
          pivot_longer(pred:prey, names_to = "type", values_to = "N") %>%
          mutate(time = as.numeric(time),
                 N = as.numeric(N),
                 params = paste(paste0("model:func_prey,", 
                                       "prey_inits:", prey_inits[i]),
                                paste0("prop_pred:", prop_preds[k]),
                                paste(names(params), 
                                      params, 
                                      sep = ":", 
                                      collapse = ","),
                                sep = ","))
        
        # Save the results of the lv_cannabalism_func_prey to the total tidy df
        result_total <- bind_rows(result_total, result)
        
        for(j in 1:length(cannibalism)) {
          # Set the parameters for the constant model
          params <- c(r_prey = r_prey_fixed, 
                      con_pred = con_preds[m], 
                      K_prey = K_prey_fixed, 
                      p = ps[n], 
                      death_pred = death_pred_fixed, 
                      c = cannibalism[j])
          
          # Integrate the constant model and then tidy the data.frame for plotting ease
          result <- as_tibble(ode(func = lv_cannibalism_constant, 
                                  y = c(prey = prey_inits[i], 
                                        pred = prey_inits[i]*prop_preds[k]), 
                                  parms = params, 
                                  times = seq(0, t_final, by = 1))) %>%
            pivot_longer(pred:prey, names_to = "type", values_to = "N") %>%
            mutate(time = as.numeric(time),
                   N = as.numeric(N),
                   params = paste(paste0("model:constant,", 
                                         "prey_inits:", prey_inits[i]),
                                  paste0("prop_pred:", prop_preds[k]),
                                  paste(names(params), 
                                  params, 
                                  sep = ":", 
                                  collapse = ","),
                                  sep = ","))
          
          # Save the results to the total tidy data.frame
          result_total <- bind_rows(result_total, result)
        }
      }
    }
  }
}

# Save the results to a .rds file for final plotting and analysis in writeup
saveRDS(result_total, here::here("final_project/data/results_total.rds"))


# Roughly plot each result to a pdf just to quickly look at
plot_list <- vector(mode = "list", length = length(unique(result_total$params)))

for (i in 1:length(unique(result_total$params))){
  g <- ggplot(result_total %>%
               filter(params == unique(result_total$params)[i])) +
        geom_line(aes(x = time, y = N, color = type)) +
        labs(title = unique(result_total$params)[i],
             x = "Time", 
             y = "Number of each species") +
        scale_color_manual(name = "Species",
                           values = c("red", "blue"),
                           labels = c("Predator", "Prey")) +
        theme_classic()
  plot_list[[i]] <- g
}

pdf(here::here("final_project/plots/cannibalism_plots.pdf"), width = 10.75, height = 6)

for(i in 1:length(unique(result_total$params))){
  print(plot_list[[i]])
}

dev.off()

