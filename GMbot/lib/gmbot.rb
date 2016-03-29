require 'discordrb'
require_relative './gmbot/PlayerCharacter'
require_relative './gmbot/Item'
require_relative './gmbot/Monster'
require_relative './gmbot/Status'

players = {}

bot = Discordrb::Commands::CommandBot.new("blazingseraph+gmbot@gmail.com", "calmcoolandelected", '!')

bot.command :class do |event, class_name|
	username = "#{event.user.discord_tag}"
	if nil == players[username]
		players[username] = PlayerCharacter.new(event.user)
	end
	players[username].choose_class(class_name)
end

bot.command :attack do |event|
	username = "#{event.user.discord_tag}"
	if nil == players[username]
		players[username] = PlayerCharacter.new(event.user)
	end
	players[username].attack()
end

bot.command :inventory do |event|
	username = "#{event.user.discord_tag}"
	if nil == players[username]
		players[username] = PlayerCharacter.new(event.user)
	end
	players[username].list_inventory()
end

bot.command :character do |event|
	username = "#{event.user.discord_tag}"
	if nil == players[username]
		players[username] = PlayerCharacter.new(event.user)
	end
	players[username].list_character()
end

bot.command :status do |event|
	username = "#{event.user.discord_tag}"
	if nil == players[username]
		players[username] = PlayerCharacter.new(event.user)
	end
	players[username].list_status()
end

bot.command :equip do |event, index|
	username = "#{event.user.discord_tag}"
	if nil == players[username]
		players[username] = PlayerCharacter.new(event.user)
	end
	players[username].equip_item(index.to_i())
end

bot.command :unequip do |event, slot|
	username = "#{event.user.discord_tag}"
	if nil == players[username]
		players[username] = PlayerCharacter.new(event.user)
	end
	players[username].unequip_item(slot)
end

bot.command :monster do |event, target_user|
	target_a = event.message.mentions
	return_s = ""
	target_a.each_index do |x|
		username = target_a[x].discord_tag
		if nil == players[username]
			#return_s = return_s + target_a[x].mention() + " has not created a character yet!\n"
			event << target_a[x].mention() + " has not created a character yet!"
		else
			#need monster generation code here
			#return_s = return_s + players[username].assign_enemy(Monster.new('Bunny', 1001, 10, nil, 3, 2, 1, 5, "Run away! Run away!")) + "\n"
			loot_a = []
			1.upto(players[username].level) do |x|
				loot_a.push(Item.new(players[username].level))
			end
			event << players[username].assign_enemy(Monster.new('Bunny', 1001, 10, loot_a, 3, 2, 1, 5, "Run away! Run away!"))
		end
	end
	return_s
end

bot.command :examine do |event, objectname|
	username = "#{event.user.discord_tag}"
	if nil == players[username]
		players[username] = PlayerCharacter.new(event.user)
	end
	players[username].examine(objectname)
end

bot.command :robotrollcall do |event|
	return_s = "GMbot"
end

bot.command :mention do |event|
	target_a = event.message.mentions
	return_s = ""
	target_a.each_index do |x|
		event << target_a[x].mention()
		#return_s << target_a[x].mention()
	end
	#{}"How are all of you doing?"
	return_s
end

bot.run #:async

#loop do
  # looped code goes here:
  #message = ExternalService.last_queued_message
  #bot.send_message(channel_id, message)
#end