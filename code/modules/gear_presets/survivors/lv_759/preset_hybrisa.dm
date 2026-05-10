//////////////////// Hybrisa Survivor Gear Presets ////////////////////
// This file provides compile-safe survivor equipment presets for the
// Hybrisa PVE map. It avoids unsupported PVP-specific clothing and
// uses existing PVE item paths only.

/datum/equipment_preset/survivor/hybrisa/civilian
	name = "Survivor - Hybrisa - Civilian"
	assignment = "Civilian"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/civilian/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/grey(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
	add_survivor_weapon_pistol(new_human)
	..()

/datum/equipment_preset/survivor/hybrisa/civilian_office
	name = "Survivor - Hybrisa - Civilian - Office Worker"
	assignment = "Civilian - Office Worker"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/civilian_office/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beanie/royal_marine(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/white_service(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/black(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)
	add_survivor_weapon_pistol(new_human)
	..()

/datum/equipment_preset/survivor/hybrisa/weymart
	name = "Survivor - Hybrisa - Civilian - Weymart Employee"
	assignment = "Civilian - Weymart Employee"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/weymart/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/trucker/red(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/grey(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
	add_survivor_weapon_pistol(new_human)
	..()

/datum/equipment_preset/survivor/hybrisa/sanitation
	name = "Survivor - Hybrisa - Civilian - Material Reprocessing Technician"
	assignment = "Civilian - Material Reprocessing Technician"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/sanitation/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/grey(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/green(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/screwdriver(new_human), WEAR_IN_BACK)
	add_survivor_weapon_pistol(new_human)
	..()

/datum/equipment_preset/survivor/hybrisa/pizza_galaxy
	name = "Survivor - Hybrisa - Civilian - Pizza Galaxy Delivery Driver"
	assignment = "Civilian - Pizza Galaxy Delivery Driver"
	idtype = /obj/item/card/id/pizza
	skills = /datum/skills/civilian/survivor/trucker
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/pizza_galaxy/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/grey(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/pink(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/red(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
	add_survivor_weapon_pistol(new_human)
	..()

/datum/equipment_preset/survivor/hybrisa/fire_fighter
	name = "Survivor - Hybrisa - Civilian - Fire Fighter"
	assignment = "Civilian - Fire Fighter"
	skills = /datum/skills/civilian/survivor/engineer
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/fire_fighter/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/grey(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	add_survivor_weapon_pistol(new_human)
	..()

/datum/equipment_preset/survivor/hybrisa/kelland_miner
	name = "Survivor - Hybrisa - Civilian - Kelland Miner"
	assignment = "Civilian - Kelland Miner"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/kelland_miner/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/grey(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/green(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/grey(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/screwdriver(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	add_survivor_weapon_pistol(new_human)
	..()

/datum/equipment_preset/survivor/hybrisa/doctor
	name = "Survivor - Hybrisa - Civilian - Doctor"
	assignment = "Civilian - Doctor"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/doctor/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/grey(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
	add_survivor_weapon_pistol(new_human)
	..()

/datum/equipment_preset/survivor/hybrisa/paramedic
	name = "Survivor - Hybrisa - Civilian - Paramedic"
	assignment = "Civilian - Paramedic"
	skills = /datum/skills/civilian/survivor/doctor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/paramedic/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/grey(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/white_service(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/grey(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
	add_survivor_weapon_pistol(new_human)
	..()

/datum/equipment_preset/survivor/hybrisa/scientist_xenobiologist
	name = "Survivor - Hybrisa - Scientist - Xenobiologist"
	assignment = "Scientist - Xenobiologist"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/scientist_xenobiologist/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/grey(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)
	add_survivor_weapon_pistol(new_human)
	..()

/datum/equipment_preset/survivor/hybrisa/scientist_xenoarchaeologist
	name = "Survivor - Hybrisa - Scientist - Xenoarchaeologist"
	assignment = "Scientist - Xenoarchaeologist"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/scientist_xenoarchaeologist/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/grey(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)
	add_survivor_weapon_pistol(new_human)
	..()

/datum/equipment_preset/survivor/hybrisa/nspa_constable
	name = "Survivor - Hybrisa - NSPA Constable"
	assignment = "Civilian - NSPA Constable"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_LOGISTICS)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/nspa_constable/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/grey(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/blue(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/black(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
	add_survivor_weapon_pistol(new_human)
	..()

/datum/equipment_preset/survivor/hybrisa/electrical_engineer
	name = "Survivor - Hybrisa - Electrical Engineer"
	assignment = "Civilian - Electrical Engineer"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/electrical_engineer/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/grey(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/grey(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/screwdriver(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)
	add_survivor_weapon_pistol(new_human)
	..()

/datum/equipment_preset/survivor/hybrisa/construction_worker
	name = "Survivor - Hybrisa - Construction Worker"
	assignment = "Civilian - Construction Worker"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/construction_worker/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/grey(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
	add_survivor_weapon_pistol(new_human)
	..()

/datum/equipment_preset/survivor/hybrisa/heavy_vehicle_operator
	name = "Survivor - Hybrisa - Heavy Vehicle Operator"
	assignment = "Civilian - Heavy Vehicle Operator"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/heavy_vehicle_operator/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/grey(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/red(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
	add_survivor_weapon_pistol(new_human)
	..()

/datum/equipment_preset/survivor/corporate/hybrisa
	name = "Survivor - Hybrisa - Corporate"
	assignment = "Corporate"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/corporate/hybrisa/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beanie/royal_marine(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/white_service(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/black(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
	add_survivor_weapon_pistol(new_human)
	..()

/datum/equipment_preset/survivor/hybrisa/wey_po
	name = "Survivor - Hybrisa - Wey PO"
	assignment = "Civilian - Wey PO"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/wey_po/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/grey(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/black(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)
	add_survivor_weapon_pistol(new_human)
	..()

/datum/equipment_preset/survivor/hybrisa/corporate_goon
	name = "Survivor - Hybrisa - Corporate Goon"
	assignment = "Civilian - Corporate Goon"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/corporate_goon/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beanie/royal_marine(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/red(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
	add_survivor_weapon_pistol(new_human)
	..()
