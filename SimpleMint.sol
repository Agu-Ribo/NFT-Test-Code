// SPDX-License-Identifier: unlicense
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract SimpleMintContract is ERC721, Ownable {
    uint256 public mintPrice = 0.05 ether; // esta linea le coloca un valor al minteo - 
    uint256 public totalSupply; // esta le asigna una cantidad maxima de tokens que tendremos a determinado momento
    uint256 public maxSupply; // esta será la que le ponga un tope máximo a la cantidad de tokens a emitir
    bool public isMintEnabled; // damos la posibilidad de mintear o no. Cuando querramos lanzar el mint, lo cambiamos a 'True'
    mapping(address => uint256) public mintedWallets; // va a mantener un trackeo de todas las wallets que mintearon el token

    constructor() payable ERC721('Simple Mint', 'SIMPLEMINT') { // esta funcion correrá cuando el SC este corriendo en la blockchain
        maxSupply = 2; // le asignamos un max supply cuando esté corriendo en la blockchain
    }

    function toggleIsMintEnabled() external onlyOwner { // lo que hace esta linea es darle la posibilidad solamente al owner de correr este SC
    // external significa que no se puede llamar a esta función desde otra función dentro del SC
        isMintEnabled = !isMintEnabled; // al ser un bool, esta funcion es verdadera o falsa, 
    }
   
   function setMaxSupply(uint256 maxSupply_) external onlyOwner{ // y esta linea le da al owner la posibilida de modificar el maxsupply
       maxSupply = maxSupply_;
   }

   function mint() external payable { // función para mintear el token
       require(isMintEnabled, 'minting not enabled'); // lo que dice es que si el mint no está disponible, entonces larga un mensaje 'minting not enabled'
       // esto porque la función isMintEnabled por defecto viene en False
       require(mintedWallets[msg.sender] < 1, 'exceeds max per wallet'); //requerimiento para mintear un solo token por wallet
       require(msg.value == mintPrice, 'wrong value'); // te muestra un mensaje donde si no colocas el monto correcto de ether, te sale el mensaje de 'wrong value'
       require(maxSupply > totalSupply, 'sold out'); // como ultimo requisito, tendremos que el max supply no sea mayor al total supply

       mintedWallets[msg.sender]++;
       totalSupply++;
       uint256 tokenId = totalSupply;
       _safeMint(msg.sender, tokenId); // esta linea lo q hace es mintear de manera segura el token ERC721 
   }



}

// uint256 es un 'integer' donde se coloca numeros
