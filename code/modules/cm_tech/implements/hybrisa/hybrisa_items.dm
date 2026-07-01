// Compact Hybrisa item definitions using PVP-style sprites

/obj/item/clothing/under/hybrisa/cmb_officer
	name = "\improper Colonial Marshal uniform"
	desc = "A pair of grey slacks and a blue button-down shirt with a black tie; a non-standard uniform of the Colonial Marshals, specific to more urbanized colonies."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/CMB.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/CMB.dmi',
	)
	icon_state = "police_uniform"
	worn_state = "police_uniform"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW

/obj/item/clothing/under/hybrisa/wy_pilot
	name = "\improper Weyland-Yutani Pilot uniform"
	desc = "A pair of grey slacks and a white button-down shirt with a dark-grey tie and golden epaulettes signifying rank."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/WY.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/WY.dmi',
	)
	icon_state = "civilian_pilot_uniform"
	worn_state = "civilian_pilot_uniform"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW

/obj/item/clothing/under/hybrisa/paramedic
	name = "\improper EMT - Paramedic uniform"
	desc = "A set of EMT - Paramedic fatigues, this one is green."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/medical.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/medical.dmi',
	)
	icon_state = "paramedic_green_uniform"
	worn_state = "paramedic_green_uniform"

/obj/item/clothing/under/hybrisa/engineering_utility
	name = "\improper Weyland-Yutani engineering utility uniform"
	desc = "A set of Weyland-Yutani engineering utility workers uniform."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/engineering.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/engineering.dmi',
	)
	icon_state = "engineer_worker_uniform"
	worn_state = "engineer_worker_uniform"

/obj/item/clothing/under/hybrisa/weymart
	name = "\improper Weymart uniform"
	desc = "A pair of dark-grey slacks and an orange button-down shirt."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/WY.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/WY.dmi',
	)
	icon_state = "weymart_uniform"
	worn_state = "weymart_uniform"

/obj/item/clothing/head/beret/royal_marine
	name = "royal marine beret"
	desc = "A green beret belonging to the royal marines commando."
	icon_state = "rmc_beret"
	item_state = "rmc_beret"

/obj/item/card/id/nspa_gold
	name = "\improper NSPA gold badge"
	desc = "The solid gold badge which represents a high-ranking NSPA officer."
	icon_state = "nspa_gold"
	item_state = "silver_id"
	paygrade = "SGT"

/obj/item/gun/ballistic/revolver/cmb
	name = "\improper Spearhead Autorevolver"
	desc = "An automatic revolver chambered in .357."
	icon_state = "spearhead"
	item_state = "spearhead"
	force = 12

/obj/item/ammo_magazine/revolver/cmb/normalpoint
	name = "\improper Spearhead speed loader (.357)"
	desc = "This 6-round speed loader is fitted with standard .357 revolver bullets."
	default_ammo = /datum/ammo/bullet/revolver/small/cmb
	icon_state = "cmb"

/obj/item/ammo_magazine/internal/revolver/cmb
	default_ammo = /datum/ammo/bullet/revolver/small/cmb
	caliber = ".357"
	gun_type = /obj/item/gun/ballistic/revolver/cmb

/obj/item/ammo_magazine/revolver/cmb
	name = "\improper Spearhead speed loader (.357)"
	default_ammo = /datum/ammo/bullet/revolver/small/cmb
	icon_state = "cmb"

/datum/ammo/bullet/revolver/small/cmb
	damage = 60
