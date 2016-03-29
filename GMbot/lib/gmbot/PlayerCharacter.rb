#PlayerCharacter class
#This holds all the data about a player's character
class PlayerCharacter

	attr_reader :inventory, :current_enemy, :user_id, :level

	def initialize(user_id)
		@user_id = user_id	# User who created this character. Their name will be printed with all messages

		#base stats
		@attack = rand(-4..4)
		@defense = rand(10..15)
		@damage = 1

		#effective stats - modified by equipment
		@effective_attack = @attack
		@effective_defense = @defense
		@effective_damage = @damage
		@attack_type = "normal"
		@resistances = []
		@weaknesses = []

		#general stats
		@level = 1
		@experience = 0
		@exp_to_next_level = 1000
		@max_health = rand(20..40)
		@current_health = @max_health
		@status = []
		@gold = 0
		@wins = 0
		@losses = 0

		#Other stuff
		@class = "Rat Catcher"
		@current_enemy = nil
		@current_equipment = {'head' => nil, 
							  'neck' => nil, 
							  'body' => nil, 
							  'l_hand' => nil, 
							  'r_hand' => nil,
							  'waist' => nil,
							  'legs' => nil,
							  'feet' => nil}
		@inventory = []
		@spells_known = []

		# Give the player some starting stuff
		put_item_in_inventory(Item.new(@level, 'l_hand'))
		put_item_in_inventory(Item.new(@level, 'body'))
		put_item_in_inventory(Item.new(@level, 'feet'))
		equip_item(2)
		equip_item(1)
		equip_item(0)
	end

	# Choose a class - NOT IMPLEMENTED
	def choose_class(class_choice)
		#do stuff here later, but for now, just change @class
		@class = class_choice
		return (@user_id.mention() + " changed their class to #{class_choice}")
	end

	def put_item_in_inventory(item)
		@inventory.push(item)
		return_s = @user_id.mention() + " got a #{item.name}! The put it in their inventory at location #{@inventory.size()}"
	end

	def equip_item(index)
		if index > @inventory.size
			return (@user_id.mention() + " isn't carrying that many items!")
		elsif 0 > index
			return (@user_id.mention() + " isn't sure how to equip an item from there")
		end
		slot = @inventory[index - 1].slot
		return_s = ""
		#Remove the item currently equipped in this slot
		if '2_hand' == slot
			if nil != @current_equipment['l_hand']
				return_s << self.unequip_item('l_hand')
			end
			if nil != @current_equipment['l_hand']
				return_s << self.unequip_item('r_hand')
			end
			slot = 'r_hand'
		else
			if nil != @current_equipment[slot]
				return_s << self.unequip_item(slot)
			end
		end
		@current_equipment[slot] = @inventory[index - 1]
		if nil != @current_equipment[slot]
			stat_change_a = @current_equipment[slot].get_stat_changes()
			@effective_attack = @effective_attack + stat_change_a['attack']
			@effective_defense = @effective_defense + stat_change_a['defense']
			@effective_damage = @effective_damage + stat_change_a['damage']
			if nil != stat_change_a['attack_type']
				@attack_type = stat_change_a['attack_type']
			end
		end
		@inventory.delete_at(index - 1)
		return_s << @user_id.mention() + " equipped #{@current_equipment[slot].name}"
	end

	def unequip_item(slot)
		#Remove the stat bonuses from any already equipped item
		if nil != @current_equipment[slot]
			stat_change_a = @current_equipment[slot].get_stat_changes()
			@effective_attack = @effective_attack - stat_change_a['attack']
			@effective_defense = @effective_defense - stat_change_a['defense']
			@effective_damage = @effective_damage - stat_change_a['damage']
			@attack_type = "normal"
			@inventory.push(@current_equipment[slot])
			@current_equipment[slot] = nil
			inventory_index = @inventory.size() - 1
			return @user_id.mention() + " unequipped #{@inventory[inventory_index].name} from #{slot}\n"
		else
			return @user_id.mention() + " tried to unequip item from #{slot}, but there was nothing there!\n"
		end
	end

	def list_inventory
		return_s = @user_id.mention() + "'s Inventory: \nEquipped: \n"
		final_index = inventory.size() - 1
		@current_equipment.each do |slot, item| 
			if nil != item
				return_s << "	#{slot}: #{item.name}\n"
			else
				return_s << "	#{slot}: Nothing\n" 
			end
		end
		return_s << "Pack: \n"
		if 0 > final_index
			return_s << "	Empty!"
		else
			0.upto(final_index) do |x|
				return_s << "	#{x + 1}. #{inventory[x].name} \n"
			end
		end
		return return_s
	end

	def list_character
		return_s = @user_id.mention() + "\nClass: #{@class}\nLevel: #{@level}\nExperience: #{@experience}\nHealth: #{@current_health} / #{@max_health}
