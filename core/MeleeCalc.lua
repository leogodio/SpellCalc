---@class AddonEnv
local _addon = select(2, ...);

local _, race = UnitRace("player");
local _, class = UnitClass("player");
local stats = _addon.stats;
local SCHOOL_PHYSICAL = _addon.CONST.SCHOOL.PHYSICAL;

---@class MeleeCalc
local MeleeCalc = {};
MeleeCalc.__index = MeleeCalc;

--- Get an object used to calculate melee stuff
---@return MeleeCalc
function MeleeCalc:New()
    local mc = {};
    setmetatable(mc, MeleeCalc);
    return mc;
end

--- Initialize for new spell
---@param calcedSpell CalcedSpell
---@param isOffhand boolean @Use offhand weapon skill
---@param isWhitehit boolean @Is for auto attack
---@param isRanged boolean
---@param cantDodgeParryBlock boolean
function MeleeCalc:Init(calcedSpell, isOffhand, isWhitehit, isRanged, cantDodgeParryBlock)
    _addon.util.PrintDebug("Init MeleeCalc - OH:"..tostring(isOffhand).." WH: "..tostring(isWhitehit).." R: "..tostring(isRanged));
    local tData = _addon.Target;
    local ldef = tData.level * 5; -- Level based def value
    local latk = 5 * UnitLevel("player"); -- Level based attack value
    local ratk = latk; -- Real attack value
    self.isPvP = tData.isPlayer;

    if not self.isPvP then
        if isRanged and stats.attackDmg.ranged.min > 0 then
            ratk = stats.attack.ranged;
        else
            ratk = isOffhand and stats.attack.offhand or stats.attack.mainhand;
        end

        if class == "DRUID" then
            local sm = _addon.CONST.STANCE_MASK;
            if _addon.IsCurrentStance(sm.BEAR + sm.BEAR_2 + sm.CAT) then
                ratk = latk;
            end
        end

        self.isPvP = false;
    end

    _addon.util.PrintDebug("Using ldef: "..ldef.." latk: "..latk.." ratk: "..ratk);

    self.ldef = ldef;
    self.latk = latk;
    self.ratk = ratk;
    self.levelDiff = tData.levelDiff;
    self.targetLevel = tData.level;
    self.calcedSpell = calcedSpell;
    self.isOffhand = isOffhand;
    self.isWhitehit = isWhitehit;
    self.cantDodgeParryBlock = cantDodgeParryBlock;
    self.isRanged = isRanged;
    self.expertiseReduction = select(isOffhand and 2 or 1, GetExpertise()) * 0.25;
end

