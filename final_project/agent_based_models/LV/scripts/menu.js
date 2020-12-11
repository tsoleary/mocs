

function Menu() {
    let predatorColor = '#9A1313';
    let preyColor = '#139A92';
    let genericColor = '#D8DDDD';
    let numGlobalSliders = 3;

    resetButton = createButton("Reset");
    resetButton.mouseReleased(start);
    resetButton.position(12,15);

    reduceButton = createButton("Reduce");
    reduceButton.mouseReleased(reduce);
    reduceButton.position(70,15);

    backButton = createButton("Back");
    backButton.mouseReleased(back);
    backButton.position(140,15);

    function back() {
        window.location.href = "../index.html";
    }

    let numAgentsSlider = createSlider(0, 1000, numAgents);
    numAgentsSlider.position(10, 50);
    numAgentsSlider.style('width', '80px');
    numAgentsSlider.mouseReleased(updateNumAgents);

    myDiv = createDiv('Num Agents');
    myDiv.position(100, 48);
    myDiv.style('font-size', '19px');
    myDiv.style('color', genericColor);

    function updateNumAgents() {
        numAgents = numAgentsSlider.value();
    }

    let chancePredatorSlider = createSlider(0, 100, chancePredator * 100);
    chancePredatorSlider.position(10, 75);
    chancePredatorSlider.style('width', '80px');
    chancePredatorSlider.mouseReleased(updateChancePredator);

    myDiv = createDiv('% Predator');
    myDiv.position(100, 73);
    myDiv.style('font-size', '19px');
    myDiv.style('color', predatorColor);

    function updateChancePredator() {
        chancePredator = chancePredatorSlider.value()/100;
    }

    let agentSizeSlider = createSlider(1, 10, agentR);
    agentSizeSlider.position(10, 100);
    agentSizeSlider.style('width', '80px');
    agentSizeSlider.mouseReleased(updateAgentSize);

    myDiv = createDiv('Agent Size');
    myDiv.position(100, 98);
    myDiv.style('font-size', '19px');
    myDiv.style('color', genericColor);

    function updateAgentSize() {
        agentR = agentSizeSlider.value();
    }


    let predatorSpeedSlider = createSlider(0, 50, spec0speed);
    predatorSpeedSlider.position(10, 50 + 25 * numGlobalSliders);
    predatorSpeedSlider.style('width', '80px');
    predatorSpeedSlider.mouseReleased(updatePredSpeed);

    myDiv = createDiv('Speed');
    myDiv.position(100, 48 + 25 * numGlobalSliders);
    myDiv.style('font-size', '19px');
    myDiv.style('color', predatorColor);

    function updatePredSpeed() {
        spec0speed = predatorSpeedSlider.value();
        for (let i = 0; i < agents.length; i++) {
            if (agents[i].species === 0)
                agents[i].movementRange = predatorSpeedSlider.value();
        }
    }

    let preySpeedSlider = createSlider(0, 50, spec1speed);
    preySpeedSlider.position(10, 75 + 25 * numGlobalSliders);
    preySpeedSlider.style('width', '80px');
    preySpeedSlider.mouseReleased(updatePreySpeed);

    myDiv = createDiv('Speed');
    myDiv.position(100, 73 + 25 * numGlobalSliders);
    myDiv.style('font-size', '19px');
    myDiv.style('color', preyColor);

    function updatePreySpeed() {
        spec1speed = preySpeedSlider.value();

        for (let i = 0; i < agents.length; i++) {
            if (agents[i].species === 1)
                agents[i].movementRange = preySpeedSlider.value();
        }
    }

    let predatorReproductionSlider = createSlider(0, 100, spec0reproductionRate * 100);
    predatorReproductionSlider.position(10, 100 + 25 * numGlobalSliders);
    predatorReproductionSlider.style('width', '80px');
    predatorReproductionSlider.mouseReleased(updatePredReproduction);

    myDiv = createDiv('Reproduction');
    myDiv.position(100, 98 + 25 * numGlobalSliders);
    myDiv.style('font-size', '19px');
    myDiv.style('color', predatorColor);

    function updatePredReproduction() {
        spec0reproductionRate = predatorReproductionSlider.value();

        for (let i = 0; i < agents.length; i++) {
            if (agents[i].species === 0) {

                agents[i].reproductionRate = predatorReproductionSlider.value() / 100;
            }
        }
    }

    let preyReproductionSlider = createSlider(0, 100, spec1reproductionRate * 100);
    preyReproductionSlider.position(10, 125 + 25 * numGlobalSliders);
    preyReproductionSlider.style('width', '80px');
    preyReproductionSlider.mouseReleased(updatePreyReproduction);

    myDiv = createDiv('Reproduction');
    myDiv.position(100, 123 + 25 * numGlobalSliders);
    myDiv.style('font-size', '19px');
    myDiv.style('color', preyColor);

    function updatePreyReproduction() {
        spec1reproductionRate = preyReproductionSlider.value();

        for (let i = 0; i < agents.length; i++) {
            if (agents[i].species === 1)
                agents[i].reproductionRate = preyReproductionSlider.value()/100;
        }
    }



    let predatorStarveTimeSlider = createSlider(0, 2000, spec0StarveTime);
    predatorStarveTimeSlider.position(10, 150 + 25 * numGlobalSliders);
    predatorStarveTimeSlider.style('width', '80px');
    predatorStarveTimeSlider.mouseReleased(updatePredStarveTime);

    myDiv = createDiv('Time to Starve');
    myDiv.position(100, 148 + 25 * numGlobalSliders);
    myDiv.style('font-size', '19px');
    myDiv.style('color', predatorColor);

    function updatePredStarveTime() {
        spec0StarveTime = predatorStarveTimeSlider.value();

        for (let i = 0; i < agents.length; i++) {
            if (agents[i].species === 0) {

                agents[i].starveTime = predatorStarveTimeSlider.value();
            }
        }
    }

    let preyStarveTimeSlider = createSlider(0, 2000, spec1StarveTime);
    preyStarveTimeSlider.position(10, 175 + 25 * numGlobalSliders);
    preyStarveTimeSlider.style('width', '80px');
    preyStarveTimeSlider.mouseReleased(updatePreyStarveTime);

    myDiv = createDiv('Time to Starve');
    myDiv.position(100, 173 + 25 * numGlobalSliders);
    myDiv.style('font-size', '19px');
    myDiv.style('color', preyColor);

    function updatePreyStarveTime() {
        spec1StarveTime = preyStarveTimeSlider.value();

        for (let i = 0; i < agents.length; i++) {
            if (agents[i].species === 1) {

                agents[i].starveTime = preyStarveTimeSlider.value();
            }
        }
    }


    let predatorFOVSlider = createSlider(0, screen.width, int(spec0FOV));
    predatorFOVSlider.position(10, 200 + 25 * numGlobalSliders);
    predatorFOVSlider.style('width', '80px');
    predatorFOVSlider.mouseReleased(updatePredFOV);

    myDiv = createDiv('Field of View');
    myDiv.position(100, 198 + 25 * numGlobalSliders);
    myDiv.style('font-size', '19px');
    myDiv.style('color', predatorColor);

    function updatePredFOV() {
        spec0FOV = predatorFOVSlider.value();

        for (let i = 0; i < agents.length; i++) {
            if (agents[i].species === 0) {
                agents[i].FOV = predatorFOVSlider.value();
            }
        }
    }

    let preyFOVSlider = createSlider(0, screen.width, int(spec1FOV));
    preyFOVSlider.position(10, 225 + 25 * numGlobalSliders);
    preyFOVSlider.style('width', '80px');
    preyFOVSlider.mouseReleased(updatePreyFOV);

    myDiv = createDiv('Field of View');
    myDiv.position(100, 223 + 25 * numGlobalSliders);
    myDiv.style('font-size', '19px');
    myDiv.style('color', preyColor);

    function updatePreyFOV() {
        spec1FOV = preyFOVSlider.value();

        for (let i = 0; i < agents.length; i++) {
            if (agents[i].species === 1) {
                agents[i].FOV = preyFOVSlider.value();
            }
        }
    }

    myDiv = createDiv('Cannibalism');
    myDiv.position(12, 273 + 25 * numGlobalSliders);
    myDiv.style('font-size', '19px');
    myDiv.style('color', genericColor);

    noneButton = createButton("None");
    noneButton.mouseReleased(function() { updateCannibalism(cannibalismFunc.NONE);});
    noneButton.position(12, 300 + 25 * numGlobalSliders);

    constButton = createButton("Const");
    noneButton.mouseReleased(function() { updateCannibalism(cannibalismFunc.CONST);});
    constButton.position(12, 325 + 25 * numGlobalSliders);

    omniButton = createButton("Omni");
    noneButton.mouseReleased(function() { updateCannibalism(cannibalismFunc.OMNI);});
    omniButton.position(12, 350 + 25 * numGlobalSliders);

    hgryButton = createButton("Hgry");
    noneButton.mouseReleased(function() { updateCannibalism(cannibalismFunc.HGRY);});
    hgryButton.position(12, 375 + 25 * numGlobalSliders);

    function updateCannibalism(type) {
        cannibalismType = type
    }

}
