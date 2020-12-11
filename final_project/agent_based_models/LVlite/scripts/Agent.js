/**
 * Parent for hider and seeker agents
 */
function Agent(species, reproductionRate, deathRate, starveTime, FOV, speed) {
    this.species = species;
    this.reproductionRate = reproductionRate;
    this.deathRate = deathRate;
    this.starveTime = starveTime;
    this.FOV = FOV;

    this.cannibalism = false;

    this.timeSinceFeed = 0;
    this.x = 0;
    this.y = 0;
    this.moveX = 0;
    this.moveY = 0;
    this.movementRange = speed;

    if (species === 0) {
        this.r = 154;
        this.g = 19;
        this.b = 19;
    } else if (species === 1)  {
        this.r = 19;
        this.g = 154;
        this.b = 146;
    }

    // this.getBtnDistance = function(btn) {
    //     return (coordDistance(this.moveX + this.x, this.moveY + this.y, (btn.x+btn.height/2), (btn.y+btn.width/2)));
    // };

    // this.buttonDist = this.getBtnDistance(world.buttons[0]);

    this.spawn = function() {
        this.x = random(agentR,width-agentR);
        this.y = random(agentR,height-agentR);
    };


    this.step = function() {
        this.move();
    };



    /**
     * Get valid move
     */
    this.move = function() {
        this.getMove();
        this.x += this.moveX;
        this.y += this.moveY;

    };

    /**
     * Display agent
     */
    this.display = function() {
        stroke(this.r, this.g, this.b);
        fill(this.r, this.g, this.b);
        ellipse(this.x, this.y, agentR*2, agentR*2);
    };

    /**
     * Generate potential next movment
     * If making an invalid movement, set movement to 0
     */
    this.getMove = function() {
        // potential next move
        this.moveX = random(-this.movementRange,this.movementRange);
        this.moveY = random(-this.movementRange,this.movementRange);

        // newDist = this.getBtnDistance(world.buttons[0]);
        // displacement = this.buttonDist-newDist;
        // this.buttonDist = newDist;

        // make sure agent doesn't move out of bounds
        if (!this.isValidMove()) {
            this.moveX = 0;
            this.moveY = 0;
        }

    };

    /**
     * Checks potential next move for obstacles
     * @returns boolean true for valid move
     */
    this.isValidMove = function() {

        // only predator cannibalizes
        if (this.species === 0 && cannibalismType !== cannibalismFunc.NONE) {

            if (cannibalismType === cannibalismFunc.CONST) {
                this.cannibalism = Math.random() <= 0.0;

            } else if (cannibalismType === cannibalismFunc.OMNI) {
                let initialPrey = numAgents * (1-chancePredator);
                this.cannibalism = Math.random() <= (initialPrey + 1) / ((initialPrey + 1) + preyCounter * preyCounter);

            } else if (cannibalismType === cannibalismFunc.HGRY) {
                let hunger = this.timeSinceFeed / this.starveTime;
                this.cannibalism = Math.random() <= 1 / (1 + Math.pow(Math.E, -6 * hunger + 3));
            }
            // console.log(this.cannibalism);

        }

        let nextX = (this.x + this.moveX);
        let nextY = (this.y + this.moveY);
        let r;

        // make sure agents agents aren't overlapping
        let distY, distX, distance, oldDistY,
            oldDistX, oldDistance, closestRival = [-1, width],
            closestFood = [-1, width], foodDistY, foodDistX, foodDistance, oldFoodDistY,
            oldFoodDistX, oldFoodDistance;

        // make sure agent doesn't move out of bounds
        if (!(agentR <= nextX && nextX <= width-agentR) ||
            !(agentR <= nextY && nextY <= height-agentR)) {
            return false;
        }

        // make sure agents aren't moving through walls
        for (let i = 0; i < world.walls.length; i++) {
            r = world.walls[i];
            if (r.isActive) {
                if (circleIntersectingRect(nextX, nextY, r)) {
                    return false;
                }
            }
        }

        for (let i = 0; i < agents.length; i++) {
            if (this !== agents[i] && agents[i]) {

                // get distance between the circle's centers
                distX = nextX - agents[i].x;
                distY = nextY - agents[i].y;
                distance = sqrt((distX * distX) + (distY * distY));

                // store closest member of opposite species
                // TODO edit if adding cannibalism
                if (this.species !== agents[i].species ||
                    (this.species === 0 && this.cannibalism === true)) {

                    if (closestRival[1] > distance) {
                        closestRival[0] = i;
                        closestRival[1] = distance;
                    }
                }

                // what happens when agents overlap
                if (distance <= agentR * 2) {
                    if (this.species === 0 && agents[i].species === 1) {
                        if (Math.random() < this.reproductionRate) {
                            agents[i] = newSpec0();
                            this.timeSinceFeed = 0;
                            // console.log("Species 0 feeds and reproduces");
                        } else {
                            agents.splice(i, 1);
                        }
                        if (Math.random() < foodProductionRate)
                            world.addFood();

                        // TODO here is where cannibalism would potentially occur
                    } else if (this.species === 0 && agents[i].species === 0 && this.cannibalism === true) {
                        if (Math.random() < this.reproductionRate) {
                            agents[i] = newSpec0();
                            this.timeSinceFeed = 0;
                            // console.log("Species 0 cannibalizes and reproduces");
                        } else {
                            agents.splice(i, 1);
                        }
                        if (Math.random() < foodProductionRate)
                            world.addFood();
                    }
                    return false
                }

            }
        }

        if (this.species === 1) {
            // prey feeds on grass

            if (Math.random() <= spec1reproductionRate)
                agents.push(newSpec1());

        }

        if (closestRival[0] > 0) {

            oldDistX = this.x - agents[closestRival[0]].x;
            oldDistY = this.y - agents[closestRival[0]].y;
            oldDistance = sqrt((oldDistX * oldDistX) + (oldDistY * oldDistY));

            distX = nextX - agents[closestRival[0]].x;
            distY = nextY - agents[closestRival[0]].y;
            distance = sqrt((distX * distX) + (distY * distY));

            if (distance < this.FOV) {

                // you are a predator near prey
                if (this.species === 0) {
                    if (oldDistance < distance) {
                        return false;
                    }

                    // you are prey near a predator
                } else if (this.species === 1  && agents[closestRival[0]].species === 0) {
                    if (oldDistance > distance) {
                        return false;
                    }
                }
            } else if (this.species === 1 && closestFood[0] < world.food.length && closestFood[0] > 0) {
                oldFoodDistX = this.x - world.food[closestFood[0]].x;
                oldFoodDistY = this.y - world.food[closestFood[0]].y;
                oldFoodDistance = sqrt((oldFoodDistX * oldFoodDistX) + (oldFoodDistY * oldFoodDistY));

                foodDistX = nextX - world.food[closestFood[0]].x;
                foodDistY = nextY - world.food[closestFood[0]].y;
                foodDistance = sqrt((foodDistX * foodDistX) + (foodDistY * foodDistY));

                if (oldFoodDistance < foodDistance) {
                    return false;
                }

            }

        } else if (this.species === 1 && closestFood[0] < world.food.length && closestFood[0] > 0) {
            oldFoodDistX = this.x - world.food[closestFood[0]].x;
            oldFoodDistY = this.y - world.food[closestFood[0]].y;
            oldFoodDistance = sqrt((oldFoodDistX * oldFoodDistX) + (oldFoodDistY * oldFoodDistY));

            foodDistX = nextX - world.food[closestFood[0]].x;
            foodDistY = nextY - world.food[closestFood[0]].y;
            foodDistance = sqrt((foodDistX * foodDistX) + (foodDistY * foodDistY));

            if (oldFoodDistance < foodDistance) {
                return false;
            }
        }

        return true;
    };

    // don't let agents generate in invalid locations
    while (!this.isValidMove()) {
        this.spawn();
    }


}
