import express, { Application } from 'express';
import { ApolloServer } from '@apollo/server';
import { expressMiddleware } from '@apollo/server/express4';
import { json } from 'body-parser';
import dotenv from 'dotenv';
import cors from 'cors';
import { AppDataSource } from './database/data-source';
import { NicenessModel } from './database/entity/NicenessModel';
import { initDatabase } from './database';

//For env File 
dotenv.config();

// **************** Express App Init ************************

const app: Application = express();
const port = process.env.PORT || 3000;

// **************** Init some test stuff ************************

initDatabase();

// **************** GraphQL Schema and Context ************************

// The GraphQL schema
const typeDefs = `#graphql
  type NicenessModel {
    id: ID!
    name: String
    nicenessScore: Int
  }

  type Query {
    findNicenessModelById(id: ID!): NicenessModel
  }
`;

// A map of functions which return data for the schema.
const resolvers = {
  Query: {
    findNicenessModelById(parent: any, args: any, contextValue: any, info: any) {
      return AppDataSource.getRepository(NicenessModel).findOne({
        where: {
          id: args.id
        }
      })
    },
  },
};


interface MyContext {
  token?: string;
}

const server = new ApolloServer<MyContext>({
  typeDefs,
  resolvers,
});  

// Starting up the server and enable the necessary routes.
server.start().then(() => {
  // Specify the path where we'd like to mount our server
  app.use('/graphql', cors<cors.CorsRequest>(), json(), expressMiddleware(server));  

  app.get('/', (req, res) => {
    res.send('hello world')
  })

  app.listen(port, () => {
    console.log(`Server is on FIREz at http://localhost:${port}`);
  });
});