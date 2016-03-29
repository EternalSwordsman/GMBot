require_relative './lib/gmbot/PlayerCharacter'
require_relative './lib/gmbot/Item'
require_relative './lib/gmbot/Monster'
require_relative './lib/gmbot/Status'

player1 = PlayerCharacter.new("@George")

return_s = player1.choose_class("Tourist")
puts return_s

return_s = player1.attack()
puts return_s

return_s = player1.defeat()
puts return_s

item1 = Item.new("l_hand", '+1 Greatsword', 1, 0, 12, "Has runes on the blade that translate to 'point this end towards enemy'")

return_s = player1.put_item_in_inventory(item1)
puts return_s

return_s = player1.list_inventory()
puts return_s

return_s = player1.equip_item(1)
puts return_s

return_s = player1.list_inventory()
puts return_s

return_s = player1.unequip_item('l_hand')
puts return_s

return_s = player1.list_inventory()
puts return_s

return_s = player1.equip_item(1)
puts return_s

#monster1 = Monster.new('Dragon', '10', '1000000', nil, 50, 2, 10, 0, 0, 5)

return_s = player1.assign_enemy(Monster.new('Dragon', 1001, 1000000, nil, 50, 2, 10, 5, "Favorite activities: burninating peasants, countrysides"))
puts return_s

while nil != player1.current_enemy
	return_s = player1.attack()
	puts return_s
	if nil != player1.current_enemy
		return_s = player1.current_enemy.attack()
	else
		return_s = "No monster currently fighting #{player1.user_id}"
	end
	puts return_s
end

puts player1.list_status()

puts player1.list_character()