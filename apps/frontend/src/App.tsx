import logo from './logo.svg';
import { useQuery, gql } from '@apollo/client';
import './App.css';

const GET_NICENESS_BY_ID = gql`
  query FindNicenessModelById($id: ID!) {
    findNicenessModelById(id: $id) {
        name
        nicenessScore
    }
  }
`;

interface NicenessModel {
  id: number;
  name: string;
  nicenessScore: number;
}

interface NicenessModelRes {
  findNicenessModelById: NicenessModel;
}

function App() {

  const { loading, error, data } = useQuery<NicenessModelRes>(GET_NICENESS_BY_ID, {
    variables: {
      id: "1"
    }
  });

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />

        { loading && !error ? <p>Loading...</p> : <p>Nicessness: {data?.findNicenessModelById.name}</p>}

        { error ? <p>Error : {error.message}</p> : <></>}

      </header>
    </div>
  );
}

export default App;
