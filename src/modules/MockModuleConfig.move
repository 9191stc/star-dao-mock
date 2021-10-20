// Copyright (c) The Elements Stuidio Core Contributors
// SPDX-License-Identifier: Apache-2.0

address 0xcccf61268df4d021405ef5d4041cb6d3 {

module MockModuleConfig {
    use 0x1::Token;
    use 0xcccf61268df4d021405ef5d4041cb6d3::STD::STD;

    struct ParameterModifyCapability has key, store {}

    struct MockConfig has key, store {
        mock_config_val: u128,
    }

    public fun init(signer: &signer, mock_config_val: u128) : ParameterModifyCapability {
        move_to(signer, MockConfig {
            mock_config_val
        });
        ParameterModifyCapability {}
    }

    public fun modify(_cap: &ParameterModifyCapability, val: u128) acquires MockConfig {
        let addr = Token::token_address<STD>();
        let conf = borrow_global_mut<MockConfig>(addr);
        conf.mock_config_val = val;
    }

    public fun query(): u128 acquires MockConfig {
        let addr = Token::token_address<STD>();
        let conf = borrow_global_mut<MockConfig>(addr);
        conf.mock_config_val
    }
}
}