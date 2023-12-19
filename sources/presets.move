module seam::presets {
    use std::string;
    use std::vector;
    use aptos_std::table::{
        Self,
        Table
    };
    use aptos_std::table_with_length::{
        Self,
        TableWithLength
    };
    use aptos_framework::event;

    use seam::encoded;
    use seam::constants;
    use seam::errors;

    struct StaticFeeParameters has store, drop {
        baseFactor: u16,
        filterPeriod: u16,
        decayPeriod: u16,
        reductionFactor: u16,
        variableFeeControl: u32,
        protocolShare: u16,
        maxVolatilityAccumulator: u32,
        isOpen: bool
    }


    //Used in: https://github.com/traderjoe-xyz/joe-v2/blob/main/src/LBFactory.sol line::434
    //Reference: https://github.com/traderjoe-xyz/joe-v2/blob/main/src/libraries/PairParameterHelper.sol line::319
    //trader joe packs below into a u256. We could do that... but we're not going to. Atleast for now.
    public fun buildPreset(
        baseFactor: u16,
        filterPeriod: u16,
        decayPeriod: u16,
        reductionFactor: u16,
        variableFeeControl: u32, //trader joe uses u24, check in if statement
        protocolShare: u16,
        maxVolatilityAccumulator: u32 //trader joe uses u24, "overflow" is checked in if statement.
    ): StaticFeeParameters {
        assert!(
            filterPeriod > decayPeriod || 
            decayPeriod > (encoded::MASK_UINT_12() as u16) || 
            reductionFactor > (constants::BASIS_POINT_MAX() as u16) ||
            protocolShare > (constants::MAX_PROTOCOL_SHARE() as u16) ||
            maxVolatilityAccumulator > (encoded::MASK_UINT_20() as u32) ||
            variableFeeControl > (encoded::MASK_UINT_24() as u32)
        , errors::PARAMETERS__INVALID_PARAMS());

        return {
            StaticFeeParameters {
                baseFactor,
                filterPeriod,
                decayPeriod,
                reductionFactor,
                variableFeeControl,
                protocolShare,
                maxVolatilityAccumulator,
                isOpen: false
            }
        }
    }

    //Apparently you can't set a structs value outside of it's module...
    public fun setOpen(params: &mut StaticFeeParameters, val: bool) {
        params.isOpen = val;
    }

    public fun isOpen(params: &StaticFeeParameters): bool{
        return params.isOpen
    }
}