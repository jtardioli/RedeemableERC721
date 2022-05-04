// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "solmate/tokens/ERC721.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

error FailedToRedeem();
error NotOwner();

abstract contract ERC721Redeemable is ERC721, Ownable {
  uint totalNFTs;

  constructor() {
    totalNFTs = 0;
  }

  function withdraw() external onlyOwner {

  }

  function _redeemableMint(address to, uint256 id) internal {
    totalNFTs++;
    _mint(to, id);
    
  }

  function _redeemableSafeMint(address to, uint256 id) internal virtual  {
    totalNFTs++;
    _safeMint(to, id);

  }

  function _redeemableSafeMint(
      address to,
      uint256 id,
      bytes memory data
  ) internal virtual  {
     totalNFTs++;
    _safeMint(to, id, data);
  }

  function _redeemableBurn(uint256 id) internal virtual {
    if (address(msg.sender) != ownerOf(id)) revert NotOwner();
    totalNFTs--;
    _burn(id);
  }



  function _redeem(uint idToBurn) internal {
    _redeemableBurn(idToBurn);
    uint redeemableAmount = address(this).balance / totalNFTs;
    (bool success, ) = payable(msg.sender).call{value: redeemableAmount}("");
    if (!success) revert FailedToRedeem();
  }


}


