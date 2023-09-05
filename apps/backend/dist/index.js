"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const server_1 = require("@apollo/server");
const express4_1 = require("@apollo/server/express4");
const body_parser_1 = require("body-parser");
const dotenv_1 = __importDefault(require("dotenv"));
const cors_1 = __importDefault(require("cors"));
//For env File 
dotenv_1.default.config();
// **************** Express App Init ************************
const app = (0, express_1.default)();
const port = process.env.PORT || 3000;
// **************** GraphQL Schema and Context ************************
// The GraphQL schema
const typeDefs = `#graphql
  type Query {
    hello: String
  }
`;
// A map of functions which return data for the schema.
const resolvers = {
    Query: {
        hello: () => 'world',
    },
};
const server = new server_1.ApolloServer({
    typeDefs,
    resolvers,
});
// Starting up the server and enable the necessary routes.
server.start().then(() => {
    // Specify the path where we'd like to mount our server
    app.use('/graphql', (0, cors_1.default)(), (0, body_parser_1.json)(), (0, express4_1.expressMiddleware)(server));
    app.get('/', (req, res) => {
        res.send('hello world');
    });
    app.listen(port, () => {
        console.log(`Server is on FIREz at http://localhost:${port}`);
    });
});
