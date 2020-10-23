#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct 22 13:28:51 2020

@authors: Mahalia Clark & Thomas O'Leary & Lily Shapiro'

"""

########## Part 2: DLA ##########

###### Imports #####

import matplotlib.pyplot as plt
from matplotlib import colors
import numpy as np


##### Parameters #####

#Params to run fast and watch snowglobe!
n = 15 # size of space: n x n (make it odd!)
d = 0.1 # density of particles entering the space
timesteps = 75
observe_step = 1


# Params to get the prettiest snowflakes!
# n = 49 # size of space: n x n (make it odd!)
# d = 0.0001 # density of particles entering the space
# timesteps = 21000
# observe_step = 1000


###### Define IOU Functions #####

def initialize():
    config = np.zeros([n, n])
    # Add central seed:  
    config[int((n-1)/2), int((n-1)/2)] = 2   
    nextconfig = np.zeros([n, n])
    return config, nextconfig
    
def add_snowflakes(config):
    # Add random particles to border
    for y in [0, n-1]:
        for x in range(n):  
            if np.random.random() < d:
                config[x, y] = 1   
    for x in [0, n-1]:
        for y in range(n):  
            if np.random.random() < d:
                config[x, y] = 1   
    return config
    
def observe(config, t = 0):
    plt.cla()
    plt.imshow(config, cmap = colors.ListedColormap(['Black','lightsteelblue', 'ghostwhite']))
    plt.title('time = %i' %t)
    plt.show()

def update(config, nextconfig):
    for x in range(n):
        for y in range(n):
            # If you're a particle and you're touching a seed, freeze
            if (config[x, y] == 1):
                rand = np.random.random()
                for dx in [-1, 0, 1]:
                    for dy in [-1, 0, 1]:
                        if (config[(x + dx) % n, (y + dy) % n] == 2):
                            nextconfig[x, y] = 2
                # If you're a particle you move up, down, left, or right with equal prob
                if nextconfig[x, y] == 2:
                    continue
                else:
                    if rand < 0.25:
                        nextconfig[x, (y + 1) % n] = 1
                    elif rand < 0.5:
                        nextconfig[x, (y - 1) % n] = 1
                    elif rand < 0.75:
                        nextconfig[(x - 1) % n, y] = 1
                    else:
                        nextconfig[(x + 1) % n, y] = 1
            # If you're a seed you stay a seed
            if config[x, y] == 2:
                nextconfig[x, y] = 2
    config, nextconfig = nextconfig, config
    # Clear nextconfig
    for x in range(n):
        for y in range(n):
            nextconfig[x, y] = 0
    return config, nextconfig

def model(timesteps):
    config, nextconfig = initialize()
    config = add_snowflakes(config)
    for t in range(timesteps):
        config, nextconfig = update(config, nextconfig)
        config = add_snowflakes(config)
        if t % observe_step == 0:
            observe(config, t)


# ##### Do Stuff #####

model(timesteps)

# config, nextconfig = initialize()
# config = add_snowflakes(config)
# observe(config)
# update(config, nextconfig)
# observe(nextconfig)