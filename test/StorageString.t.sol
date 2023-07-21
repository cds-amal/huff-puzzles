// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {HuffConfig} from "foundry-huff/HuffConfig.sol";
import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";
import {NonMatchingSelectorHelper} from "./test-utils/NonMatchingSelectorHelper.sol";

interface StorageString {
    function setValue(string memory _value) external;
    function getValue() external view returns (string memory);
}

contract StorageStringTest is Test, NonMatchingSelectorHelper {
    StorageString public str;

    function setUp() public {
        str = StorageString(HuffDeployer.config().deploy("StorageString"));
    }

    function testSumArray() external {
        string memory text = "hello world";
        str.setValue(text);
        string memory stored = str.getValue();
        assertEq(stored, text, "expected to store hello world");
    }

    /// @notice Test that a non-matching selector reverts
    function testNonMatchingSelector(bytes32 callData) public {
        bytes4[] memory func_selectors = new bytes4[](1);
        func_selectors[0] = StorageString.getValue.selector;
        func_selectors[1] = StorageString.setValue.selector;

        bool success = nonMatchingSelectorHelper(
            func_selectors,
            callData,
            address(str)
        );
        assert(!success);
    }
}

