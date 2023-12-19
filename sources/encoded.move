module seam::encoded {
    const MASK_UINT_12_CONST: u256 = 0xfff;
    const MASK_UINT_20_CONST: u256 = 0xfffff;
    const MASK_UINT_24_CONST: u256 = 0xffffff;

    public fun MASK_UINT_12(): u256 {
        return MASK_UINT_12_CONST
    }

    public fun MASK_UINT_24(): u256 {
        return MASK_UINT_24_CONST
    }

    public fun MASK_UINT_20(): u256 {
        return MASK_UINT_20_CONST
    }
}