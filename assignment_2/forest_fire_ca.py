"""
Created on Thu Oct 22 13:28:51 2020

@authors: Mahalia Clark & Thomas O'Leary & Lily Shapiro'

"""

########## Part 1: Forest Fire CA ##########

###### Imports #####

import matplotlib.pyplot as plt
from matplotlib import colors
import numpy as np


##### Parameters #####
n = 100 # size of space: n x n
#d = 0.1 # density of trees in our forest
r = 1 # Moore neighborhood radius
f_init = 0.001 # initial density of fires
densities = [i/10 for i in range(1, 11)]
timesteps = 3

###### Define IOU Functions #####

def initialize():
    global config, nextconfig
    config = np.zeros([n + 2*r, n + 2*r])
    for x in range(r, n + r):
        for y in range(r, n + r):
            # Initialize trees
            if np.random.random() < d:
                if np.random.random() < f_init:
                    # Start Fire!
                    config[x, y] = 2
                else:
                    # Make regular tree
                    config[x, y] = 1
            # Rest empty
            else:
                config[x, y] = 0
    nextconfig = np.zeros([n + 2*r, n + 2*r])
    
def observe(t):
    global config, nextconfig
    plt.cla()
    plt.imshow(config, vmin = 0, vmax = 2, cmap = 'viridis')
    plt.title('time = %i' %t)
    plt.show()

def update():
    global config, nextconfig
    for x in range(r, n + r):
        for y in range(r, n + r):
            count = 0
            for dx in [-r, 0, r]:
                for dy in [-r, 0, r]:
                    # Count up the number of burning trees in the neighborhood
                    if config[(x + dx), (y + dy)] == 2:
                        count += 1
                    else:
                        count += 0
            # Update Rules:
            # If you're a tree and you are surrounded by any fire, then you become on fire
            if config[x, y] == 1 and count >= 1:
                nextconfig[x, y] = 2
            # If you're a tree but you are not surrounded by any fire, then you remain a tree
            elif config[x, y] == 1 and count < 1:
                nextconfig[x, y] = 1
            # If you're not a tree, then you remain not a tree
            elif config[x, y] == 0:
                nextconfig[x, y] = 0
            # If you're on fire, then you become an empty cell
            elif config[x, y] == 2:
                nextconfig[x, y] = 0
    config, nextconfig = nextconfig, config

def model(timesteps):
    initialize()
    for t in range(timesteps):
        observe(t)
        update()

##### Do Stuff #####

for d in densities:
    model(timesteps)
