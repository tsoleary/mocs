# ------------------------------------------------------------------------------
# Function: voter_model
# Description: Voter model function
# Inputs: Data.frame of nodes and data.frame of edges, initial party column, 
#         and a number of timesteps to run the model
# Outputs: returns a list with the final map, the changes, and the number 
#          of blue states

# Load required packages
require(tidyverse)

# Example call
# voter_model(nodes, edges, "party_2016", n_timesteps = 10000)

voter_model <- function(df_nodes, df_edges, init_party_col, n_timesteps = 10000) {
  
  # Initialize the current party
  nodes$current_party <- pull(nodes, init_party_col)
  
  # Intialize a vector to store the number of blue states at each time point
  n_blue <- vector(mode = "numeric", length = n_timesteps)
  
  for (t in 1:n_timesteps) {
    
    # Pick a random node
    rand_node <- sample(states, 1)
    
    # Find the neighbors of that node
    neighbors <- edges %>%
      filter(X1 == rand_node | X2 == rand_node)
    
    # Pick a random neighbor
    rand_row <- sample(nrow(neighbors), 1)
    edge <- as.character(neighbors[rand_row,]) 
    rand_neighbor <- edge[!edge %in% rand_node]
    
    # Store the number of blue states at each time point
    n_blue[t] <- sum(nodes$current_party == "blue")
    
    # Change the current_party of the_chosen_node to the 
    # party of the_chosen_neighbor
    rand_neighbors_party <- 
      nodes$current_party[nodes$state == rand_neighbor]
    
    nodes$current_party[which(nodes$state == rand_node)] <- 
      rand_neighbors_party
    
  }
  
  # Return a list with the final map, the changes, and the number of blue states
  return(list(party_final = nodes$current_party, 
              n_blue = n_blue))
  
} 
# End function -----------------------------------------------------------------