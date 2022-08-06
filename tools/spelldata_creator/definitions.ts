const enum EFFECT_TYPE {
    SPELL_EFFECT_DUMMY = 3,
    SPELL_EFFECT_HEAL = 10,
    SPELL_EFFECT_APPLY_AURA = 6,
    SPELL_EFFECT_PERSISTENT_AREA_AURA = 27,
    SPELL_EFFECT_SCRIPT_EFFECT = 77,
    SPELL_EFFECT_SCHOOL_DAMAGE = 2,
    SPELL_EFFECT_HEALTH_LEECH = 9,
    SPELL_EFFECT_SUMMON_TOTEM_SLOT_CLASSIC = 28, // Seems like all totems share this now
    SPELL_EFFECT_WEAPON_PERCENT_DAMAGE = 31, // if E1 then modify E0!
    SPELL_EFFECT_HEALTH_FUNNEL = 65, // Something like apply aura??
    SPELL_EFFECT_ATTACK = 78,
    SPELL_EFFECT_WEAPON_DAMAGE = 58,
    SPELL_EFFECT_APPLY_AREA_AURA_PARTY = 35,
    SPELL_EFFECT_TRIGGER_SPELL = 64,
    SPELL_EFFECT_NORMALIZED_WEAPON_DMG = 121,
    SPELL_EFFECT_ENERGIZE_PCT = 137,
}

