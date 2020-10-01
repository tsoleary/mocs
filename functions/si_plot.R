# ------------------------------------------------------------------------------
# Function: si_plot
# Description: description
# Inputs: input_description
# Outputs: output_description

si_plot <- function(dat) {
  p <- ggplot(data = dat) +
    geom_line(aes(x = t, 
                   y = Number, 
                   color = Box, 
                   linetype = method),
               alpha = 0.5) +
    labs(x = "Time", y = "Number of People in a Box",
         title = paste0("beta = ", df$beta[i],  "; h = ", df$h[i])) +
    scale_color_manual(values = c("firebrick", "darkblue")) +
    theme_classic()
  
  return(p)
} 
# End function -----------------------------------------------------------------