//-----USS Almayer Machinery file -----//
// Put any new machines in here before map is released and everything moved to their proper positions.

/obj/structure/machinery/prop/almayer
	name = "GENERIC USS ALMAYER PROP"
	desc = "THIS SHOULDN'T BE VISIBLE, AHELP 'ART-P01' IF SEEN IN ROUND WITH LOCATION"

/obj/structure/machinery/prop/almayer/hangar/dropship_part_fabricator

/obj/structure/machinery/prop/almayer/computer/PC
	name = "personal desktop"
	desc = "A small computer hooked up into the ship's computer network."
	icon_state = "terminal1"
	var/games_enabled = TRUE
	var/game_screen = 0
	var/current_game = null
	var/game_data = null

/obj/structure/machinery/prop/almayer/computer/PC/attack_hand(mob/user)
	if(..())
		return

	if(ishuman(usr))
		playsound(src, "keyboard", 15, 1)

	if(games_enabled)
		interact_games(user)

/obj/structure/machinery/prop/almayer/computer/PC/Topic(href, href_list)
	if(..())
		return

	if(games_enabled)
		handle_games_topic(href_list)

// ==================== GAMES SYSTEM FOR PROP PC ====================

/obj/structure/machinery/prop/almayer/computer/PC/proc/interact_games(mob/user)
	user.set_interaction(src)
	var/dat = "<HEAD><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += "<A href='byond://?src=\ref[user];mach_close=computer_games'>Close</A><br><br>"

	switch(game_screen)
		if(0) // Main menu
			dat += "<center><h3>[src.name]</h3></center><HR>"
			dat += "<A href='byond://?src=\ref[src];open_games=1'><font size=4>Games</font></A><HR>"
		if(1) // Games menu
			dat += "<font size=4>Games</font> | <A href='byond://?src=\ref[src];close_games=1'>Back</A><HR>"
			dat += "<A href='byond://?src=\ref[src];start_snake=1'><font size=3>Snake</font></A><HR>"
			dat += "<A href='byond://?src=\ref[src];start_minesweeper=1'><font size=3>Minesweeper</font></A><HR>"
		if(2) // Snake game
			dat += "<font size=4>Snake</font> | <A href='byond://?src=\ref[src];close_game=1'>Back</A><HR>"
			dat += render_snake_game()
		if(3) // Minesweeper game
			dat += "<font size=4>Minesweeper</font> | <A href='byond://?src=\ref[src];close_game=1'>Back</A><HR>"
			dat += render_minesweeper_game()

	show_browser(user, dat, "Computer Games", "computer_games", width = 600, height = 520)

/obj/structure/machinery/prop/almayer/computer/PC/proc/handle_games_topic(href_list)
	if(href_list["open_games"])
		game_screen = 1
		current_game = null

	else if(href_list["close_games"])
		game_screen = 0
		current_game = null

	else if(href_list["start_snake"])
		game_screen = 2
		current_game = "snake"
		initialize_snake()

	else if(href_list["start_minesweeper"])
		game_screen = 3
		current_game = "minesweeper"
		initialize_minesweeper()

	else if(href_list["close_game"])
		game_screen = 1
		current_game = null
		game_data = null

	// Snake controls
	else if(current_game == "snake")
		handle_snake_input(href_list)

	// Minesweeper controls
	else if(current_game == "minesweeper")
		handle_minesweeper_input(href_list)

	add_fingerprint(usr)
	interact_games(usr)


// ==================== SNAKE GAME ====================

/obj/structure/machinery/prop/almayer/computer/PC/proc/initialize_snake()
	game_data = list(
		"snake" = list(list(5, 5), list(4, 5), list(3, 5)),
		"direction" = "right",
		"food" = list(10, 10),
		"score" = 0,
		"game_over" = FALSE,
		"grid_size" = 20
	)