--- Get crit chance
function MeleeCalc:GetCrit()
    local basecrit = self.isRanged and stats.attackCrit.ranged or stats.attackCrit.mainhand;

    if self.isOffhand then
        -- adjust attack skill based crit for offhand
        -- MINOR PROBLEM: this will create bullshit results if mainhand skill is low enough to fall below minimum crit
        basecrit = basecrit - (stats.attack.offhand - stats.attack.mainhand) * 0.04;

        -- adjust offhand crit for weapon specific talents (warrior axe spec and rogue dagger and fisting spec)
        -- TODO: this is bullshit lol
        if _addon:GetWeaponType("mainhand") ~= _addon:GetWeaponType("offhand") then
            if class == "WARRIOR" then
                local curRank = select(5, GetTalentInfo(1, 12)); -- axe spec
                if curRank > 0 then
                    if _addon:IsWeaponTypeEquipped(_addon.CONST.WEAPON_SUBCLASS.AXE_1H, "mainhand") then
                        basecrit = basecrit - curRank;
                    elseif _addon:IsWeaponTypeEquipped(_addon.CONST.WEAPON_SUBCLASS.AXE_1H, "offhand") then
                        basecrit = basecrit + curRank;
                    end
                end
            elseif class == "ROGUE" then
                local curRank = select(5, GetTalentInfo(2, 11)); -- dagger spec
                if curRank > 0 then
                    if _addon:IsWeaponTypeEquipped(_addon.CONST.WEAPON_SUBCLASS.DAGGER, "mainhand") then
                        basecrit = basecrit - curRank;
                    elseif _addon:IsWeaponTypeEquipped(_addon.CONST.WEAPON_SUBCLASS.DAGGER, "offhand") then
                        basecrit = basecrit + curRank;
                    end
                end

                curRank = select(5, GetTalentInfo(2, 16)); -- fisting spec
                if curRank > 0 then
                    if _addon:IsWeaponTypeEquipped(_addon.CONST.WEAPON_SUBCLASS.FIST, "mainhand") then
                        basecrit = basecrit - curRank;
                    elseif _addon:IsWeaponTypeEquipped(_addon.CONST.WEAPON_SUBCLASS.FIST, "offhand") then
                        basecrit = basecrit + curRank;
                    end
                end
            end
        end
    end

    if self.isPvP then
        -- basecrit (the spellbook crit) includes changes as if the target is a player on your level (lvl*5 def),
        -- which means we only have to adjust for level differences.
        return math.max(0, basecrit + (self.latk - self.ldef) * 0.04);
    end

    -- against NPCs weapon skill above the level based max is ignored for crit
    local effectiveAttack = math.min(self.ratk, self.latk);
    local adDiff = effectiveAttack - self.ldef;

    -- spellbook crit (basecrit) already includes a 0.04% change for every point you are above or below YOUR level based maximum!
    -- need to adjust crit so that bonuses from weapon skill are removed and penalties are applied correctly based on target level/def
    local crit = basecrit + (self.latk - self.ratk) * 0.04;
    -- apply real changes
    if adDiff < 0 then
        crit = crit + adDiff * 0.2;
    elseif adDiff > 0 then
        crit = crit + adDiff * 0.04;
    end

    -- NOTE: Maybe get auracrit so we know we have some, or just take it as granted?
    if self.levelDiff > 2 then
        crit = crit - 1.8;
    end

    if stats.targetSchoolModCritTaken[SCHOOL_PHYSICAL].val ~= 0 then
        crit = crit + stats.targetSchoolModCritTaken[SCHOOL_PHYSICAL].val;
        self.calcedSpell:AddToBuffList(stats.targetSchoolModCritTaken[SCHOOL_PHYSICAL].buffs);
    end

    if crit < 0 then
        crit = 0;
    elseif crit > 100 then
        crit = 100;
    end

    if self.isRanged then
        _addon.util.PrintDebug("Ranged crit: " .. crit);
    else
        _addon.util.PrintDebug("Melee crit: " .. crit);
    end

    return crit;
end

--- Get parry chance against target
---@param calc MeleeCalc
local function GetParryChance(calc)
    if calc.isPvP 
    or not SpellCalc_settings.meleeFromFront 
    or calc.cantDodgeParryBlock
    or calc.isRanged then
        return 0;
    end

    local pchance = 0;
    if calc.ldef - calc.ratk > 10 then
        pchance = 5 + (calc.ldef - calc.ratk) * 0.6;
    else
        pchance = 5 + (calc.ldef - calc.ratk) * 0.1;
    end
    return math.max(0, pchance - calc.expertiseReduction);
end

--- Get dodge chance against target
---@param calc MeleeCalc
---@param skillDiff integer Differenmce between attack skill and defense skill
local function GetDodgeChance(calc, skillDiff)
    if calc.cantDodgeParryBlock or calc.isRanged then
        return 0;
    end

    if calc.isPvP then
        return 0; -- dodge + skillDiff * 0.04;
    end

    return math.max(0, 5 + skillDiff * 0.1 - calc.expertiseReduction);
end

--- Get miss chance against target
---@param calc MeleeCalc
---@param skillDiff integer
local function GetMissChance(calc, skillDiff)
    local miss;

    if calc.isPvP then
        miss = math.max(0, 5 + skillDiff * 0.04);
    else
        if skillDiff > 10 then
            miss = math.max(0, 5 + skillDiff * 0.2);
        else
            miss = math.max(0, 5 + skillDiff * 0.1);
        end
 
        if calc.targetLevel < 10 then
            miss = miss * calc.targetLevel / 10;
        end
    end

    if calc.isWhitehit and not calc.isRanged and _addon:IsDualWieldEquipped() then
        miss = 0.8 * miss + 20;
    end

    if miss > 100 then
        return 100;
    end

    return miss;
end

