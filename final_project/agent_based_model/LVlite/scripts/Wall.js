//TODO hardcode color

/**
 * Wall class
 * @param color
 * @param x
 * @param y
 * @param height
 * @param width
 */
function Wall(color, x, y, width, height) {

    this.color = color;
    this.x = x;
    this.y = y;
    this.height = height;
    this.width = width;
    this.isActive = true;

    /**
     * Display wall
     */
    this.display = function() {
        stroke(this.color);
        fill(this.color);
        rect(this.x, this.y, this.width, this.height);

        // only desplay if active
        if (this.isActive) {
            stroke(this.color);
            fill(this.color);
            rect(this.x, this.y, this.width, this.height);
        }
    };
}

/**
 * Wall class
 * @param color
 * @param x
 * @param y
 * @param height
 * @param width
 */
function Door(color, x, y, width, height) {

    Wall.call(this, color, x, y, width, height);

    /**
     * Display wall
     */
    this.display = function() {
        this.isActive = true;
        for (let i = 0; i < world.buttons.length; i++) {
            if (world.buttons[i].hasIntersections) {
                this.isActive = false;
            }
        }

        // only desplay if active
        if (this.isActive) {
            stroke(this.color);
            fill(this.color);
            rect(this.x, this.y, this.width, this.height);
        }
    };
}

/**
 * Button class
 * @param color
 * @param x
 * @param y
 * @param height
 * @param width
 */
function Button(color, x, y, width, height) {
    Wall.call(this, color, x, y, width, height);

    this.hasIntersections = false;
    /**
     * Display button
     */
    this.display = function() {

        // check for button intersection
        this.hasIntersections = false;
        for (let i = 0; i < agents.length; i++) {
            try {
                if (circleIntersectingRect(agents[i].x, agents[i].y, this)) {
                    this.hasIntersections = true;
                }
            } catch {
                console.log("button display err");
            }
        }

        // show button press
        if (this.hasIntersections) {
            stroke(92,66,112);
            fill(92,66,112);
        } else {
            stroke(this.color);
            fill(this.color);
        }
        rect(this.x, this.y, this.width, this.height);
    };

}

/**
 * Button class
 * @param color
 * @param x
 * @param y
 * @param height
 * @param width
 */
function Finish(color, x, y, width, height) {
    Button.call(this, color, x, y, width, height);

    this.hasIntersections = false;

    /**
     * Display button
     */
    this.display = function() {

        // check for button intersection
        this.hasIntersections = false;
        for (let i = 0; i < agents.length; i++) {
            if (circleIntersectingRect(agents[i].x, agents[i].y, this)) {
                this.hasIntersections = true;
            }
        }

        // show button press
        if (this.hasIntersections) {
            stroke(40,113,19);
            fill(40,113,19);
        } else {
            stroke(201,20,19);
            fill(201,20,19);
        }
        rect(this.x, this.y, this.width, this.height);
    };

}

