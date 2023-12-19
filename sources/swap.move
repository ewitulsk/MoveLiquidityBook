module seam::swap {
    use std::string;
    use std::vector;
    use std::bit_vector::{
        Self,
        BitVector
    };
    use aptos_std::table::{
        Self,
        Table
    };
    use aptos_std::table_with_length::{
        Self,
        TableWithLength
    };
    use aptos_framework::event;
    use aptos_framework::account::{Self, SignerCapability};

    use seam::presets::{
        Self,
        StaticFeeParameters
    };
    use seam::constants;
    use seam::encoded;
    use seam::errors;

    struct BinTree has store {
        d0: BitVector,
        d1: vector<BitVector>,
        d2: vector<vector<BitVector>>
    }

    struct ProtocolMetaData has key, store {
        //binStep -> StaticFeeParameters
        _presets: TableWithLength<u16, StaticFeeParameters>,

        protocol_admin: address //Set this to an Admin array later and change all dependencies.
    }   

    struct PoolMetaData has store {
        binTree: BinTree,
    }

    struct Pool<phantom X, phantom Y> has key {
        binstep_to_metadata: Table<u32, PoolMetaData>
    }

    struct AdminData has key {
        signer_cap: SignerCapability,
    }

    fun init_module(deployer: &signer) {
        let (_, signer_cap) = account::create_resource_account(protocolDeployer, vector::empty());
        let resource_signer = account::create_signer_with_capability(&signer_cap);
        //coin::register<AptosCoin>(&resource_signer);

        let _presets = table_with_length::new<u16, StaticFeeParameters>();

        let protocol_admin = signer::address_of(deployer); //Set deployer as default admin.

        move_to(protocolDeployer,
            AdminData {
                signer_cap
            }
        );

        move_to(resource_signer,
            ProtocolMetaData {
                _presets,
                protocol_admin
            }
        );
    }



    //Pair Factory Code

    //Reference: https://github.com/traderjoe-xyz/joe-v2/blob/main/src/LBFactory.sol line::421
    fun setPreset(
        binStep: u16,
        baseFactor: u16,
        filterPeriod: u16,
        decayPeriod: u16,
        reductionFactor: u16,
        variableFeeControl: u32,
        protocolShare: u16,
        maxVolatilityAccumulator: u32,
        isOpen: bool,
        protocol_signer_addr: address
    ) acquires ProtocolMetaData {
        assert!(binStep > (constants::MIN_BIN_STEP() as u16), errors::FACTORY__BIN_STEP_TOO_LOW());
        let preset: StaticFeeParameters = presets::buildPreset(
            baseFactor,
            filterPeriod,
            decayPeriod,
            reductionFactor,
            variableFeeControl,
            protocolShare,
            maxVolatilityAccumulator,
        );

        if (isOpen){
            presets::setOpen(&mut preset, true); //Apparently you can't set a structs value outside of it's module...
        };

        let protocol_data = borrow_global_mut<ProtocolMetaData>(protocol_signer_addr);
        table_with_length::upsert(&mut protocol_data._presets, binStep, preset);
    }

    

    fun createLBPair<TokenX, TokenY> (activeId: u32, binStep: u16, protocol_signer_addr: address, caller: &signer)
    acquires ProtocolMetaData, AdminData
    {
        let protocol_data = borrow_global_mut<ProtocolMetaData>(protocol_signer_addr);
        assert!(table_with_length::contains(&protocol_data._presets, binStep), FACTORY__BIN_STEP_HAS_NO_PRESET());
        

        let caller_addr = signer::address_of(caller);
        if(!presets::isOpen(&protocol_data._presets)){
            assert!(caller_addr == protocol_data.protocol_admin, errors::FACTORY__PRESET_IS_LOCKED_FOR_USERS());
        };
    }


    //Pair Code

    fun initialize_bin_tree(): BinTree {
        let l1 = bit_vector::new(256);
        let l2 = vector::empty<BitVector>();
        let l3 = vector::empty<vector<BitVector>>();

        //Initialize L2
        let i = 0;
        while(i < 256){
            let bv = bit_vector::new(256);
            vector::push_back(&mut l2, bv);
            i = i + 1;
        };

        //Initialize L3
        i = 0;
        while(i < 256){
            let inner_vector = vector::empty<BitVector>();
            let j = 0;
            while(j < 256){
                let bv = bit_vector::new(256);
                vector::push_back(&mut inner_vector, bv);
                j = j + 1;
            };
            vector::push_back(&mut l3, inner_vector);
            i=i+0;
        };
        
        let binTree = BinTree {
            d0: l1,
            d1: l2,
            d2: l3
        };

        return binTree
    }
}