--- Get glancing chance and average damage reduction
---@param ldef integer Level based def value for target
---@param baseAtk integer Base attack value for level
---@param atk integer Actual attack value for weapon
local function GetGlancingChanceAndDamage(ldef, baseAtk, atk)
    local skillDiff = ldef - atk;
    local glancing = math.max(0, 6 + skillDiff * 1.2);
    local minReduction, maxRedcution;
    if skillDiff > 10 then
        minReduction = math.max(0.01, math.min(0.91, 1.3 - 0.05 * skillDiff));
        maxRedcution = math.max(0.2, math.min(0.99, 1.2 - 0.03 * skillDiff));
    else
        minReduction = math.max(0.01, math.min(1.4 - 0.05 * skillDiff, 0.91));
        maxRedcution = math.max(0.2, math.min(1.3 - 0.03 * skillDiff, 0.99));
    end

    local glancingDamage = (minReduction + maxRedcution) / 2;
    return glancing, glancingDamage;
end

local function GetBlockChancePH(calc, skillDiff)
    if calc.isPvP or not SpellCalc_settings.meleeFromFront or calc.cantDodgeParryBlock then
        return 0;
    end
    return math.min(5, 5 + skillDiff * 0.1);
end

--- Get melee attack table against current target
---@return number hit chance in percent, excluding hitBonus!
---@return number dodge chance in percent
---@return number parry chance in percent
---@return number glancing chance if isWhitehit is true
---@return number block chance in percent
---@return number hitBonus after level based penalty
---@return number glancingDamage if isWhitehit is true
function MeleeCalc:GetMDPGB()
    local skillDiff = self.ldef - self.ratk;

    local hit = 100 - GetMissChance(self, skillDiff);
    local hitBonus = 0;

    if stats.hitBonus.val > 0 then
        hitBonus = hitBonus + stats.hitBonus.val;
        self.calcedSpell:AddToBuffList(stats.hitBonus.buffs);
    end

    if stats.targetSchoolModHit[SCHOOL_PHYSICAL].val ~= 0 then
        hitBonus = hitBonus + stats.targetSchoolModHit[SCHOOL_PHYSICAL].val;
        self.calcedSpell:AddToBuffList(stats.targetSchoolModHit[SCHOOL_PHYSICAL].buffs);
    end

    local total = 100;

    local realMiss = math.max(0, 100 - hit + hitBonus);
    total = total - realMiss;

    local dodge = GetDodgeChance(self, skillDiff);

    if total < dodge then
        return hit, total, 0, 0, 0, hitBonus, 0;
    end
    total = total - dodge;

    local parry = GetParryChance(self);

    if total < parry then
        return hit, dodge, total, 0, 0, hitBonus, 0;
    end
    total = total - parry;

    local glancing, glancingDmg;
    if self.isWhitehit and not self.isPvP and not self.isRanged then
        glancing, glancingDmg = GetGlancingChanceAndDamage(self.ldef, self.latk, self.ratk);
    end

    if glancing then
        if total < glancing then
            return hit, dodge, parry, total, 0, hitBonus, glancingDmg;
        end
        total = total - glancing;
    end

    local block = GetBlockChancePH(self, skillDiff);

    if total < block then
        return hit, dodge, parry, glancing, total, hitBonus, glancingDmg;
    end

    return hit, dodge, parry, glancing, block, hitBonus, glancingDmg;
end

--- Get damage reduction from armor for current target
---@return number mitigation The mitigation multiplier, max 0.75.
---@return number armor The effective armor after of the current target.
function MeleeCalc:GetArmorDR()
    local armor = _addon.Target:GetEffectiveResistance(SCHOOL_PHYSICAL);
    local pLevel = UnitLevel("player");
    local arpCap = (935/6) * _addon.Target.level + armor/3 - 44335/6;
    local effArmor = armor - (GetArmorPenetration()/100) * math.min(armor, arpCap);
    local mitigation;

    if pLevel < 60 then
        mitigation = effArmor / (effArmor + 400 + pLevel * 85);
    else
        mitigation = effArmor / (effArmor + 400 + 85 * (pLevel + 4.5 * (pLevel - 59)));
    end

    return math.min(mitigation, 0.75), effArmor;
end

_addon.MeleeCalc = MeleeCalc;