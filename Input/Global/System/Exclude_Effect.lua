excludeEffect = {
	15,
	1074,
}

-- function

function GetExcludeEffect()

	for k, EffectID in pairs( excludeEffect ) do

		result, msg = AddEffect( EffectID )

		if( not result) then return false, msg; end

	end

	return true, "good";

end
