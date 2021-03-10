// React imports
import React, { useState, useEffect } from "react";

// Contract imports
import getWeb3 from "./utils/getWeb3";
import FundraiserFactoryContract from "./contracts/FundraiserFactory.json";

// Styling imports
import { makeStyles } from "@material-ui/core/styles";
import TextField from "@material-ui/core/TextField";
import Button from "@material-ui/core/Button";

const useStyles = makeStyles(theme => ({
    container: {
        display: 'flex',
        flexWrap: 'wrap',
    },
    textField: {
        marginLeft: theme.spacing(1),
        marginRight: theme.spacing(1),
    },
    dense: {
        marginTop: theme.spacing(2),
    },
    menu: {
        width: 200,
    },
    button: {
        margin: theme.spacing(1),
    },
    input: {
        display: 'none',
    },
}));

const NewFundraiser = () => {

    const [ name, setFundraiserName ] = useState(null);
    const [ website, setFundraiserWebsite ] = useState(null);
    const [ description, setFundraiserDescription ] = useState(null);
    const [ imageUrl, setImageUrl ] = useState(null);
    const [ beneficiary, setBeneficiary ] = useState(null);
    // const [ custodian, setCustodian ] = useState(null);
    const [ contract, setContract ] = useState(null);
    const [ accounts, setAccounts ] = useState(null);


    useEffect(() => {
        const init = async () => {
            try {
                const web3 = await getWeb3();
                const networkId = await web3.eth.net.getId();
                const deployedNetwork = FundraiserFactoryContract.networks[networkId];
                const accounts = await web3.eth.requestAccounts();
                const instance = new web3.eth.Contract(
                    FundraiserFactoryContract.abi,
                    deployedNetwork && deployedNetwork.address,
                );

                console.log(instance);

                setContract(instance);
                setAccounts(accounts);
            } catch (error) {
                alert(
                    'Failed to load web3, accounts, or contract. Check console for details.'
                );
                console.error(error)
            }
        }
        init();
    }, []);

    const classes = useStyles();

    const handleSubmit = async () => {
        await contract.methods.createFundraiser(
            name,
            website,
            imageUrl,
            description,
            beneficiary
        ).send({ from: accounts[0] });
        alert("Successfully created fundraiser!");
    }

    return (
        <div className="content">
            <h2>Create a new Fundraiser</h2>
            <label>Name</label>
            <TextField
                id="outlined-bare"
                className={classes.textField}
                placeholder="Fundraiser Name"
                margin="normal"
                onChange={(e) => setFundraiserName(e.target.value)}
                variant="outlined"
                inputProps={{ 'aria-label': 'bare' }}
            />
            <label>Website</label>
            <TextField
                id="outlined-bare"
                className={classes.textField}
                placeholder="Fundraiser Name"
                margin="normal"
                onChange={(e) => setFundraiserWebsite(e.target.value)}
                variant="outlined"
                inputProps={{ 'aria-label': 'bare' }}
            />
            <label>Description</label>
            <TextField
                id="outlined-bare"
                className={classes.textField}
                placeholder="Fundraiser Description"
                margin="normal"
                onChange={(e) => setFundraiserDescription(e.target.value)}
                variant="outlined"
                inputProps={{ 'aria-label': 'bare' }}
            />
            <label>Image</label>
            <TextField
                id="outlined-bare"
                className={classes.textField}
                placeholder="Fundraiser Image"
                margin="normal"
                onChange={(e) => setImageUrl(e.target.value)}
                variant="outlined"
                inputProps={{ 'aria-label': 'bare' }}
            />
            <label>Beneficiary</label>
            <TextField
                id="outlined-bare"
                className={classes.textField}
                placeholder="Fundraiser Beneficiary"
                margin="normal"
                onChange={(e) => setBeneficiary(e.target.value)}
                variant="outlined"
                inputProps={{ 'aria-label': 'bare' }}
            />
            <Button
                onClick={handleSubmit}
                variant="contained"
                className={classes.button}
            >Submit</Button>
        </div>
    );
}
export default NewFundraiser;