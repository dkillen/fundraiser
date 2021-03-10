// React imports
import React, { Component } from "react";
import { BrowserRouter as Router, Route, NavLink } from "react-router-dom";

// Material UI imports
import { withStyles } from "@material-ui/core/styles";
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';

// Contract imports
import FundraiserFactoryContract from "./contracts/FundraiserFactory.json";

// Utility imports
import getWeb3 from "./utils/getWeb3";

// Component imports
import Home from "./Home";
import NewFundraiser from "./NewFundraiser";

import "./App.css";

const useStyles = theme => ({
  root: {
    flexGrow: 1,
  },
});

class App extends Component {
  state = { 
    web3: null, 
    accounts: null, 
    contract: null 
  };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      // web3.eth.requestAccounts() is the preferred means to obtain accounts. 
      const accounts = await web3.eth.requestAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = FundraiserFactoryContract.networks[networkId];
      const instance = new web3.eth.Contract(
        FundraiserFactoryContract.abi,
        deployedNetwork && deployedNetwork.address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ 
        web3: web3, 
        accounts: accounts, 
        contract: instance 
      });
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  // runExample = async () => {
  //   const { accounts, contract } = this.state;

  //   // Stores a given value, 5 by default.
  //   await contract.methods.set(75).send({ from: accounts[0] });

  //   // Get the value from the contract to prove it worked.
  //   const response = await contract.methods.get().call();

  //   // Update state with the result.
  //   this.setState({ storageValue: response });
  // };


  render() {
    const { classes } = this.props;
    return (
      <Router>
        <div className={classes.root}>
          <AppBar position="static" color="default">
          <Toolbar>
            <Typography variant="h6" color="inherit">
              <NavLink className="nav-link" to="/">Home</NavLink>
            </Typography>
            <NavLink className="nav-link" to="/new/">New</NavLink>
          </Toolbar>
          </AppBar>
          <Route path="/" exact component={Home} />
          <Route path="/new/" component={NewFundraiser} />
        </div>
      </Router>
    );
  }
}

export default withStyles(useStyles)(App);
