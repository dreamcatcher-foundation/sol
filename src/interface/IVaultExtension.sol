// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVaultExtension {
    function selectors external view returns (bytes4[] memory);
    function vault__claim() external returns (bool);
    function vault__grantManagerRoleTo(address account) external returns (bool);
    function vault__buy(uint256 tokenContractId, uint256 amountInR18) external returns (bool);
    function vault__sell(uint256 tokenContractId, uint256 amountInR18) external returns (bool);
    function vault__addTokenToPalette(address tokenContract) external returns (bool);
    function vault__amountOut(uint256 valueInR18) external view returns (uint256 r18);
    function vault__valueOut(uint256 amountInR18) external view returns (uint256 r18);
    function vault__deposit(uint256 valueInR18) external returns (bool);
    function vault__withdraw(uint256 amountInR18) external returns (bool);
    function vault__netAssetValue() external view returns (uint256 r18);
    function vault__netAssetValuePerShare() external view returns (uint256 r18);
    function vault__tokenContracts(uint256 tokenContractId) external view returns (address);
    function vault__tokenContracts() public view returns (address[] memory);
}