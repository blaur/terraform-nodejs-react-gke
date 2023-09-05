import { AppDataSource } from "./data-source"
import { NicenessModel } from "./entity/NicenessModel"

export function initDatabase() { 
    AppDataSource.initialize().then(async () => {

        console.log("Inserting a new niceness into the database...")
        const niceness = new NicenessModel();
        const nicenessScore = Math.round(Math.random() * 1000);
        niceness.name = `Nicing it up level ${nicenessScore}`;
        niceness.nicenessScore = nicenessScore;

        await AppDataSource.manager.save(niceness)
        console.log("Saved a new niceness model with id: " + niceness.id)

        console.log("Loading niceness models from the database...")
        const nicenessModels = await AppDataSource.manager.find(NicenessModel)
        console.log("Loaded niceness models: ", nicenessModels)

        console.log("Here you can setup and run express / fastify / any other framework.")

    }).catch(error => console.log(error))
}