Attack: #{@effective_attack}\nDefense: #{@effective_damage}\nGold: #{@gold}\nWins/Losses: #{@wins} / #{@losses}"

		return return_s
	end

	def list_status
		return_s = "Name: " + @user_id.mention() + "\nHealth: #{@current_health} / #{@max_health}"
	end

	# Figures out character's attack, then calls monster's defend method
	def attack
		attack_rating = @effective_attack + rand(1..20)
		damage_rating = rand(1..@effective_damage)
		status = nil
		if nil != @current_enemy
			damage = @current_enemy.defend(attack_rating, damage_rating, @attack_type, status)
			if damage.is_a?(Integer)
				return @user_id.mention() + " attacked #{@current_enemy.name} and dealt #{damage} damage!"
			elsif damage.is_a?(String)
				return damage
			end
		else
			return @user_id.mention() + " attacked the air!"
		end
	end

	# Called by monster's defend method, compares attack value with defense value, applies damage if necessary
	def defend(attack_value, damage_value, type, status)
		if attack_value > @effective_defense
			damage = damage_value
			if @resistances.include?(type)
				damage = damage / 2
			end
			if @weaknesses.include?(type)
				damage = damage * 2
			end
			@current_health = @current_health - damage
			if @current_health <= 0
				 return self.defeat()
			elsif nil != status
				@status.push(status)
			end
		else
			damage = @user_id.mention() + " dodged the #{@current_enemy.name}'s blow!"
		end
		return damage
	end

	# When a monster runs out of Health, it calls this function to let the player character know
	def victory(monster_name, experience, gold, loot)
		@experience = @experience + @current_enemy.experience
		@gold = @gold + @current_enemy.gold
		@wins = @wins + 1
		@current_health = @max_health
		return_s = @user_id.mention() + " defeated #{@current_enemy.name}! Gained #{@current_enemy.experience} XP and #{@current_enemy.gold} Gold! It also dropped: \n"
		if nil != @current_enemy.loot
			@current_enemy.loot.each do |x|
				return_s << "#{x.name}\n"
				@inventory.push(x) #depends on how we do inventory; array of equipment objects, or a hash
			end
		end
		@current_enemy = nil
		if @experience > @exp_to_next_level
			return_s << self.level_up()
		end
		return return_s
	end

	# When a player character dies, save the high score (if necessary), reset gold and status
	def defeat()
		@losses = @losses + 1
		@status = []
		if nil != @current_enemy
			return_s = @user_id.mention() + " was defeated by #{@current_enemy.name}. They had #{@experience} XP and #{@gold} Gold"
			@current_enemy = nil
		else
			return_s = @user_id.mention() + " tripped and fell unconscious! They had #{@experience} XP and #{@gold} Gold"
		end
		@gold = 0
		@current_health = @max_health
		return return_s
	end

	def do_status_effects
		@status.each do |x|
			x.do_status()
		end
	end

	def assign_enemy(monster)
		if nil != @current_enemy
			return_s = @user_id.mention() + " is already fighting #{@current_enemy.name}! #{@monster.name} went home"
		else
			@current_enemy = monster
			@current_enemy.set_target(self)
			return_s = "#{monster.name} attacks " + @user_id.mention()
		end
		return return_s
	end

	def level_up
		@exp_to_next_level = @exp_to_next_level * 5
		attack_increase = rand(1..10)
		defense_increase = rand(1..10)
		health_increase = rand(10..30)
		@attack = @attack + attack_increase
		@effective_attack = @effective_attack + attack_increase
		@defense = @defense + defense_increase
		@effective_defense = @effective_defense + defense_increase
		@max_health = @max_health + health_increase
		@current_health = @current_health + health_increase
		@level = @level + 1
		return_s = "\n" +  @user_id.mention() + " ascended to Level #{@level}!"
	end

	def examine(object)
		if nil != @current_enemy and object == @current_enemy.name
			return @current_enemy.description
		elsif nil != @inventory[object.to_i - 1] 
			return @inventory[object.to_i - 1].description
		end
	end
end