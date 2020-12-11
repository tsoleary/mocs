/**
 * Agent intersects with rect
 * @param nextX
 * @param nextY
 * @param r
 * @returns {boolean}
 */
circleIntersectingRect = function(nextX, nextY, r) {
    // temporary variables to set edges for testing
    testX = nextX;
    testY = nextY;

    // which edge is closest?
    if (nextX < r.x)               testX = r.x;          // test left edge
    else if (nextX > r.x+r.width)  testX = r.x+r.width;  // right edge
    if (nextY < r.y)               testY = r.y;          // top edge
    else if (nextY > r.y+r.height) testY = r.y+r.height; // bottom edge

    // get distance from closest edges
    distX = nextX-testX;
    distY = nextY-testY;
    distance = sqrt( (distX*distX) + (distY*distY));

    // if the distance is less than the radius, collision!
    return distance <= agentR;
};

/**
 * Recteangle intersection
 * @param r1
 * @param r2
 * @returns {boolean}
 */
rectIntersectingRect = function(r1, r2) {

    // are the sides of one rectangle touching the other?
    return r1.x + r1.width >= r2.x &&    // r1 right edge past r2 left
        r1.x <= r2.x + r2.width &&    // r1 left edge past r2 right
        r1.y + r1.height >= r2.y &&    // r1 top edge past r2 bottom
        r1.y <= r2.y + r2.height;

};

/**
 * Get the distance between two coordinate pairs
 * @param x1
 * @param y1
 * @param x2
 * @param y2
 */
coordDistance = function(x1,y1,x2,y2) {
    return Math.sqrt((x1-x2)**2+(y1-y2)**2);
};

rotateCoord = function(px, py, angle) {

    let rotX = centerX + Math.cos(angle) * (px - centerX) - Math.sin(angle) * (py - centerY);
    let rotY = centerY + Math.sin(angle) * (px - centerX) + Math.cos(angle) * (py - centerY);

    return [rotX, rotY];

};


const mod = (x, n) => (x % n + n) % n;
