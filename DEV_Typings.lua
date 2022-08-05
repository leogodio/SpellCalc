---@class AddonEnv
local _addon = select(2, ...);

---@class SpellEffectData
---@field effectType SpellEffectType
---@field auraType SpellAuraType|nil
---@field forceScaleWithHeal boolean|nil
---@field valueBase integer
---@field valueRange integer
---@field valuePerLevel number|nil
---@field coef number
---@field coefAP number
---@field weaponCoef number|nil
---@field tickPeriod integer|nil In seconds
---@field chains integer|nil
---@field chainMult number|nil
---@field auraStacks integer|nil

---@class SpellInfo
---@field school SpellSchool
---@field isChannel boolean|nil
---@field isBinary boolean|nil
---@field GCD number|nil In seconds
---@field defType SpellDefenseType
---@field cantDogeParryBlock boolean|nil
---@field equippedWeaponMask integer|nil
---@field noCrit boolean|nil
---@field forceHeal boolean|nil
---@field charges integer|nil
---@field spellLevel integer
---@field maxLevel integer
---@field duration integer|nil In seconds
---@field baseCost integer|nil
---@field baseCostPct integer|nil
---@field usePeriodicHaste boolean|nil
---@field mechanic SpellMechanic|nil
---@field effects SpellEffectData[]

---@type SettingsTable
SpellCalc_settings = SpellCalc_settings;

SpellCalcStatScreen = {}

---@type nil|fun():table<string,table>
_addon.ClassSettings = function() end

---@alias SpellInfoTable table<integer, SpellInfo>
---@type SpellInfoTable
_addon.spellInfo = {};

_addon.spellClassSet = {
    ---@type table<integer, integer[]>
    [1] = {},
    ---@type table<integer, integer[]>
    [2] = {},
    ---@type table<integer, integer[]>
    [3] = {},
    ---@type table<integer, integer[]>
    [4] = {},
};

---@alias EffectScript fun(val:integer, cs:CalcedSpell, ce:CalcedEffect|nil, spellId:number, si:SpellInfo, scriptType: AddonEffectType)
---@alias AuraScript fun(apply:boolean, auraId:integer, fromPlayer:boolean, scriptType: AddonEffectType, cacheValue:integer|nil):integer

---@class AuraEffectBase
---@field type AddonEffectType
---@field affectMask integer|nil
---@field affectSpell integer[]|nil
---@field affectMechanic SpellMechanic|nil
---@field neededWeaponMask integer|nil
---@field scriptKey string|nil Key for script effect. Must be unique!
---@field auraCategory DebuffCategory Effects from same category don't stack with each other.

---@class UnitAuraEffect : AuraEffectBase
---@field value integer|nil
---@field scriptValue string|nil Get value from scriptKey.
---@field hasStacks boolean|nil Does the aura have stacks (e.g. Sunder Armor).

---@class SetBonusAuraEffect : UnitAuraEffect
---@field need integer The number of set items needed for the effect to be active.

---@class ItemSetData
---@field name string
---@field effects SetBonusAuraEffect[]

---@alias ItemSetDataTable table<integer, ItemSetData>

---@alias ItemEffects table<integer, UnitAuraEffect[]>
---@alias SetItemDataTable table<integer, integer>

---@class EnchantData : UnitAuraEffect
---@field name string

---@class TalentEffect : AuraEffectBase
---@field base integer|nil
---@field perPoint integer|nil
---@field values integer[]|nil

---@class TalentDataEntry
---@field tree integer
---@field talent integer
---@field effects TalentEffect[]

---@class TalentDataRawEntry
---@field tree integer
---@field tier integer
---@field column integer
---@field effects TalentEffect[]

---@type TalentDataRawEntry[]
_addon.talentDataRaw = {}

---@alias ClassGlyphs table<integer, UnitAuraEffect[]>

---@class AddonEnv
---@field classGlyphs ClassGlyphs

---@type UnitAuraEffect[]
_addon.classPassives = {};