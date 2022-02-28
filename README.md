1. Please install the packages for coinflip.
    yarn
  
2. Please config .env file
If you test this project on your local, you can use the follow values.
REACT_APP_OWNER_ADDRESS=f39fd6e51aad88f6f4ce6ab8827279cfffb92266
REACT_APP_PRIVATE_KEY=ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

After deploy this contract, you need to set the deployed address
REACT_APP_DEPLOYED_ADDRESS={CONTRACT'S DEPLOYED ADDRESS}

REACT_APP_PROJECT_ID={PROJECT ID ON infura.io}
REACT_APP_CONTRACT_BALANCE={CONTRACT'S INIT BALANCE}

3. Please compile COINFLIP contract
    yarn hardhat compile

4. Please deploy COINFLIP contract and test through localhost:3000

If you deploy this contract on your local:
please run the following command on a Terminal.
    yarn hardhat node
please run the following commands on the other Terminal.
    yarn hardhat run scripts/deploy.js --network localhost
    yarn start

If you deploy this contract on your rinkeby, please run the follow commands on your Terminal
    yarn hardhat run scripts/deploy.js --network rinkeby
    yarn start

