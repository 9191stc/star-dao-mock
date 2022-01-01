// Copyright (c) The Elements Stuidio Core Contributors
// SPDX-License-Identifier: Apache-2.0


//{
//    "ok": {
//        "account": "0xcccf61268df4d021405ef5d4041cb6d3",
//        "private_key": "0xb518999b30451faeb590ff71af971b2a674511bb4b73a17d9d3eeadce727b1b4"
//    }
//}

address 0xcccf61268df4d021405ef5d4041cb6d3 {
/// STD is a governance token of Starcoin blockchain DAPP.
/// It uses apis defined in the `Token` module.
module STD {
    use 0x1::Token;
    use 0x1::Account;
    use 0x1::Signer;

    /// STD token marker.
    struct STD has copy, drop, store {}

    /// precision of STD token.
    const PRECISION: u8 = 9;

    const ERROR_NOT_GENESIS_ACCOUNT: u64 = 10001;

    /// STD initialization.
    public fun init(account: &signer) {
        Token::register_token<STD>(account, PRECISION);
        Account::do_accept_token<STD>(account);
    }

    // Mint function, block ability of mint and burn after execution
    public fun mint(account: &signer, amount: u128) {
        let token = Token::mint<STD>(account, amount);
        Account::deposit_to_self<STD>(account, token);
    }

    /// Returns true if `TokenType` is `STD::STD`
    public fun is_std<TokenType: store>(): bool {
        Token::is_same_token<STD, TokenType>()
    }

    spec is_abc {
    }

    public fun assert_genesis_address(account : &signer) {
        assert(Signer::address_of(account) == token_address(), ERROR_NOT_GENESIS_ACCOUNT);
    }

    /// Return STD token address.
    public fun token_address(): address {
        Token::token_address<STD>()
    }

    spec token_address {
    }

    /// Return STD precision.
    public fun precision(): u8 {
        PRECISION
    }

    spec precision {
    }
}
}