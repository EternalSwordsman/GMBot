class Item
	@item_type = ""
	@attack_desc = ""

	attr_reader :slot, :name, :attack_bonus, :defense_bonus, :damage_bonus, :description

	# You can use this function three ways:
	# initialize(slot, name, attack_bonus, defense_bonus, damage, description, attack_type)
	# 		This creates an item with the stats specified
	# initialize(level)
	# 		This creates a random item with stats calibrated to a character of the specified level
	# initialize(level, slot)
	#  		Creates a random item with stats calibrated to a character of the specified level, but also
	# 		chooses a name and description from the provided lists. Put matching names/descriptions in
	#  		the same index in each list.

	def initialize(*args)
		@slot_names = ['head', 'neck', 'body', 'l_hand', 'r_hand','2_hand' ,'waist' , 'legs', 'feet']
		if args.size == 7
			@slot = args[0]
			@name = args[1]
			@attack_bonus = args[2]
			@defense_bonus = args[3]
			@damage = args[4]
			@description = args[5]
			@attack_type = args[6]
			#@attack_type = "normal"
		elsif args.size == 1
			#generate a random item
			@attack_bonus = 0
			@defense_bonus = 0
			@damage = 0
			@attack_type = ""
			@slot = @slot_names[rand(8)]
			@name = generateItemName(@slot)
			case @slot
			when 'head'
				@defense_bonus = args[0] * rand(2..7)
			when 'neck'
				@defense_bonus = args[0] * rand(2..5)
			when 'body'
				@defense_bonus = args[0] * rand(3..10)
			when 'l_hand'
				@attack_bonus = args[0] * rand(1..15)
				@damage = args[0] * rand(3..12)
			when 'r_hand'
				@defense_bonus = args[0] * rand(5..10)
			when '2_hand'
				@attack_bonus = args[0] * rand(2..30)
				@damage = args[0] * rand(8..20)
			when 'waist'
				@defense_bonus = args[0] * rand(2..5)
			when 'legs'
				@defense_bonus = args[0] * rand(2..6)
			when 'feet'		
				@defense_bonus = args[0] * rand(1..5)
			end
			@description = "#{@name} \nAttack Bonus: +#{@attack_bonus}\nDefense Bonus: +#{@defense_bonus}\nDamage: #{@damage}\nSlot: #{@slot}"
		elsif args.size == 2
			#generate a random item, for a specific slot
			@attack_bonus = 0
			@defense_bonus = 0
			@damage = 0
			@attack_type = ""
			@slot = args[1]
			@name = generateItemName(@slot)
			case @slot
			when 'head'
				@defense_bonus = args[0] * rand(2..7)
			when 'neck'
				@defense_bonus = args[0] * rand(2..5)
			when 'body'
				@defense_bonus = args[0] * rand(3..10)
			when 'l_hand'
				@attack_bonus = args[0] * rand(1..15)
				@damage = args[0] * rand(3..12)
			when 'r_hand'
				@defense_bonus = args[0] * rand(5..10)
			when '2_hand'
				@attack_bonus = args[0] * rand(2..30)
				@damage = args[0] * rand(8..20)
			when 'waist'
				@defense_bonus = args[0] * rand(2..5)
			when 'legs'
				@defense_bonus = args[0] * rand(2..6)
			when 'feet'		
				@defense_bonus = args[0] * rand(1..5)
			end
			@description = "#{@name} \nAttack Bonus: +#{@attack_bonus}\nDefense Bonus: +#{@defense_bonus}\nDamage: #{@damage}\nSlot: #{@slot}"
		end
	end

	def get_stat_changes
		bonuses_a = {'attack' => @attack_bonus, 
					 'defense' => @defense_bonus,
					 'damage' => @damage,
					 'attack_type' => @attack_type}
	end

end


def generateItemName(slot)
	head_types = ["Helm", "Wizard's Hat", "Cap", "Helmet"]
	neck_types = ["Amulet", "Necklace", "Torc", "Pendant", "Bowtie", "Scarf"]
	body_types = ["Breastplate", "Shirt", "Jacket", "Vest"]
	l_hand_types = ["Sword", "Dagger", "Shortsword", "Mace", "Wand", "Hand Axe"]
	r_hand_types = ["Shield", "Buckler"]
	two_hand_types = ["Longsword", "Claymore", "Spear", "Crossbow", "Halberd", "Staff", "Glaive", "Lance", "War Axe", "Warhammer"]
	waist_types = ["Belt", "Sash", "Skirt"]
	legs_types = ["Greaves", "Shinpads", "Pants", "Legs"]
	feet_types = ["Shoes", "Boots", "Slippers", "Sandals", "Socks"]


	of_what = [" of Doom", " of the Heirophant", " of Stabbing", " of the Void", " of Fire", " of Water", " of Ice", " of Unicorns", " of Dragons"]
	return_s = ""
	case slot
	when 'head'
		index = rand(0..(head_types.size() - 1))
		return_s = head_types[index]
	when 'neck'
		index = rand(0..(neck_types.size() - 1))
		return_s = neck_types[index]
	when 'body'
		index = rand(0..(body_types.size() - 1))
		return_s = body_types[index]
	when 'l_hand'
		index = rand(0..(l_hand_types.size() - 1))
		return_s = l_hand_types[index]
	when 'r_hand'
		index = rand(0..(r_hand_types.size() - 1))
		return_s = r_hand_types[index]
	when '2_hand'
		index = rand(0..(two_hand_types.size() - 1))
		return_s = two_hand_types[index]
	when 'waist'
		index = rand(0..(waist_types.size() - 1))
		return_s = waist_types[index]
	when 'legs'
		index = rand(0..(legs_types.size() - 1))
		return_s = legs_types[index]
	when 'feet'
		index = rand(0..(feet_types.size() - 1))
		return_s = feet_types[index]
	end

	index = rand(0..(of_what.size() - 1))
	return_s = return_s + of_what[index]
end