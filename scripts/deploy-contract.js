async function deploy(contractName, args, opts) {
  const contract = new this.web3.eth.Contract(this.artifacts[contractName].abi)

  contract
    .deploy({
      data: this.artifacts[contractName].bytecode,
      arguments: args,
    })
    .send(opts || { from: this.coinbase })
    .on('error', (error) => {
      console.log(error.message)
    })
    .on('transactionHash', (transactionHash) => {
      console.log(transactionHash)
    })
    .on('receipt', (receipt) => {
      console.log(receipt)
    })
}

deploy
  .then(() => {
    process.exit(0)
  })
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
