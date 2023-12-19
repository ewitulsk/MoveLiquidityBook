module seam::errors {
    //Fee Parameter Errors
    const PARAMETERS__INVALID_PARAMS_CONST: u64 = 0;

    //Factory Errors
    const FACTORY__BIN_STEP_TOO_LOW_CONST: u64 = 1;
    const FACTORY__BIN_STEP_HAS_NO_PRESET_CONST: u64 = 2;
    const FACTORY__PRESET_IS_LOCKED_FOR_USERS_CONST: u64 = 3;

    //Parameter Error Functions
    public fun PARAMETERS__INVALID_PARAMS(): u64 {
        return PARAMETERS__INVALID_PARAMS_CONST
    }

    //Factory Error Functions
    public fun FACTORY__BIN_STEP_TOO_LOW(): u64 {
        return FACTORY__BIN_STEP_TOO_LOW_CONST
    }

    public fun FACTORY__BIN_STEP_HAS_NO_PRESET(): u64 {
        return FACTORY__BIN_STEP_HAS_NO_PRESET_CONST
    }

    public fun FACTORY__PRESET_IS_LOCKED_FOR_USERS(): u64 {
        return FACTORY__PRESET_IS_LOCKED_FOR_USERS_CONST
    }
}