/obj/structure/machinery/prop/almayer/computer/PC/proc/render_snake_game()
	if(!game_data)
		initialize_snake()

	var/list/snake = game_data["snake"]
	var/list/food = game_data["food"]
	var/score = game_data["score"]
	var/game_over = game_data["game_over"]
	var/grid_size = game_data["grid_size"]

	var/dat = "<center>"
	dat += "<b>Score: [score]</b><BR><BR>"

	if(game_over)
		dat += "<font size=4 color='red'>GAME OVER</font><BR><BR>"
		dat += "<A href='byond://?src=\ref[src];snake_restart=1'>Play Again</A><BR><BR>"
	else
		dat += "Use Arrow Keys or Buttons to move:<BR><BR>"
		dat += "<A href='byond://?src=\ref[src];snake_dir=up'>▲</A> "
		dat += "<A href='byond://?src=\ref[src];snake_dir=left'>◄</A> "
		dat += "<A href='byond://?src=\ref[src];snake_dir=down'>▼</A> "
		dat += "<A href='byond://?src=\ref[src];snake_dir=right'>►</A><BR><BR>"

	dat += "<table border='1' cellpadding='0' cellspacing='0'>"
	for(var/y = 1 to grid_size)
		dat += "<tr>"
		for(var/x = 1 to grid_size)
			var/cell_content = "&nbsp;"
			var/bgcolor = "#000000"

			for(var/list/segment in snake)
				if(segment[1] == x && segment[2] == y)
					cell_content = "■"
					bgcolor = "#00FF00"
					break

			if(food[1] == x && food[2] == y)
				cell_content = "●"
				bgcolor = "#FF0000"

			dat += "<td width='20' height='20' bgcolor='[bgcolor]' align='center' style='color: white;'>[cell_content]</td>"
		dat += "</tr>"
	dat += "</table>"

	dat += "</center>"
	return dat

/obj/structure/machinery/prop/almayer/computer/PC/proc/handle_snake_input(href_list)
	if(href_list["snake_restart"])
		initialize_snake()
		return

	if(href_list["snake_dir"])
		var/new_dir = href_list["snake_dir"]
		var/current_dir = game_data["direction"]

		if((new_dir == "up" && current_dir != "down") || \
		   (new_dir == "down" && current_dir != "up") || \
		   (new_dir == "left" && current_dir != "right") || \
		   (new_dir == "right" && current_dir != "left"))
			game_data["direction"] = new_dir

	move_snake()

/obj/structure/machinery/prop/almayer/computer/PC/proc/move_snake()
	if(game_data["game_over"])
		return

	var/list/snake = game_data["snake"]
	var/direction = game_data["direction"]
	var/list/food = game_data["food"]
	var/grid_size = game_data["grid_size"]

	var/list/head = snake[1]
	var/new_x = head[1]
	var/new_y = head[2]

	switch(direction)
		if("up")
			new_y--
		if("down")
			new_y++
		if("left")
			new_x--
		if("right")
			new_x++

	if(new_x < 1 || new_x > grid_size || new_y < 1 || new_y > grid_size)
		game_data["game_over"] = TRUE
		return

	for(var/list/segment in snake)
		if(segment[1] == new_x && segment[2] == new_y)
			game_data["game_over"] = TRUE
			return

	snake.Insert(1, list(new_x, new_y))

	if(new_x == food[1] && new_y == food[2])
		game_data["score"] += 10
		var/valid_position = FALSE
		while(!valid_position)
			food[1] = rand(1, grid_size)
			food[2] = rand(1, grid_size)
			valid_position = TRUE
			for(var/list/segment in snake)
				if(segment[1] == food[1] && segment[2] == food[2])
					valid_position = FALSE
					break
	else
		snake.len--


// ==================== MINESWEEPER GAME ====================

