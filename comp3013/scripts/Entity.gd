class_name Entity

var name
var maxHp
var hp
var attack

func die():
	print(name + " has died");

func takeDamage(damage):
	hp -= damage
	if(hp <= 0):
		die()
