#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Modeling Complex Systems
Assignment 2
Mahalia Clark & Thomas O'Leary & Lily Shapiro
"""

# Part 1: Forest Fire CA -------------------------------------------------------

# Imports -----
import matplotlib.pyplot as plt
from matplotlib import colors
import numpy as np

# Parameters -----
n = 100 # size of space: n x n
q = 0.5 # probability of fire
radii = [1, 3] # list of neighborhood radii to test
densities = [i/10 for i in range(4, 11)] # list of densities to test
timesteps = 100 # total number of time steps to run the model
reps = 5 # number of stochastic trials to run for each initialization

# Define Functions -----
def initialize(d):
    config = np.zeros([n + 2*r, n + 2*r])
    for x in range(r, n + r):
        for y in range(r, n + r):
            # Light central fires
            if ((x == 49 + r or x == 50 + r) and (y == 49 + r or y == 50 + r)):
                config[x, y] = 2
            # Initialize trees
            elif np.random.random() < d:
                config[x, y] = 1
            # Rest empty
            else:
                config[x, y] = 0
    nextconfig = np.zeros([n + 2*r, n + 2*r])
    return config, nextconfig

def observe(config, t):
    # Plot forest
    cols = ['Black', 'darkgreen', 'orangered', 'grey']
    plt.cla()
    plt.imshow(config, vmin = 0, vmax = 3, cmap = colors.ListedColormap(cols))
    plt.title('time = %i' %t)
    plt.show()
    # Record Areas
    area_t = np.array([np.count_nonzero(config == i) for i in range(4)])
    return area_t

def update(config, nextconfig):
    for x in range(r, n + r):
        for y in range(r, n + r):
            count = 0
            for dx in range(-r, r + 1):
                for dy in range(-r, r + 1):
                    # Count up the number of burning trees in the neighborhood
                    if config[(x + dx), (y + dy)] == 2:
                        count += 1
                    else:
                        count += 0
            # Update Rules:
            p = 1 - (1 - q)**count
            # If you're a tree and you are surrounded by any fire, then you become on fire
            if config[x, y] == 1 and np.random.random() < p:
                nextconfig[x, y] = 2
            # If you're a tree but you are not surrounded by any fire, then you remain a tree
            elif config[x, y] == 1:
                nextconfig[x, y] = 1
            # If you're on fire, then you become an empty cell
            elif config[x, y] == 2:
                nextconfig[x, y] = 0
            # If you're an empty cell, you stay an empty cell
            elif config[x, y] == 0:
                nextconfig[x, y] = 0
    config, nextconfig = nextconfig, config
    return config, nextconfig

def model(timesteps, d):
    config, nextconfig = initialize(d)
    areas_time = np.zeros((timesteps, 4))
    area_0 = observe(config, 0)
    areas_time[0, :] = area_0
    for t in range(1, timesteps):
        config, nextconfig = update(config, nextconfig)
        area_t = observe(config, t)
        areas_time[t, :] = area_t
        areas_time[t, 3] = areas_time[t, 0] - areas_time[0, 0]
    return areas_time

# Run the model -----
areas = np.zeros((len(radii), len(densities), reps, timesteps, 4))

for r in range(0, len(radii)):
    for i in range(0, len(densities)):
        for rep in range(0, reps):
            areas[r, i, rep, :, :] = model(timesteps, densities[i])


# Plot areas over time for each parameter value -----
# Average areas across trials
areas_rep_avg = areas.mean(axis = 2)
np.save("areas_forest_fire_ca_q_{q}.npy".format(q = q), areas_rep_avg)

for r_i in range(0, len(radii)):
    for d_i in range(0, len(densities)):
        plt.figure()
        plt.plot([i for i in range(timesteps)],
                 areas_rep_avg[r_i, d_i, :, 1], 'darkgreen')
        plt.plot([i for i in range(timesteps)],
                 areas_rep_avg[r_i, d_i, :, 2], 'orangered')
        plt.plot([i for i in range(timesteps)],
                 areas_rep_avg[r_i, d_i, :, 3], 'grey')
        plt.legend(['Trees', 'Burning Trees', 'Burnt Trees'])
        plt.ylabel('Area')
        plt.xlabel('Time step')
        plt.title('Forest Fire Dynamics\n'
                  'radius = '+str(radii[r_i])+
                  ', density = '+str(densities[d_i])+'')
        plt.show()
        # Save plots
        r = radii[r_i]
        d = densities[d_i]
        plt.savefig("forest_fire_ca_q_{q}_r_{r}_d_{d}.png".format(r = r,
                                                                  d = d,
                                                                  q = q))