/obj/structure/machinery/prop/almayer/computer/PC/proc/initialize_minesweeper()
	var/grid_size = 10
	var/mine_count = 15
	var/list/grid = list()

	for(var/y = 1 to grid_size)
		var/list/row = list()
		for(var/x = 1 to grid_size)
			var/list/cell_data = list()
			cell_data["revealed"] = FALSE
			cell_data["mine"] = FALSE
			cell_data["flagged"] = FALSE
			cell_data["count"] = 0
			row += list(cell_data)
		grid += list(row)

	var/placed_mines = 0
	while(placed_mines < mine_count)
		var/x = rand(1, grid_size)
		var/y = rand(1, grid_size)
		if(!grid[y][x]["mine"])
			grid[y][x]["mine"] = TRUE
			placed_mines++

	for(var/y = 1 to grid_size)
		for(var/x = 1 to grid_size)
			if(!grid[y][x]["mine"])
				var/count = 0
				for(var/dy = -1 to 1)
					for(var/dx = -1 to 1)
						if(dx == 0 && dy == 0)
							continue
						var/nx = x + dx
						var/ny = y + dy
						if(nx >= 1 && nx <= grid_size && ny >= 1 && ny <= grid_size)
							if(grid[ny][nx]["mine"])
								count++
				grid[y][x]["count"] = count

	game_data = list(
		"grid" = grid,
		"grid_size" = grid_size,
		"mine_count" = mine_count,
		"game_over" = FALSE,
		"won" = FALSE,
		"flags_left" = mine_count
	)

/obj/structure/machinery/prop/almayer/computer/PC/proc/render_minesweeper_game()
	if(!game_data)
		initialize_minesweeper()

	var/list/grid = game_data["grid"]
	var/grid_size = game_data["grid_size"]
	var/mine_count = game_data["mine_count"]
	var/game_over = game_data["game_over"]
	var/won = game_data["won"]
	var/flags_left = game_data["flags_left"]

	var/dat = "<center>"
	dat += "<b>Mines: [mine_count]</b> | <b>Flags: [flags_left]</b><BR><BR>"

	if(game_over)
		if(won)
			dat += "<font size=4 color='green'>YOU WIN!</font><BR><BR>"
		else
			dat += "<font size=4 color='red'>GAME OVER</font><BR><BR>"
		dat += "<A href='byond://?src=\ref[src];ms_restart=1'>Play Again</A><BR><BR>"
	else
		dat += "Click to reveal cells<BR><BR>"

	dat += "<table border='1' cellpadding='0' cellspacing='0'>"
	for(var/y = 1 to grid_size)
		dat += "<tr>"
		for(var/x = 1 to grid_size)
			var/cell = grid[y][x]
			var/cell_content = "&nbsp;"
			var/bgcolor = "#CCCCCC"
			var/color = "black"

			if(cell["revealed"])
				if(cell["mine"])
					cell_content = "💣"
					bgcolor = "#FF0000"
				else
					bgcolor = "#FFFFFF"
					if(cell["count"] > 0)
						cell_content = cell["count"]
						switch(cell["count"])
							if(1)
								color = "blue"
							if(2)
								color = "green"
							if(3)
								color = "red"
							if(4)
								color = "darkblue"
							if(5)
								color = "brown"
							if(6)
								color = "cyan"
							if(7)
								color = "black"
							if(8)
								color = "gray"
			else if(cell["flagged"])
				cell_content = "🚩"
				bgcolor = "#FFFF00"

			if(!cell["revealed"] && !cell["flagged"] && !game_over)
				dat += "<td width='25' height='25' bgcolor='[bgcolor]' align='center'><A href='byond://?src=\ref[src];ms_reveal=[x],[y]'>[cell_content]</A></td>"
			else
				dat += "<td width='25' height='25' bgcolor='[bgcolor]' align='center' style='color: [color];'>[cell_content]</td>"
		dat += "</tr>"
	dat += "</table>"

	dat += "</center>"
	return dat

/obj/structure/machinery/prop/almayer/computer/PC/proc/handle_minesweeper_input(href_list)
	if(href_list["ms_restart"])
		initialize_minesweeper()
		return

	if(href_list["ms_reveal"])
		var/coords = href_list["ms_reveal"]
		var/list/parts = splittext(coords, ",")
		var/x = text2num(parts[1])
		var/y = text2num(parts[2])

		reveal_minesweeper_cell(x, y)

