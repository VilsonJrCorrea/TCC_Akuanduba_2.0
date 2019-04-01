var robot = require("robotjs");

async function writeAndEnter(text) {
    await robot.typeString(text);
    await pressEnter();
}
async function moveAndClick(mouse) {
    await robot.moveMouse(mouse.x, mouse.y);
    await robot.mouseClick("left", false);
}

async function pressEnter() {
    await robot.keyToggle("enter", "down", []);
    await robot.keyToggle("enter", "up", []);
}

async function pressCrtlC() {
    for (i = 0; i < 3; i++) {
        await robot.keyToggle("c", "down", "control");
        await robot.keyToggle("c", "up", "control");
    }
}

module.exports = {
    writeAndEnter,
    moveAndClick,
    pressEnter,
    pressCrtlC
}