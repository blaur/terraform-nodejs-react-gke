# Getting Started with the NodeJS Backend

This is a simple NodeJS backend with TypeScript. It exposes a GraphQL API using Apollo and TypeORM.

## Available Scripts

In the project directory, you can run:

### `npm run dev`

Runs the app in the development mode.\
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

### `npm run build`

Builds the app for production to the `dist` folder.\

When it has been built, then the production build can be run with `npm run start`

### Apollo

ApolloServer has been configured and can be reached at [http://localhost:3000/graphql](http://localhost:3000/graphql).

On init, it will run `AppDataSource.initialize()` which will create a test enty in the database. For testing purposes, the model that has been defined with TypeORM in the following way.

```
@Entity()
export class NicenessModel {

    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    name: string;

    @Column()
    nicenessScore: number;
}
```

Which is simply exposed with one Query where they can be fetched by id.

```
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
```