/obj/structure/machinery/prop/almayer/computer/PC/proc/reveal_minesweeper_cell(x, y)
	if(game_data["game_over"])
		return

	var/list/grid = game_data["grid"]
	var/grid_size = game_data["grid_size"]

	if(x < 1 || x > grid_size || y < 1 || y > grid_size)
		return

	var/cell = grid[y][x]
	if(cell["revealed"] || cell["flagged"])
		return

	cell["revealed"] = TRUE

	if(cell["mine"])
		game_data["game_over"] = TRUE
		game_data["won"] = FALSE
		for(var/ty = 1 to grid_size)
			for(var/tx = 1 to grid_size)
				grid[ty][tx]["revealed"] = TRUE
		return

	if(cell["count"] == 0)
		for(var/dy = -1 to 1)
			for(var/dx = -1 to 1)
				if(dx == 0 && dy == 0)
					continue
				var/nx = x + dx
				var/ny = y + dy
				if(nx >= 1 && nx <= grid_size && ny >= 1 && ny <= grid_size)
					if(!grid[ny][nx]["revealed"] && !grid[ny][nx]["flagged"])
						reveal_minesweeper_cell(nx, ny)

	check_minesweeper_win()

/obj/structure/machinery/prop/almayer/computer/PC/proc/check_minesweeper_win()
	var/logrid = game_data["grid"]
	var/grid_size = game_data["grid_size"]
	var/mine_count = game_data["mine_count"]

	var/revealed_count = 0
	for(var/y = 1 to grid_size)
		for(var/x = 1 to grid_size)
			if(logrid[y][x]["revealed"] && !logrid[y][x]["mine"])
				revealed_count++

	if(revealed_count == (grid_size * grid_size) - mine_count)
		game_data["game_over"] = TRUE
		game_data["won"] = TRUE


/obj/structure/machinery/prop/almayer/computer/PC/large
	icon_state = "largecomp"

/obj/structure/machinery/prop/almayer/computer/PC/large/dark
	icon_state = "largecomp_dark"

/obj/structure/machinery/prop/almayer/computer
	name = "systems computer"
	desc = "A small computer hooked up into the ship's systems."

	density = FALSE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 20

	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "terminal"

/obj/structure/machinery/prop/almayer/computer/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(25))
				set_broken()
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(25))
				deconstruct(FALSE)
				return
			if (prob(50))
				set_broken()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
			return
		else
			return

/obj/structure/machinery/prop/almayer/computer/proc/set_broken()
	stat |= BROKEN
	update_icon()

/obj/structure/machinery/prop/almayer/computer/update_icon()
	..()
	icon_state = initial(icon_state)
	if(stat & BROKEN)
		icon_state += "b"
	if(stat & NOPOWER)
		icon_state = initial(icon_state)
		icon_state += "0"

/obj/structure/machinery/prop/almayer/computer/NavCon
	name = "NavCon"
	desc = "Navigational console for plotting course and heading of the ship. Since the AI calculates all long-range navigation, this is only used for in-system course corrections and orbital maneuvers. Don't touch it!"

	icon_state = "retro"

/obj/structure/machinery/prop/almayer/computer/NavCon2
	name = "NavCon 2"
	desc = "Navigational console for plotting course and heading of the ship. Since the AI calculates all long-range navigation, this is only used for in-system course corrections and orbital maneuvers. Don't touch it!"

	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "retro2"

/obj/structure/machinery/prop/almayer/CICmap
	name = "map table"
	desc = "A table that displays a map of the current operation location."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "maptable"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	density = TRUE
	idle_power_usage = 2
	var/datum/tacmap/map
	///flags that we want to be shown when you interact with this table
	var/minimap_type = MINIMAP_FLAG_USCM
	///The faction that is intended to use this structure (determines type of tacmap used)
	var/faction = FACTION_MARINE

/obj/structure/machinery/prop/almayer/CICmap/Initialize()
	. = ..()

	map = new /datum/tacmap/drawing(src, minimap_type)


/obj/structure/machinery/prop/almayer/CICmap/Destroy()
	QDEL_NULL(map)
	return ..()

/obj/structure/machinery/prop/almayer/CICmap/attack_hand(mob/user)
	. = ..()

	map.tgui_interact(user)