const enum AURA_TYPE {
    SPELL_AURA_PERIODIC_DAMAGE = 3,
    SPELL_AURA_DUMMY = 4,
    SPELL_AURA_PERIODIC_HEAL = 8,
    SPELL_AURA_MOD_THREAT = 10,
    SPELL_AURA_MOD_DAMAGE_DONE = 13,
    SPELL_AURA_MOD_DAMAGE_TAKEN = 14,
    SPELL_AURA_DAMAGE_SHIELD = 15,
    SPELL_AURA_MOD_STEALTH_DETECT = 17,
    SPELL_AURA_MOD_INVISIBILITY = 18,
    SPELL_AURA_MOD_INVISIBILITY_DETECTION = 19,
    SPELL_AURA_OBS_MOD_MANA = 21,
    SPELL_AURA_MOD_RESISTANCE = 22,
    SPELL_AURA_PERIODIC_TRIGGER_SPELL = 23,
    SPELL_AURA_PERIODIC_ENERGIZE = 24,
    SPELL_AURA_MOD_STAT = 29,
    SPELL_AURA_MOD_SKILL = 30,
    SPELL_AURA_MOD_INCREASE_SPEED = 31,
    SPELL_AURA_MOD_INCREASE_ENERGY = 35,
    SPELL_AURA_PROC_TRIGGER_SPELL = 42,
    SPELL_AURA_PROC_TRIGGER_DAMAGE = 43,
    SPELL_AURA_TRACK_CREATURES = 44,
    SPELL_AURA_TRACK_RESOURCES = 45,
    SPELL_AURA_MOD_PARRY_PERCENT = 47,
    SPELL_AURA_MOD_DODGE_PERCENT = 49,
    SPELL_AURA_MOD_BLOCK_PERCENT = 51,
    SPELL_AURA_MOD_CRIT_PERCENT = 52,
    SPELL_AURA_PERIODIC_LEECH = 53,
    SPELL_AURA_MOD_HIT_CHANCE = 54,
    SPELL_AURA_MOD_SPELL_HIT_CHANCE = 55,
    SPELL_AURA_TRANSFORM = 56,
    SPELL_AURA_MOD_SPELL_CRIT_CHANCE = 57,
    SPELL_AURA_MOD_INCREASE_SWIM_SPEED = 58,
    SPELL_AURA_PERIODIC_MANA_LEECH = 64,
    SPELL_AURA_SCHOOL_ABSORB = 69,
    SPELL_AURA_MOD_SPELL_CRIT_CHANCE_SCHOOL = 71,
    SPELL_AURA_MOD_POWER_COST_SCHOOL_PCT = 72,
    SPELL_AURA_MOD_POWER_COST_SCHOOL = 73,
    SPELL_AURA_MECHANIC_IMMUNITY = 77,
    SPELL_AURA_WATER_BREATHING = 82,
    SPELL_AURA_MOD_POWER_REGEN = 85,
    SPELL_AURA_PERIODIC_DAMAGE_PERCENT = 89,
    SPELL_AURA_MANA_SHIELD = 97,
    SPELL_AURA_MOD_ATTACK_POWER = 99,
    SPELL_AURA_MOD_MELEE_ATTACK_POWER_VERSUS = 102,
    SPELL_AURA_ADD_FLAT_MODIFIER = 107,
    SPELL_AURA_ADD_PCT_MODIFIER = 108,
    SPELL_AURA_ADD_TARGET_TRIGGER = 109,
    SPELL_AURA_OVERRIDE_CLASS_SCRIPTS = 112,
    SPELL_AURA_MOD_MECHANIC_RESISTANCE = 117,
    SPELL_AURA_MOD_TARGET_RESISTANCE = 123,
    SPELL_AURA_MOD_RANGED_ATTACK_POWER = 124,
    SPELL_AURA_MOD_MELEE_DAMAGE_TAKEN = 125,
    SPELL_AURA_MOD_SPEED_ALWAYS = 129,
    SPELL_AURA_MOD_MOUNTED_SPEED_ALWAYS = 130,
    SPELL_AURA_MOD_RANGED_ATTACK_POWER_VERSUS = 131,
    SPELL_AURA_MOD_MANA_REGEN_INTERRUPT = 134,
    SPELL_AURA_MOD_HEALING_DONE = 135,
    SPELL_AURA_MOD_TOTAL_STAT_PERCENTAGE = 137,
    SPELL_AURA_MOD_HASTE = 138,
    SPELL_AURA_FORCE_REACTION = 139,
    SPELL_AURA_MOD_RANGED_HASTE = 140,
    SPELL_AURA_MOD_RANGED_AMMO_HASTE = 141,
    SPELL_AURA_SAFE_FALL = 144,
    SPELL_AURA_REDUCE_PUSHBACK = 149,
    SPELL_AURA_MOD_STEALTH_LEVEL = 154,
    SPELL_AURA_MOD_SHIELD_BLOCKVALUE = 158,
    SPELL_AURA_MOD_HEALTH_REGEN_IN_COMBAT = 161,
    SPELL_AURA_MOD_ATTACK_POWER_PCT = 166,
    SPELL_AURA_MOD_RANGED_ATTACK_POWER_PCT = 167,
    SPELL_AURA_MOD_DAMAGE_DONE_VERSUS = 168,
    SPELL_AURA_MOD_SPEED_NOT_STACK = 171,
    SPELL_AURA_MOD_MOUNTED_SPEED_NOT_STACK = 172,
    SPELL_AURA_MOD_SPELL_DAMAGE_OF_STAT_PERCENT = 174,
    SPELL_AURA_MOD_SPELL_HEALING_OF_STAT_PERCENT = 175,
    SPELL_AURA_MOD_FLAT_SPELL_DAMAGE_VERSUS = 180,
    SPELL_AURA_MOD_CRITICAL_THREAT = 183,
    SPELL_AURA_MOD_RATING = 189,
    SPELL_AURA_MOD_KILL_XP_PCT = 200,
    SPELL_AURA_MOD_SPEED_FLIGHT = 208,
    SPELL_AURA_MOD_FLIGHT_SPEED_ALWAYS = 209,
    SPELL_AURA_MOD_FLIGHT_SPEED_NOT_STACK = 211,
    SPELL_AURA_CHANGE_MODEL_FOR_ALL_HUMANOIDS = 233,
    SPELL_AURA_MECHANIC_DURATION_MOD_NOT_STACK = 234,
    SPELL_AURA_NO_REAGENT_USE = 256,
    SPELL_AURA_X_RAY = 273,
    SPELL_AURA_ABILITY_PERIODIC_CRIT = 286,
    SPELL_AURA_MOD_QUEST_XP_PCT = 291,
    SPELL_AURA_FAKE_INEBRIATE = 304,
    SPELL_AURA_PERIODIC_HASTE = 316,
}

