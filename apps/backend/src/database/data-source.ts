import "reflect-metadata"
import { DataSource } from "typeorm"
import { NicenessModel } from "./entity/NicenessModel"

export const AppDataSource = new DataSource({
    type: "postgres",
    host: process.env.PGHOST || "localhost",
    port: process.env.PGPORT ? Number(process.env.PGPORT) : 5432,
    username: process.env.PGUSER || "postgres",
    password: process.env.PGPASSWORD || "admin",
    database: process.env.PGDATABASE || "embankment_test",
    synchronize: true,
    logging: false,
    entities: [NicenessModel],
    migrations: [],
    subscribers: [],
})