/obj/structure/machinery/prop/almayer/CICmap/computer
	name = "map terminal"
	desc = "A terminal that displays a map of the current operation location."
	icon = 'icons/obj/vehicles/interiors/arc.dmi'
	icon_state = "cicmap_computer"
	density = FALSE

/obj/structure/machinery/prop/almayer/CICmap/upp
	minimap_type = MINIMAP_FLAG_UPP
	faction = FACTION_UPP

/obj/structure/machinery/prop/almayer/CICmap/clf
	minimap_type = MINIMAP_FLAG_CLF
	faction = FACTION_CLF

/obj/structure/machinery/prop/almayer/CICmap/pmc
	minimap_type = MINIMAP_FLAG_PMC
	faction = FACTION_PMC

/obj/structure/machinery/prop/almayer/CICmap/rmc
	minimap_type = MINIMAP_FLAG_TWE
	faction = FACTION_TWE

/obj/structure/machinery/prop/almayer/CICmap/toc
	name = "tactical map screen"
	desc = "A screen on the TOC computer displaying the tactical map."
	icon_state =  "toc_map"

/obj/structure/machinery/prop/almayer/CICmap/table
	name = "map table"
	desc = "A large flat map table used for planning operations. It's large enough it can even be used as a proper table."
	icon = 'icons/obj/structures/props/almayer_props96.dmi'
	icon_state = "maptable"
	layer = TABLE_LAYER
	light_system = STATIC_LIGHT
	light_color = "#DAE2FF"
	light_power = 1
	light_range = 2.5
	light_pixel_x = 16
	light_pixel_y = 32
	bound_width = 64
	bound_height = 96

/obj/structure/machinery/prop/almayer/CICmap/table/attackby(obj/item/attacking_item, mob/user, click_data)
	if(!user.drop_inv_item_to_loc(attacking_item, loc))
		return

	auto_align(attacking_item, click_data)
	user.next_move = world.time + 2
	return TRUE

/obj/structure/machinery/prop/almayer/CICmap/table/proc/auto_align(obj/item/new_item, click_data)
	if(!new_item.center_of_mass) // Clothing, material stacks, generally items with large sprites where exact placement would be unhandy.
		new_item.pixel_x = rand(-new_item.randpixel, new_item.randpixel)
		new_item.pixel_y = rand(-new_item.randpixel, new_item.randpixel)
		new_item.pixel_z = 0
		return

	if(!click_data)
		return

	if(!click_data[ICON_X] || !click_data[ICON_Y])
		return

	// Calculation to apply new pixelshift.
	var/mouse_x = text2num(click_data[ICON_X])-1 // Ranging from 0 to 31
	var/mouse_y = text2num(click_data[ICON_Y])-1

	var/cell_x = clamp(floor(mouse_x/CELLSIZE), 0, CELLS-1) // Ranging from 0 to CELLS-1
	var/cell_y = clamp(floor(mouse_y/CELLSIZE), 0, CELLS-1)

	var/list/center = cached_key_number_decode(new_item.center_of_mass)

	new_item.pixel_x = (CELLSIZE * (cell_x + 0.5)) - center["x"]
	new_item.pixel_y = (CELLSIZE * (cell_y + 0.5)) - center["y"]
	new_item.pixel_z = 0

/obj/structure/machinery/prop/almayer/CICmap/table/update_icon()
	..()

	overlays.Cut()

	if(!(stat & NOPOWER))
		var/image/source_image = image(src.icon, icon_state = "[icon_state]_e")
		overlays += emissive_appearance(source_image.icon, source_image.icon_state)
		overlays += mutable_appearance(source_image.icon, source_image.icon_state)
		light_power = 1
	else return

/obj/structure/machinery/prop/almayer/CICmap/table/segment
	icon = 'icons/obj/structures/props/maptable.dmi'
	icon_state = "v_maptable1"
	bound_width = 32
	bound_height = 32
	light_pixel_x = 0
	light_pixel_y = 0

/obj/structure/machinery/prop/almayer/CICmap/table/segment/one
	icon_state = "v_maptable1"

/obj/structure/machinery/prop/almayer/CICmap/table/segment/two
	icon_state = "v_maptable2"