const enum DEFENSE_TYPE {
    NONE = 0,
    MAGIC = 1,
    MELEE = 2,
    RANGED = 3
}

const enum SPELL_ATTR0 {
    SPELL_ATTR_ON_NEXT_SWING_NO_DAMAGE = 0x4,
    SPELL_ATTR_IMPOSSIBLE_DODGE_PARRY_BLOCK = 0x200000,
}

const enum SPELL_ATTR1 {
    SPELL_ATTR_EX_CHANNELED1 = 0x4,
    SPELL_ATTR_EX_CHANNELED2 = 0x40,
    SPELL_ATTR_EX_CHANNELED_ANY = 0x44,
}

const enum SPELL_ATTR2 {
    SPELL_ATTR_EX2_CANT_CRIT = 0x20000000
}

const enum SPELL_ATTR5 {
    SPELL_ATTR_SPELL_HASTE_AFFECTS_PERIODIC = 0x2000,
}

const enum SCHOOL_MASK {
    NONE	= 0x00,
    PHYSICAL= 0x01,
    HOLY	= 0x02,
    FIRE	= 0x04,
    NATURE	= 0x08,
    FROST	= 0x10,
    SHADOW	= 0x20,
    ARCANE	= 0x40,
}

interface EffectInfo {
    effectType: number,
    auraType?: number
    valueBase: number,
    valueRange: number,
    valuePerLevel: number,
    perResource: number,
    coef: number,
    coefAP: number,
    forceScaleWithHeal: boolean,
    period: number,
    weaponCoef: number,
    chainInfo?: {
        chains: number, 
        mult: number
    },
    auraStacks?: number,
    mechanic: number,
}

const enum PowerType {
    MANA = 0,
    RAGE = 1,
    ENERGY = 3,
}

interface RankInfo {
    school: number,
    isChannel: boolean,
    isBinary: boolean,
    gcd: number,
    defenseType: DEFENSE_TYPE,
    cantDogeParryBlock: boolean,
    equippedWeaponMask: number,
    noCrit: boolean,
    forceHeal: boolean,
    charges: number,
    spellnamecomment: string,
    spellLevel: number,
    maxLevel: number,
    duration: number,
    baseCost: number,
    baseCostPct: number,
    usePeriodicHaste: boolean,
    onNextAttack: boolean,
    effects: EffectInfo[]
}

interface ClassInfo {
    rankInfo: {[index: number]: RankInfo},
}

const enum ItemClass {
    ITEM_CLASS_CONSUMABLE   = 0,
    ITEM_CLASS_CONTAINER    = 1,
    ITEM_CLASS_WEAPON       = 2,
    ITEM_CLASS_GEM          = 3,
    ITEM_CLASS_ARMOR        = 4,
    ITEM_CLASS_REAGENT      = 5,
    ITEM_CLASS_PROJECTILE   = 6,
    ITEM_CLASS_TRADE_GOODS  = 7,
    ITEM_CLASS_GENERIC      = 8,
    ITEM_CLASS_RECIPE       = 9,
    ITEM_CLASS_MONEY        = 10,
    ITEM_CLASS_QUIVER       = 11,
    ITEM_CLASS_QUEST        = 12,
    ITEM_CLASS_KEY          = 13,
    ITEM_CLASS_PERMANENT    = 14,
    ITEM_CLASS_MISC         = 15
}

