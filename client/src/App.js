import './styles/App.css';
import twitterLogo from './assets/twitter-logo.svg';
import { ethers } from "ethers";
import React, { useEffect, useState } from "react";
import CommunitiesNFT from './utils/CommunitiesNFT.json';

const TWITTER_HANDLE = '0xMaxDaftPunker';
const TWITTER_LINK = `https://twitter.com/${TWITTER_HANDLE}`;



const CONTRACT_ADDRESS = "0xd01e1B190CfA5E7310CbB9A8E9ce362fE9AbCeD4";

const App = () => {

  const [currentAccount, setCurrentAccount] = useState("");
  const [whitelistedAccount, setwhitelistedAccount] = useState("");

  const checkIfWalletIsConnected = async () => {
    const { ethereum } = window;
git 
    if (!ethereum) {
      console.log("Make sure you have metamask!");
      return;
    } else {
      console.log("We have the ethereum object", ethereum);
    }

    const accounts = await ethereum.request({ method: 'eth_accounts' });

    let chainId = await ethereum.request({ method: 'eth_chainId' });
    console.log("Connected to chain " + chainId);

    // String, hex code of the chainId of the Ropsten test network
    const ropstenChainId = "0x3";
    if (chainId !== ropstenChainId) {
      alert("You are not connected to the Ropsten Test Network!");
    }

    if (accounts.length !== 0) {
      const account = accounts[0];
      console.log("Found an authorized account:", account);
      setCurrentAccount(account)

      setupEventListener()
    } else {
      console.log("No authorized account found")
    }
  }

  const connectWallet = async () => {
    try {
      const { ethereum } = window;

      if (!ethereum) {
        alert("Get MetaMask!");
        return;
      }

      const accounts = await ethereum.request({ method: "eth_requestAccounts" });

      console.log("Connected", accounts[0]);
      setCurrentAccount(accounts[0]);

      setupEventListener()
    } catch (error) {
      console.log(error)
    }
  }

  // Setup our listener.
  const setupEventListener = async () => {
    try {
      const { ethereum } = window;

      if (ethereum) {
        
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, CommunitiesNFT.abi, signer);

        // Catch the event 
          connectedContract.on("NewNFTMinted", (from, tokenId) => {
          console.log(from, tokenId.toNumber())
          alert(`Here's the link: https://testnets.opensea.io/assets/${CONTRACT_ADDRESS}/${tokenId.toNumber()}`)
        });

        console.log("Setup event listener!")

      } else {
        console.log("Ethereum object doesn't exist!");
      }
    } catch (error) {
      console.log(error)
    }
  }

  const askContractToMintNft = async () => {
    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, CommunitiesNFT.abi, signer);

        console.log("Going to pop wallet now to pay gas...")
        let nftTxn = await connectedContract.mint();

        console.log("Mining...please wait.")
        await nftTxn.wait();
        console.log(nftTxn);
        console.log(`Mined, see transaction: https://rinkeby.etherscan.io/tx/${nftTxn.hash}`);

      } else {
        console.log("Ethereum object doesn't exist!");
      }
    } catch (error) {
      console.log(error)
    }
  }

  const askContractToWhitelist = async () => {
    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, CommunitiesNFT.abi, signer);

        console.log("Going to pop wallet now to pay gas...")
        let nftTxn = await connectedContract.whitelistUser(whitelistedAccount);

        console.log("Whitelisting...please wait.")
        await nftTxn.wait();
        console.log(nftTxn);
        console.log(`Whitelisted: https://rinkeby.etherscan.io/tx/${nftTxn.hash}`);

      } else {
        console.log("Ethereum object doesn't exist!");
      }
    } catch (error) {
      console.log(error)
    }
  }

  const askContractToRemoveWhitelist = async () => {
    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, CommunitiesNFT.abi, signer);

        console.log("Going to pop wallet now to pay gas...")
        let nftTxn = await connectedContract.removeWhitelistUser(whitelistedAccount);

        console.log("Removing...please wait.")
        await nftTxn.wait();
        console.log(nftTxn);
        console.log(`Removed: https://rinkeby.etherscan.io/tx/${nftTxn.hash}`);

      } else {
        console.log("Ethereum object doesn't exist!");
      }
    } catch (error) {
      console.log(error)
    }
  } 
  
  useEffect(() => {
    checkIfWalletIsConnected();
  }, [])

  const renderNotConnectedContainer = () => (
    <button onClick={connectWallet} className="cta-button connect-wallet-button">
      Connect to Wallet
    </button>
  );

  const renderMintUI = () => (
    <button onClick={askContractToMintNft} className="cta-button connect-wallet-button">
      Mint NFT
    </button>
  )

  const renderWhitelistUI = () => (
    <button onClick={askContractToWhitelist} className="cta-button whitelist-button">
      Whitelist Address
    </button>
  )

  const renderRemoveWhitelistUI = () => (
    <button onClick={askContractToRemoveWhitelist} className="cta-button whitelist-button">
      Remove Address
    </button>
  )

 const handleChange = (event) => {
    setwhitelistedAccount(event.target.value);
    console.log(whitelistedAccount);
  }
    
  return (
    <div className="App">
      <div className="container">
        <div className="header-container">
          <p className="header gradient-text">Communities NFTs</p>
          <p className="sub-text">
            Each unique. Each beautiful. Discover your NFT today.
          </p>
          {currentAccount === "" ? renderNotConnectedContainer() : renderMintUI()}
        </div>
        
        <div>
          <div>
          <input
              className="input"
              type="text"
              onChange={handleChange}
              placeholder="Enter an address to whitelist"
            />
          </div>
          {currentAccount === "" ? renderWhitelistUI() : renderWhitelistUI()}
        </div>

        <div>
          <div >
          <input
              className="input"
              type="text"
              onChange={handleChange}
              placeholder="Enter an address to remove from the whitelist"
            />
          </div>
          {currentAccount === "" ? renderRemoveWhitelistUI() : renderRemoveWhitelistUI()}
        </div>

        <div className="footer-container">
          <img alt="Twitter Logo" className="twitter-logo" src={twitterLogo} />
          <a
            className="footer-text"
            href={TWITTER_LINK}
            target="_blank"
            rel="noreferrer"
          >{`built by @${TWITTER_HANDLE}`}</a>
        </div>
      </div>
    </div>
  );
};

export default App;