# ------------------------------------------------------------------------------
# MoCS: Assignment # 3
# November 13, 2020
# TS O'Leary, Lily Shapiro, & Mahalia Clark
# ------------------------------------------------------------------------------

# Load packages and functions
require(tidyverse)
require(igraph)
source(here::here("assignment_3/functions/voter_model.R"))


# Edges ------------------------------------------------------------------------ 
# Read edge list
edges <- read_csv("~/R/mocs/assignment_3/data/state_edge_list.csv", 
                  col_names = FALSE)

# Nodes ------------------------------------------------------------------------
# List of the states (and DC) that are included in the major component
states <- unique(c(edges$X1, edges$X2))

# Load population numbers for each of those states
state_pop <- read_csv("~/R/mocs/assignment_3/data/state_pop.csv") %>%
  filter(year == 2013, ages == "total") %>%
  filter(state %in% states) %>%
  select(state, population)

# Load the 2016 Presidential winner for each state in the map
state_pres_party <- read_csv(
  "~/R/mocs/assignment_3/data/1976-2016-president.csv"
  ) %>%
  filter(year == 2016) %>%
  select(state, candidatevotes, party) %>%
  group_by(state) %>%
  slice_max(order_by = candidatevotes) %>%
  filter(state %in% states) %>%
  mutate(party_2016 = case_when(party == "republican" ~ "red",
                           party == "democrat" ~ "blue"))

# Join these data frames
nodes <- left_join(state_pop, state_pres_party)

# Add the degree of the nodes to the nodes data.frame
node_degree <- degree(graph_from_data_frame(d = edges, 
                                            vertices = nodes, 
                                            directed = FALSE), 
                      mode = "all")
nodes$degree <- node_degree[match(nodes$state, names(node_degree))]

# Initialize a column with random party assignments
party_rand <- sample(c("red", "blue"), 
                     size = length(states),
                     replace = TRUE)

nodes$party_rand <- party_rand

# Initialize a column with party based on a degree cut off
nodes <- nodes %>%
  mutate(party_deg = case_when(degree <= 4 ~ "red",
                               degree > 4~ "blue"))


# Create network ---------------------------------------------------------------

# Create a network object
net <- graph_from_data_frame(d = edges, vertices = nodes, directed = FALSE)


# # Run the voter model on three sets of initial conditions for 5 reps each ------
# init_cols <- c("party_2016", "party_rand", "party_deg")
# n_timesteps <-  10000
# num_reps <- 20
# time_df <- tibble(time = 1:n_timesteps) 
# 
# for (i in 1:length(init_cols)){
#   
#   for (rep in 1:num_reps) {
#     # Run the model
#     result <- voter_model(nodes, edges, init_cols[i], n_timesteps = n_timesteps)
#     
#     # Store the result
#     nodes[, paste(init_cols[i], rep, sep = ":")] <- result$party_final
#     time_df[, paste(init_cols[i], rep, sep = ":")] <- result$n_blue
#   }
#   
# }

# # Save the time_df data.frame to load in the write_up
# saveRDS(time_df, "~/R/mocs/assignment_3/data/time_df.rds")
# # Save the nodes too
# saveRDS(nodes, "~/R/mocs/assignment_3/data/nodes.rds")

# Read in the nodes and time_df data run earlier
time_df <- readRDS("~/R/mocs/assignment_3/data/time_df.rds")
nodes <- readRDS("~/R/mocs/assignment_3/data/nodes.rds")
