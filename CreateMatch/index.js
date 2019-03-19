var fs = require('fs');

const upgrade = require('./upgrades')
const entities = require('./entities');

main();

function main() {
    ids = ["Berlin", "Copenhagen", "SaoPaulo", "Paris"];
    maps = ["berlin", "copenhagen", "saopaulo", "paris"];
    minLons = [13.35, 12.47, -46.73, 2.26];
    maxLons = [13.5, 12.58, -46.53, 2.41];
    minLats = [52.44, 55.6, -23.65, 48.82];
    maxLats = [52.54, 55.71, -23.52, 48.90];
    centerLats = [52.5, 55.65, -23.6, 48.8424];
    centerLons = [13.4, 12.5, -46.6, 2.3209];
    for (j = 0; j < 4; j++) {
        const data = [];
        for (i = 0; i < 50; i++) {
            const obj = createObjectMatch(ids[j], maps[j], maxLats[j], maxLons[j], minLats[j], minLons[j], centerLats[j], centerLons[j], i);
            data.push(obj);
        }
        writeFile(data, ids[j]);
    }
}

function writeFile(data, name) {
    fs.writeFile("match" + name + ".json", JSON.stringify(data, null, 4), (err) => {
        if (err) {
            console.log(err);
            return;
        }
        console.log("Arquivo gravado com sucesso!")
    })
}

function createObjectMatch(id, map, maxLat, maxLon, minLat, minLon, centerLat, centerLon, seed) {
    return match = {
        "id": id,
        "scenarioClass": "city.CitySimulation",
        "steps": 1000,
        "map": map,
        "seedCapital": 5000,
        "minLon": minLon,
        "maxLon": maxLon,
        "minLat": minLat,
        "maxLat": maxLat,
        "centerLon": centerLon,
        "centerLat": centerLat,
        "proximity": 5,
        "cellSize": 200,
        "randomSeed": seed,
        "randomFail": 1,
        "gotoCost": 1,
        "rechargeRate": 0.3,
        "upgrades": upgrade,
        "roles": "$(roles/roles.json)",
        "entities": entities,
        "generate": "$(generate/generate.json)"
    }
}

// console.log(obj);