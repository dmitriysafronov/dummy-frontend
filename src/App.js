import React, { useEffect, useState } from "react";

import logo from './logo.svg';
import './App.css';

function App() {
  const [users, setUsers] = useState();

  // Function to collect data
  const getApiData = async () => {
    const response = await fetch(
      "/api/users"
    ).then((response) => response.json());

    setUsers(response);
  };

  useEffect(() => {
    getApiData();
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <a
          className="App-link"
          href="/"
          target="_self"
          rel="noopener noreferrer"
        >
          <img src={logo} className="App-logo" alt="logo" />
        </a>
        <p>
          {users &&
          users.map((user) => (
            <div className="item-container">
              Id:{user.id} <div className="title">Title:{user.title}</div>
            </div>
          ))}
        </p>
      </header>
    </div>
  );
}

export default App;
