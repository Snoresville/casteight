examplemodifier = examplemodifier or class({})

function examplemodifier:GetTexture() return "skywrath_mage_mystic_flare" end -- get the icon from a different ability

function examplemodifier:IsPermanent() return true end
function examplemodifier:RemoveOnDeath() return false end
function examplemodifier:IsHidden() return false end 	-- we can hide the modifier
function examplemodifier:IsDebuff() return false end 	-- make it red or green


function examplemodifier:DeclareFunctions()
	if IsClient() then return {} end
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return funcs
end

local directions = 8
function examplemodifier:OnAbilityFullyCast(kv)
	if kv.unit ~= self:GetParent() then return end

	local ability = kv.ability
	local cast_location = ability:GetCursorPosition()

	local already_hit = {}

	if self:HasBehavior(ability, DOTA_ABILITY_BEHAVIOR_POINT) then
		for i = 1, directions-1 do
			local new_direction = RotatePosition(self:GetParent():GetAbsOrigin(), QAngle(0, i/directions * 360, 0), cast_location)
			self:GetParent():SetCursorPosition(new_direction)
			ability:OnSpellStart()
		end
	elseif self:HasBehavior(ability, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) then
		for i = 1, directions-1 do
			local new_direction = RotatePosition(self:GetParent():GetAbsOrigin(), QAngle(0, i/directions * 360, 0), cast_location)
			local targets = FindUnitsInRadius(self:GetParent():GetTeam(), 
				new_direction, 
				nil, 
				FIND_UNITS_EVERYWHERE, 
				ability:GetAbilityTargetTeam(), 
				ability:GetAbilityTargetType(), 
				ability:GetAbilityTargetFlags(), FIND_CLOSEST, false)

			if #targets > 0 then
				for _, target in pairs(targets) do
					if not already_hit[target:GetEntityIndex()] then
						already_hit[target:GetEntityIndex()] = true
						self:GetParent():SetCursorCastTarget(target)
						ability:OnSpellStart()
						break
					end
				end
			end
		end
	end
end

function examplemodifier:HasBehavior(ability, behavior)
	if not ability or ability:IsNull() then return end
	local abilityBehavior = tonumber(tostring(ability:GetBehaviorInt()))
	return bit.band(abilityBehavior, behavior) == behavior
end