/obj/structure/machinery/prop/almayer/CICmap/table/segment/three
	icon_state = "v_maptable3"

/obj/structure/machinery/prop/almayer/CICmap/table/segment/four
	icon_state = "v_maptable4"

/obj/structure/machinery/prop/almayer/CICmap/table/segment/five
	icon_state = "v_maptable5"

/obj/structure/machinery/prop/almayer/CICmap/table/segment/six
	icon_state = "v_maptable6"

/obj/structure/machinery/prop/almayer/CICmap/table/horizontal
	icon_state = "h_maptable"
	bound_width = 96
	bound_height = 64
	light_pixel_x = 32
	light_pixel_y = 16

/obj/structure/machinery/prop/almayer/CICmap/table/horizontal/segment
	icon = 'icons/obj/structures/props/maptable.dmi'
	icon_state = "h_maptable1"
	bound_width = 32
	bound_height = 32
	light_pixel_x = 0
	light_pixel_y = 0

/obj/structure/machinery/prop/almayer/CICmap/table/horizontal/segment/one
	icon_state = "h_maptable1"

/obj/structure/machinery/prop/almayer/CICmap/table/horizontal/segment/two
	icon_state = "h_maptable2"

/obj/structure/machinery/prop/almayer/CICmap/table/horizontal/segment/three
	icon_state = "h_maptable3"

/obj/structure/machinery/prop/almayer/CICmap/table/horizontal/segment/four
	icon_state = "h_maptable4"

/obj/structure/machinery/prop/almayer/CICmap/table/horizontal/segment/five
	icon_state = "h_maptable5"

/obj/structure/machinery/prop/almayer/CICmap/table/horizontal/segment/six
	icon_state = "h_maptable6"

//Nonpower using props

/obj/structure/prop/almayer
	name = "GENERIC USS ALMAYER PROP"
	desc = "THIS SHOULDN'T BE VISIBLE, AHELP 'ART-P02' IF SEEN IN ROUND WITH LOCATION"
	density = TRUE
	anchored = TRUE
	unslashable = TRUE

/obj/structure/prop/almayer/minigun_crate
	name = "30mm ammo crate"
	desc = "A crate full of 30mm bullets used on one of the weapon pod types for the dropship. Moving this will require some sort of lifter."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "30mm_crate"

/obj/structure/prop/almayer/sadar_decoration
	name = "\improper Spent M83A2 SADAR"
	desc = "A spent M83A2 tube. It's been kept as a trophy after a lucky tank kill nearly a thousand meters out. Someone has engraved a single tally-mark on the side to begin recording a kill-count."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sadar_decoration"
	density = FALSE

/obj/structure/prop/almayer/computers
	var/hacked = FALSE

/obj/structure/prop/almayer/computers/update_icon()
	. = ..()

	overlays.Cut()

	if(hacked)
		overlays += "+hacked"

/obj/structure/prop/almayer/computers/mission_planning_system
	name = "\improper MPS IV computer"
	desc = "The Mission Planning System IV (MPS IV), an enhancement in mission planning and charting for dropship pilots across the USCM. Fully capable of customizing their flight paths and loadouts to suit their combat needs."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "mps"

/obj/structure/prop/almayer/computers/mapping_computer
	name = "\improper CMPS II computer"
	desc = "The Common Mapping Production System version II allows for sensory input from satellites and ship systems to derive planetary maps in a standardized fashion for all USCM pilots."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "mapping_comp"

/obj/structure/prop/almayer/computers/sensor_computer1
	name = "sensor computer"
	desc = "The IBM series 10 computer retrofitted to work as a sensor computer for the ship. While somewhat dated it still serves its purpose."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sensor_comp1"

/obj/structure/prop/almayer/computers/sensor_computer2
	name = "sensor computer"
	desc = "The IBM series 10 computer retrofitted to work as a sensor computer for the ship. While somewhat dated it still serves its purpose."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sensor_comp2"

/obj/structure/prop/almayer/computers/sensor_computer3
	name = "sensor computer"
	desc = "The IBM series 10 computer retrofitted to work as a sensor computer for the ship. While somewhat dated it still serves its purpose."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sensor_comp3"

