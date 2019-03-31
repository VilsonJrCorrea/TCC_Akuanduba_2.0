const robot = require("robotjs");
const { getPositions } = require('../commom/positions')
const { writeAndEnter, moveAndClick, pressEnter, pressCrtlC } = require('../commom/commands')
const { qtdPositions, partidas, posicaoServidor, delayMouse, delayTeclado, tempoPartida } = require('../config/config.json')

main();

async function main() {
	init();
	// const qtdPositions = 5; //0 - servidor - 1 e 2 - eclipse start - 3 e 4 eclipse close
	const positions = await getPositions(qtdPositions);
	for (contPartida = 0; contPartida < partidas.length; contPartida++) {
		await initServer(positions[posicaoServidor], partidas[contPartida]);
		await beginMatch(positions);
		await waitMatchFinish(contPartida, positions);
		await dropAgents(positions, contPartida);
		await closeMatch(positions[posicaoServidor], contPartida);
	}
}


function init() {
	robot.setMouseDelay(delayMouse);
	robot.setKeyboardDelay(delayTeclado);
}

async function initServer(position, choose) {
	await moveAndClick(position);
	await writeAndEnter("java -jar server-2018-1.1-jar-with-dependencies.jar");
	await writeAndEnter(choose);
}

async function beginMatch(positions) {
	for (i = 1; i < 3; i++) {
		await moveAndClick(positions[i]);
	}
	await moveAndClick(positions[posicaoServidor]);
	await pressEnter();
}

async function waitMatchFinish(contPartida, positions) {
	console.log(`Iniciou a partida ${contPartida}/${partidas.length}`);
	const promise = new Promise((resolve, reject) => {
		setTimeout(function () {
			console.log(`Acabou o tempo da partida ${contPartida}! Iniciando o processo de derrubar e inicar outra partida`)
			resolve();
		}, tempoPartida);
	});
	while (!promise.then()) {
		console.log("---")
	}
	return promise;
}


async function dropAgents(positions, contPartida) {
	for (i = 3; i < positions.length; i++) {
		await moveAndClick(positions[i]);
	}
	console.log(`Agentes da partida ${contPartida}/${partidas.length-1} derrubados!`)
}

async function closeMatch(position, contPartida) {
	await moveAndClick(position);
	await pressCrtlC();
	console.log(`Partida ${contPartida}/${partidas.length-1} encerrada!`)
}