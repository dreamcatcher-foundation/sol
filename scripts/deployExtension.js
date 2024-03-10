const hardhat = require('hardhat');

async function deploy(contractName, args) {
    const contract = await hardhat.ethers.deployContract(contractName, args);
    await contract.waitForDeployment();
    return contract;
}

async function main() {
    deploy("Lock", []);
}

main();