/obj/structure/prop/almayer/missile_tube
	name = "\improper Mk 33 ASAT launcher system"
	desc = "Cold launch tubes that can fire a few varieties of missiles out of them, the most common being the ASAT-21 Rapier IV missile used against satellites and other spacecraft and the BGM-227 Sledgehammer missile which is used for ground attack."
	icon = 'icons/obj/structures/props/almayer_props96.dmi'
	icon_state = "missiletubenorth"
	bound_width = 32
	bound_height = 96
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/whiteboard
	name = "\improper whiteboard"
	desc = "A blank white surface where thoughts turn to plans. It's blank, all of the markers having dried out from the constant inappropriate drawings."
	icon = 'icons/obj/structures/props/almayer_props64.dmi'
	icon_state = "whiteboard"
	bound_width = 64

/obj/structure/prop/almayer/whiteboard/clear
	name = "\improper glass whiteboard"
	desc = "Despite what the name implies, this whiteboard is not actually white and instead is a clear pane of glass. Why anyone would want you to see through a whiteboard remains one of the top mysteries as of 2182."
	icon_state = "whiteboard_clear"

/obj/structure/prop/almayer/ship_memorial
	name = "slab of victory"
	desc = "A ship memorial dedicated to the triumphs of the USCM and the fallen marines of this ship. On the left there are grand tales of victory etched into the slab. On the right there is a list of famous marines who have fallen in combat serving the USCM."
	icon = 'icons/obj/structures/props/almayer_props64.dmi'
	icon_state = "ship_memorial"
	bound_width = 64
	bound_height = 32
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/ship_memorial/golden_arrow
	name = "memorial"
	desc = "A memorial plaque dedicated to those of the Golden Arrow who have fallen in combat. It's an unfortunately long list of names."
	icon_state = "garrow_memorial"

/obj/structure/prop/almayer/ship_memorial/centcomm
	name = "slab of remembrance"
	desc = "A memorial to all Maintainer Team members that have retired from working on CM. No mentor names are present."

/obj/structure/prop/almayer/ship_memorial/centcomm/admin
	desc = "A memorial to all Admins and Moderators who have retired from CM. No mentor names are present."


/obj/structure/prop/almayer/ship_memorial/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/dogtag))
		var/obj/item/dogtag/D = I
		if(D.fallen_names)
			to_chat(user, SPAN_NOTICE("You add [D] to [src]."))
			GLOB.fallen_list += D.fallen_names
			qdel(D)
		return TRUE
	else
		. = ..()

/obj/structure/prop/almayer/ship_memorial/get_examine_text(mob/user)
	. = ..()
	if((isobserver(user) || ishuman(user)) && GLOB.fallen_list)
		var/faltext = ""
		for(var/i = 1 to length(GLOB.fallen_list))
			if(i != length(GLOB.fallen_list))
				faltext += "[GLOB.fallen_list[i]], "
			else
				faltext += GLOB.fallen_list[i]
		. += SPAN_NOTICE("To our fallen soldiers: <b>[faltext]</b>.")

/obj/structure/prop/almayer/particle_cannon
	name = "\improper 75cm/140 Mark 74 General Atomics railgun"
	desc = "The Mark 74 Railgun is top of the line for space-based weaponry. Capable of firing a round with a diameter of 3/4ths of a meter at 24 kilometers per second. It also is capable of using a variety of round types which can be interchanged at any time with its newly designed feed system."
	icon = 'icons/obj/structures/machinery/artillery.dmi'
	icon_state = "1"
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/particle_cannon/corsat
	name = "\improper CORSAT-PROTO-QUANTUM-CALCULATOR"
	desc = ""

/obj/structure/prop/almayer/name_stencil
	name = "USS Almayer"
	desc = "The name of the ship stenciled on the hull."
	icon = 'icons/obj/structures/props/almayer_props64.dmi'
	icon_state = "almayer0"
	density = FALSE //dunno who would walk on it, but you know.
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/hangar_stencil
	name = "floor"
	desc = "A large number stenciled on the hangar floor used to designate which dropship it is."
	icon = 'icons/obj/structures/props/almayer_props96.dmi'
	icon_state = "dropship1"
	density = FALSE
	layer = ABOVE_TURF_LAYER