const enum ADDON_EFFECT_TYPE {
    SPELLMOD_PCT_EFFECT = "_addon.CONST.EFFECT_TYPE.SPELLMOD_PCT_EFFECT",
    SPELLMOD_PCT_DAMAGE_HEALING = "_addon.CONST.EFFECT_TYPE.SPELLMOD_PCT_DAMAGE_HEALING",
    SPELLMOD_PCT_OVER_TIME = "_addon.CONST.EFFECT_TYPE.SPELLMOD_PCT_OVER_TIME",
    SPELLMOD_FLAT_HIT_CHANCE = "_addon.CONST.EFFECT_TYPE.SPELLMOD_FLAT_HIT_CHANCE",
    FSR_SPIRIT_REGEN = "_addon.CONST.EFFECT_TYPE.FSR_SPIRIT_REGEN",
    SPELLMOD_FLAT_CRIT_CHANCE = "_addon.CONST.EFFECT_TYPE.SPELLMOD_FLAT_CRIT_CHANCE",
    SCHOOLMOD_RESISTANCE_PENETRATION = "_addon.CONST.EFFECT_TYPE.SCHOOLMOD_RESISTANCE_PENETRATION",
    SPELLMOD_MAGE_NWR_PROC = "_addon.CONST.EFFECT_TYPE.SPELLMOD_MAGE_NWR_PROC",
    SPELLMOD_FLAT_DURATION = "_addon.CONST.EFFECT_TYPE.SPELLMOD_FLAT_DURATION",
    SPELLMOD_FLAT_VALUE = "_addon.CONST.EFFECT_TYPE.SPELLMOD_FLAT_VALUE",
    EARTHFURY_RETURN = "_addon.CONST.EFFECT_TYPE.EARTHFURY_RETURN",
    SPELLMOD_GCD_MS = "_addon.CONST.EFFECT_TYPE.SPELLMOD_GCD_MS",
    TRIGGER_UPDATE = "_addon.CONST.EFFECT_TYPE.TRIGGER_UPDATE",
    SPELLMOD_EFFECT_PAST_FIRST = "_addon.CONST.EFFECT_TYPE.SPELLMOD_EFFECT_PAST_FIRST",
    MOD_MANA_PER_5 = "_addon.CONST.EFFECT_TYPE.MOD_MANA_PER_5",
    ILLUMINATION = "_addon.CONST.EFFECT_TYPE.ILLUMINATION",
    SPELLMOD_ADD_TRIGGER_SPELL = "_addon.CONST.EFFECT_TYPE.SPELLMOD_ADD_TRIGGER_SPELL",
    VERSUSMOD_PCT_DAMAGE = "_addon.CONST.EFFECT_TYPE.VERSUSMOD_PCT_DAMAGE",
    VERSUSMOD_FLAT_SPELLPOWER = "_addon.CONST.EFFECT_TYPE.VERSUSMOD_FLAT_SPELLPOWER",
    SPELLMOD_FLAT_SPELLPOWER = "_addon.CONST.EFFECT_TYPE.SPELLMOD_FLAT_SPELLPOWER",
    SPELLMOD_CRIT_MANARESTORE = "_addon.CONST.EFFECT_TYPE.SPELLMOD_CRIT_MANARESTORE",
    SPELLMOD_MANARESTORE = "_addon.CONST.EFFECT_TYPE.SPELLMOD_MANARESTORE",
    SPELLMOD_EFFECT1_FLAT_SPELLPOWER = "_addon.CONST.EFFECT_TYPE.SPELLMOD_EFFECT1_FLAT_SPELLPOWER",
    SPELLMOD_PCT_CRIT_MULT = "_addon.CONST.EFFECT_TYPE.SPELLMOD_PCT_CRIT_MULT",
    BOOLEAN_BITFLAG_SET = "_addon.CONST.EFFECT_TYPE.BOOLEAN_BITFLAG_SET",
    SPELLMOD_ALLOW_PERIODIC_HASTE = "_addon.CONST.EFFECT_TYPE.SPELLMOD_ALLOW_PERIODIC_HASTE",
    SPELLMOD_ALLOW_PERIODIC_CRIT = "_addon.CONST.EFFECT_TYPE.SPELLMOD_ALLOW_PERIODIC_CRIT",
}

interface AddonEffectData
{
    type: string,
    affectMask?: number,
    affectSpell?: number[],
    value?: number | string
}

const enum SpellMechanic 
{
    BLEED = 15,
    INFECTED = 22
}