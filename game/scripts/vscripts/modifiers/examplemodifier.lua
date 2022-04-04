examplemodifier = examplemodifier or class({})

function examplemodifier:GetTexture() return "lina_fiery_soul" end -- get the icon from a different ability

function examplemodifier:IsPermanent() return true end
function examplemodifier:RemoveOnDeath() return false end
function examplemodifier:IsHidden() return true end 	-- we can hide the modifier
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

	if self:HasBehavior(ability, DOTA_ABILITY_BEHAVIOR_POINT) then
		for i = 1, directions-1 do
			local new_direction = RotatePosition(self:GetParent(), QAngle(0, i/directions * 360, 0), cast_location)
			self:GetParent():SetCursorPosition(new_direction)
			ability:OnSpellStart()
		end
	end
end

function examplemodifier:HasBehavior(ability, behavior)
	if not ability or ability:IsNull() then return end
	local abilityBehavior = tonumber(tostring(ability:GetBehaviorInt()))
	return bit.band(abilityBehavior, behavior) == behavior
end