/obj/structure/prop/almayer/cannon_cables
	name = "\improper Cannon cables"
	desc = "Some large cables."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "cannon_cables"
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = LADDER_LAYER
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/cannon_cables/ex_act()
	return

/obj/structure/prop/almayer/cannon_cables/bullet_act()
	return


/obj/structure/prop/almayer/cannon_cable_connector
	name = "\improper Cannon cable connector"
	desc = "A connector for the large cannon cables."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "cannon_cable_connector"
	density = TRUE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/cannon_cable_connector/ex_act()
	return

/obj/structure/prop/almayer/cannon_cable_connector/bullet_act()
	return

/obj/structure/prop/almayer/ai_wallmonitor
	name = "AI interface wall monitor"
	desc = "A monitor embedded into the wall, providing detailed readouts of various different systems."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "ai_wallmonitor"
	density = FALSE
	pixel_y = 32
	layer = ABOVE_OBJ_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/structure/prop/almayer/ai_wallmonitor/east
	icon_state = "ai_wallmonitor_e"
	pixel_x = 32
	pixel_y = 0

/obj/structure/prop/almayer/ai_wallmonitor/west
	icon_state = "ai_wallmonitor_w"
	pixel_x = -32
	pixel_y = 0




//------- Cryobag Recycler -------//
// Wanted to put this in, but since we still have extra time until tomorrow and this is really simple thing. It just recycles opened cryobags to make it nice-r for medics.
// Also the lack of sleep makes me keep typing cyro instead of cryo. FFS ~Art

/obj/structure/machinery/cryobag_recycler
	name = "cryogenic bag recycler"
	desc = "A small tomb like structure. Capable of taking in used and opened cryobags and refill the liner and attach new sealants."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "recycler"

	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 20

//What is this even doing? Why is it making a new item?
/obj/structure/machinery/cryobag_recycler/attackby(obj/item/W, mob/user) //Hope this works. Don't see why not.
	..()
	if (istype(W, /obj/item))
		if(W.name == "used stasis bag") //possiblity for abuse, but fairly low considering its near impossible to rename something without VV
			var/obj/item/bodybag/cryobag/R = new /obj/item/bodybag/cryobag //lets give them the bag considering having it unfolded would be a pain in the ass.
			R.add_fingerprint(user)
			user.temp_drop_inv_item(W)
			qdel(W)
			user.put_in_hands(R)
			return TRUE
	..()

/obj/structure/closet/basketball
	name = "athletic wardrobe"
	desc = "It's a storage unit for athletic wear."
	icon_state = "purple"
	icon_closed = "purple"
	icon_opened = "purple_open"

/obj/structure/closet/basketball/Initialize()
	. = ..()
	new /obj/item/clothing/under/shorts/grey(src)
	new /obj/item/clothing/under/shorts/black(src)
	new /obj/item/clothing/under/shorts/red(src)
	new /obj/item/clothing/under/shorts/blue(src)
	new /obj/item/clothing/under/shorts/green(src)

/obj/structure/machinery/prop/almayer/overwatch_console
	name = "Overwatch Console"
	desc = "State of the art machinery for giving orders to a squad."
	density = FALSE
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "overwatch"

/obj/structure/machinery/prop/almayer/orbital_cannon_console
	name = "\improper Orbital Cannon Console"
	desc = "The console controlling the orbital cannon loading systems."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "ob_console"
	dir = WEST
	flags_atom = ON_BORDER|CONDUCT|FPRINT

/obj/structure/machinery/prop/almayer/CICmap/arc
	name = "map terminal"
	desc = "A terminal that displays a map of the current operation location."
	icon = 'icons/obj/vehicles/interiors/arc.dmi'
	icon_state = "arcmap"
	density = FALSE

/obj/structure/machinery/computer/overwatch/almayer/arc
	icon = 'icons/obj/vehicles/interiors/arc.dmi'
	icon_state = "arcconsole"
