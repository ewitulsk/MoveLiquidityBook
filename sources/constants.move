module seam::constants {
    const MIN_BIN_STEP_CONST: u256 = 1; //.001%
    const BASIS_POINT_MAX_CONST: u256 = 10000;
    const MAX_PROTOCOL_SHARE_CONST: u256 = 2500;

    //Constants are internal? That's dumb.
    public fun MIN_BIN_STEP(): u256 {
        return MIN_BIN_STEP_CONST 
    }

    public fun BASIS_POINT_MAX(): u256 {
        return BASIS_POINT_MAX_CONST
    }

    public fun MAX_PROTOCOL_SHARE(): u256 {
        return MAX_PROTOCOL_SHARE_CONST
    }
}