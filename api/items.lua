-----------------------------------------------------------------------------------------

local items = {}

-----------------------------------------------------------------------------------------

function items.find(name)
	return items.map[name]
end

-----------------------------------------------------------------------------------------

items.list = {
	{
		name = "Journal", 
		imageFile = "journal.png"
	},
	{
		name = "Oracle", 
		imageFile = "hints_icon_off.png"
	},
	{
		name = "ShowerHandle", 
		imageFile = "diamond_handle_icon.png"
	},	
	{
		name = "PoolPumpPipe", 
		imageFile = "pipe_icon.png"
	},
	{
		name = "CrankHandle", 
		imageFile = "crank_handle.png"
	},
	{
		name = "WaterHeaterHandle", 
		imageFile = "heater_valve.png"
	},	
	{
		name = "Ladder", 
		imageFile = "ladder_icon.png"
	},
	{
		name = "ToiletPaper", 
		imageFile = "toiletpaper_icon.png"
	},
	{
		name = "ChestRoundCrest", 
		imageFile = "man_medal_icon.png"
	},
	{
		name = "ChestHexCrest", 
		imageFile = "lion_medal_icon.png"
	},
	{
		name = "ChestSquareCrest", 
		imageFile = "skull_medal_icon.png"
	},
	{
		name = "Crowbar", 
		imageFile = "crowbar_icon.png"
	},
	{
		name = "Battery", 
		imageFile = "battery_icon.png"
	},
	{
		name = "StorageKey", 
		imageFile = "clover_key_icon.png"
	},
	{
		name = "Rose", 
		imageFile = "red_rose_icon.png"
	},
	{
		name = "Robot", 
		imageFile = "robot_off_icon.png"
	},
	{
		name = "PoweredRobot", 
		imageFile = "robot_on_icon.png"
	},
	{
		name = "ToiletHandle", 
		imageFile = "toilet_handle_icon.png"
	},
	{
		name = "Trophy", 
		imageFile = "big_trophy_icon.png"
	},
	{
		name = "Coin", 
		imageFile = "coin_icon.png"
	},
	{
		name = "Pillow", 
		imageFile = "pillow_icon.png"
	},
	{
		name = "Chips", 
		imageFile = "porkitos_icon.png"
	},
	{
		name = "RobotHead", 
		imageFile = "robot_head_icon.png"
	},
	{
		name = "Apple", 
		imageFile = "apple_icon.png"
	},
	{
		name = "ChestKey", 
		imageFile = "silver_key_icon.png"
	},
	{
		name = "Treasure", 
		imageFile = "dragon_icon.png"
	},
	{
		name = "VandalizedPhoto", 
		imageFile = "mirandas_photo_icon.png"
	},
	{
		name = "Mirror", 
		imageFile = "mirror_icon.png"
	},
}

-----------------------------------------------------------------------------------------

items.map = {}

for item in list_iter(items.list) do
	items.map[item.name] = item
end

-----------------------------------------------------------------------------------------

return items

-----------------------------------------------------------------------------------------
