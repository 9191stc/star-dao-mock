// Copyright (c) The Elements Stuidio Core Contributors
// SPDX-License-Identifier: Apache-2.0

address 0xcccf61268df4d021405ef5d4041cb6d3 {

module MockModuleDaoProposal {
    use 0x1::Dao;
    use 0x1::Token;
    use 0x1::Signer;
    use 0x1::Errors;
    use 0xcccf61268df4d021405ef5d4041cb6d3::STD::STD;
    use 0xcccf61268df4d021405ef5d4041cb6d3::MockModuleConfig::{ParameterModifyCapability, Self};

    const ERR_NOT_AUTHORIZED: u64 = 101;

    struct MockModuleDaoProposalCapWrap has key, store {
        cap: ParameterModifyCapability,
    }

    struct MockModuleDaoProposalAction has copy, drop, store {
        mock_config_val: u128,
    }

    /// Add dao of mock module proposal action
    public fun plugin(account: &signer, cap: ParameterModifyCapability) {
        let token_issuer = Token::token_address<STD>();
        assert(Signer::address_of(account) == token_issuer, Errors::requires_address(ERR_NOT_AUTHORIZED));

        move_to(account, MockModuleDaoProposalCapWrap { cap })
    }

    /// Start a proposal
    public fun submit_proposal(
        signer: &signer,
        mock_config_val: u128,
        exec_delay: u64) {
        Dao::propose<STD, MockModuleDaoProposalAction>(
            signer,
            MockModuleDaoProposalAction { mock_config_val },
            exec_delay,
        );
    }

    public fun proposal_state(account: address, proposal_id: u64): u8 {
        Dao::proposal_state<STD, MockModuleDaoProposalAction>(account, proposal_id)
    }

    /// Perform propose after propose has completed
    public fun execute_proposal(proposer_address: address,
                                proposal_id: u64) acquires MockModuleDaoProposalCapWrap {
        let MockModuleDaoProposalAction { mock_config_val } =
            Dao::extract_proposal_action<STD, MockModuleDaoProposalAction>(proposer_address, proposal_id);
        let wrap = borrow_global_mut<MockModuleDaoProposalCapWrap>(proposer_address);
        MockModuleConfig::modify(&wrap.cap, mock_config_val);
    }
}
}