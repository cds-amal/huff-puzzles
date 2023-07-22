// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
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

    function test_fuzz_strings(string calldata text) external {
        vm.assume(bytes(text).length > 0);

        str.setValue(text);
        string memory stored = str.getValue();
        console.log("stored: %s", stored);
        console.log("stored: %s", text);
        assertEq(stored, text, text);
    }

    /// @notice Test that a non-matching selector reverts
    /// forge-config: default.fuzz.runs = 0
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

