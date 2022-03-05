// import contract from "./contracts/GameItem.json";
var requirejs = require('requirejs');
let contract = requirejs("./contracts/GameItem.json");

const CONTRACT_ADDRESS = "0x08cce75017E7a9888946426D92df4e8e1Dc7FE6D";
const ABI = contract.abi;


const App = {
  checkWalletIsConnected: async () => {
    console.log('wallet is connected');
  },

  connectWalletHandler: async () => {
    console.log('connect wallet handler');
  },

  mintNftHandler: async () => {
    console.log('mint nft handler');
  }


}
window.App = App;
window.addEventListener("load", async function () {
  App.checkWalletIsConnected();

})