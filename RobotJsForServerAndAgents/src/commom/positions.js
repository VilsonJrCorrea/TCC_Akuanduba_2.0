var robot = require("robotjs");
const { delayLeituraPontos } = require('../config/config.json')


async function getPositions(qtd) {
    console.log("Iniciando processo de analise de pontos na tela...")
    const positions = [];
    for (i = 0; i < qtd; i++) {
        const mouse = await getPosition(i);
        positions.push(mouse);
    }
    console.log('Resultado final ', positions);
    return positions;
}

function getPosition(i) {
    console.log(`Posicione o mouse no ponto ${i + 1}`)
    return new Promise((resolve, reject) => {
        setTimeout(function () {
            const mouse = robot.getMousePos();
            resolve(mouse);
            console.log(`Lido com sucesso! Mouse ${i + 1} na posição x: ${mouse.x} e y: ${mouse.y}`)
        }, delayLeituraPontos);
    })
}

module.exports = { getPositions }
