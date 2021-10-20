// Copyright (c) The Elements Stuidio Core Contributors
// SPDX-License-Identifier: Apache-2.0

address 0xcccf61268df4d021405ef5d4041cb6d3 {

module MockModuleDaoProposalScript {

    use 0x1::Signer;
    use 0xcccf61268df4d021405ef5d4041cb6d3::MockModuleConfig;
    use 0xcccf61268df4d021405ef5d4041cb6d3::MockModuleDaoProposal;
    use 0xcccf61268df4d021405ef5d4041cb6d3::STD;

    /// demostrate for publish token and initialize dao environment
    public(script) fun init(signer: signer, mint_amount: u128) {
        assert(Signer::address_of(&signer) == @0xcccf61268df4d021405ef5d4041cb6d3, 101);

        STD::init(&signer);
        STD::mint(&signer, mint_amount);

        let cap = MockModuleConfig::init(&signer, 0);
        MockModuleDaoProposal::plugin(&signer, cap);
    }

    public(script) fun proposal(signer: signer,
                                mock_config_val: u128,
                                exec_delay: u64) {
        MockModuleDaoProposal::submit_proposal(
            &signer,
            mock_config_val,
            exec_delay);
    }

    public(script) fun execute_proposal(proposer_address: address,
                                        proposal_id: u64) {
        MockModuleDaoProposal::execute_proposal(
            proposer_address,
            proposal_id);
    }

    public fun query(): u128 {
        MockModuleConfig::query()
    }
}
}