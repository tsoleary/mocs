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
r = 1 # neighborhood radius
q = 0.6 # probability of fire
densities = [i/10 for i in range(1, 11)]
timesteps = 3

# Define Functions -----

def initialize():
    config = np.zeros([n + 2*r, n + 2*r])
    for x in range(r, n + r):
        for y in range(r, n + r):
            # Light central fires
            if ((x == 49+r or x ==50+r) and (y == 49+r or y == 50+r)):
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
    plt.cla()
    plt.imshow(config, vmin = 0, vmax = 3, cmap = colors.ListedColormap(['Black','darkgreen', 'orangered', 'grey']))
    plt.title('time = %i' %t)
    plt.show()
    # Record Areas
    areas = [np.count_nonzero(config == i) for i in range(4)]
    return areas


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


def model(timesteps):
    config, nextconfig = initialize()
    areas = []
    area_0 = observe(config, 0)
    areas.append(area_0)
    for t in range(1, timesteps):
        config, nextconfig = update(config, nextconfig)
        area_i = observe(config, t)
        areas.append(area_i)
        areas[t][3] = areas[t][0] - areas[0][0]
    return areas


# Run the model -----
for d in densities:
    model(timesteps)

# areas = model(timesteps)
# areas = np.array(areas)
# areas = areas.T
# Plot areas over t:
# plt.figure(1)
# plt.plot([i for i in range(timesteps)], areas[:, 1:4], label = ('Trees', 'Burning Trees', 'Burned Trees'))
# plt.legend()
# To do: fix legends in area time plots:
# Loop through multiple trials, collect data on final areas for each scenario, 5 trials each
# Calculate means and SDs for each trial to report in a final table in the write up
# 5 trials each for:
    # 2 radii (1, 3)
    # 10 d values [0.1 to 1 by 0.1]
    # 1 q value = 0.5 --> we can just say in our write up how this has a big
    #effect on behavior and it's something that could be explored further.
