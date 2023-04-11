async function main() {
    const DiasosiNFT = await ethers.getContractFactory("DiasosiNFT")
    const diasosiNFT = await DiasosiNFT.deploy()
    await diasosiNFT.deployed()
    console.log("Contract deployed to address:", diasosiNFT.address)
}
 
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })