class Monster

	attr_reader :name, :target_character, :experience, :gold, :loot, :description

	def initialize(name, 
				   exp, 
				   gold, 
				   loot, 
				   health, 
				   attack, 
				   defense, 
				   damage,
				   description)
		@name = name
		@experience = exp
		@gold = gold
		@loot = loot

		@max_health = health
		@current_health = @max_health

		@attack = attack
		@defense = defense
		@damage = damage
		@status = []
		@weaknesses = []
		@resistances = []

		@description = description
	end

	def attack
		attack_rating = @attack + rand(1..20)
		damage_rating = rand(1..@damage)
		status = nil
		damage = @target_character.defend(attack_rating, damage_rating, @attack_type, status)
		if damage.is_a?(Integer)
			return "#{@name} attacked " + @target_character.user_id.mention() + " and dealt #{damage} damage!"
		elsif damage.is_a?(String)
			return damage
		end
	end

	def defend(attack_value, 
			   damage_value, 
			   type, 
			   status)
		if attack_value > @defense
			damage = damage_value
			if 0 < damage 
				if @resistances.include?(type)
					damage = damage / 2
				end
				if @weaknesses.include?(type)
					damage = damage * 2
				end
				@current_health = @current_health - damage
				if @current_health <= 0
					return @target_character.victory(@name, @experience, @gold, @loot)
				elsif nil != status
					@status.push(status)
				end
			end
		else
			damage = @target_character.user_id.mention() + " missed the #{@name}"
		end
		return damage
	end

	def victory
	end

	def defeat

	end

	def do_status_effects
		@status.each do |x|
			x.do_status()
		end
	end

	def set_target(player_character)
		@target_character = player_character
	end
end