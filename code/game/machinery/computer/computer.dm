/obj/structure/machinery/computer
	name = "computer"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	density = FALSE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	layer = BELOW_OBJ_LAYER
	idle_power_usage = 300
	active_power_usage = 300
	projectile_coverage = PROJECTILE_COVERAGE_LOW
	unslashable = TRUE
	var/circuit = null //The path to the circuit board type. If circuit==null, the computer can't be disassembled.
	var/processing = FALSE //Set to true if computer needs to do /process()
	var/deconstructible = TRUE
	var/exproof = 0
	var/games_enabled = TRUE // Enable built-in games (Snake, Minesweeper) on this computer
	var/game_screen = 0 // 0 = main, 1 = games menu, 2 = snake, 3 = minesweeper
	var/current_game = null // "snake" or "minesweeper" or null
	var/game_data = null // Store game state

/obj/structure/machinery/computer/Initialize()
	. = ..()
	if(processing)
		start_processing()
	power_change()

/obj/structure/machinery/computer/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

/obj/structure/machinery/computer/process()
	if(inoperable())
		return 0
	return 1

/obj/structure/machinery/computer/emp_act(severity)
	. = ..()
	if(prob(20/severity))
		set_broken()


/obj/structure/machinery/computer/ex_act(severity)
	if(exproof)
		return
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(25))
				verbs.Cut()
				set_broken()
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(25))
				qdel(src)
				return
			if (prob(50))
				verbs.Cut()
				set_broken()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
			return

/obj/structure/machinery/computer/bullet_act(obj/projectile/Proj)
	if(exproof)
		visible_message("[Proj] ricochets off [src]!")
		return 0
	else
		if(prob(floor(Proj.ammo.damage /2)))
			set_broken()
		..()
		return 1

/obj/structure/machinery/computer/update_icon()
	..()
	icon_state = initial(icon_state)
	// Broken
	if(stat & BROKEN)
		icon_state += "b"

	// Powered
	else if(stat & NOPOWER)
		icon_state = initial(icon_state)
		icon_state += "0"

/obj/structure/machinery/computer/proc/set_broken()
	stat |= BROKEN
	update_icon()

/obj/structure/machinery/computer/proc/decode(text)
	// Adds line breaks
	text = replacetext(text, "\n", "<BR>")
	return text


/obj/structure/machinery/computer/attackby(obj/item/I, mob/user)
	if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER) && circuit)
		if(!deconstructible)
			to_chat(user, SPAN_WARNING("You can't figure out how to deconstruct [src]..."))
			return
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("You don't know how to deconstruct [src]..."))
			return
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
		if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_BUILD))
			var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
			var/obj/item/circuitboard/computer/M = new circuit( A )
			A.circuit = M
			A.anchored = TRUE
			for (var/obj/C in src)
				C.forceMove(loc)
			if (src.stat & BROKEN)
				to_chat(user, SPAN_NOTICE("The broken glass falls out."))
				new /obj/item/shard( src.loc )
				A.state = 3
				A.icon_state = "3"
			else
				to_chat(user, SPAN_NOTICE("You disconnect the monitor."))
				A.state = 4
				A.icon_state = "4"
			M.disassemble(src)
			deconstruct()
	else
		if(isxeno(user))
			src.attack_alien(user)
			return
		src.attack_hand(user)
	return ..()

/obj/structure/machinery/computer/attack_hand()
	. = ..()
	if(!.) //not broken or unpowered
		if(ishuman(usr))
			playsound(src, "keyboard", 15, 1)

		// Show games menu if enabled and computer doesn't have custom interface
		if(games_enabled && !has_custom_interface())
			interact_games(usr)

/obj/structure/machinery/computer/fixer
	var/all_configs

/obj/structure/machinery/computer/fixer/New()
	all_configs = config
	..()

// ==================== GAMES SYSTEM ====================

/obj/structure/machinery/computer/proc/has_custom_interface()
	// Check if this computer type has a custom interface
	// Computers with custom interfaces should override this to return TRUE
	return FALSE

/obj/structure/machinery/computer/Topic(href, href_list)
	if(..())
		return

	// Handle game navigation
	if(games_enabled && !has_custom_interface())
		handle_games_topic(href_list)

/obj/structure/machinery/computer/proc/interact_games(mob/user)
	if(inoperable())
		return

	user.set_interaction(src)
	var/dat = "<HEAD><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += "<A href='byond://?src=\ref[user];mach_close=computer_games'>Close</A><br><br>"

	switch(game_screen)
		if(0) // Main menu
			dat += "<center><h3>[src.name]</h3></center><HR>"
			dat += "<A href='byond://?src=\ref[src];open_games=1'><font size=4>Games</font></A><HR>"
			dat += "<i>This computer has no specific functions configured.</i><BR>"
		if(1) // Games menu
			dat += "<font size=4>Games</font> | <A href='byond://?src=\ref[src];close_games=1'>Back</A><HR>"
			dat += "<A href='byond://?src=\ref[src];start_snake=1'><font size=3>Snake</font></A><HR>"
			dat += "<A href='byond://?src=\ref[src];start_minesweeper=1'><font size=3>Minesweeper</font></A><HR>"
			dat += "<A href='byond://?src=\ref[src];start_minidoom=1'><font size=3>Mini Doom</font></A><HR>"
		if(2) // Snake game
			dat += "<font size=4>Snake</font> | <A href='byond://?src=\ref[src];close_game=1'>Back</A><HR>"
			dat += render_snake_game()
		if(3) // Minesweeper game
			dat += "<font size=4>Minesweeper</font> | <A href='byond://?src=\ref[src];close_game=1'>Back</A><HR>"
			dat += render_minesweeper_game()
		if(4) // Mini Doom game
			dat += "<font size=4>Mini Doom</font> | <A href='byond://?src=\ref[src];close_game=1'>Back</A><HR>"
			dat += render_minidoom()

	show_browser(user, dat, "Computer Games", "computer_games", width = 600, height = 520)

/obj/structure/machinery/computer/proc/handle_games_topic(href_list)
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

	else if(href_list["start_minidoom"])
		game_screen = 4
		current_game = "minidoom"
		initialize_minidoom()

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

	// Mini Doom controls
	else if(current_game == "minidoom")
		handle_minidoom_input(href_list)

	add_fingerprint(usr)
	interact_games(usr)


// ==================== SNAKE GAME ====================

/obj/structure/machinery/computer/proc/initialize_snake()
	game_data = list(
		"snake" = list(list(5, 5), list(4, 5), list(3, 5)), // Snake body segments [x, y] - start with 3 segments
		"direction" = "right", // Current direction
		"food" = list(10, 10), // Food position [x, y]
		"score" = 0,
		"game_over" = FALSE,
		"grid_size" = 20 // 20x20 grid
	)

/obj/structure/machinery/computer/proc/render_snake_game()
	if(!game_data)
		initialize_snake()

	// Auto-move snake on each render
	if(!game_data["game_over"])
		move_snake()

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

	// Render grid
	dat += "<table border='1' cellpadding='0' cellspacing='0'>"
	for(var/y = 1 to grid_size)
		dat += "<tr>"
		for(var/x = 1 to grid_size)
			var/cell_content = "&nbsp;"
			var/bgcolor = "#000000"

			// Check if snake segment
			for(var/list/segment in snake)
				if(segment[1] == x && segment[2] == y)
					cell_content = "■"
					bgcolor = "#00FF00"
					break

			// Check if food
			if(food[1] == x && food[2] == y)
				cell_content = "●"
				bgcolor = "#FF0000"

			dat += "<td width='20' height='20' bgcolor='[bgcolor]' align='center' style='color: white;'>[cell_content]</td>"
		dat += "</tr>"
	dat += "</table>"

	dat += "</center>"
	return dat

/obj/structure/machinery/computer/proc/handle_snake_input(href_list)
	if(href_list["snake_restart"])
		initialize_snake()
		return

	if(href_list["snake_dir"])
		var/new_dir = href_list["snake_dir"]
		var/current_dir = game_data["direction"]

		// Prevent 180 degree turns
		if((new_dir == "up" && current_dir != "down") || \
		   (new_dir == "down" && current_dir != "up") || \
		   (new_dir == "left" && current_dir != "right") || \
		   (new_dir == "right" && current_dir != "left"))
			game_data["direction"] = new_dir

/obj/structure/machinery/computer/proc/move_snake()
	if(game_data["game_over"])
		return

	var/list/snake = game_data["snake"]
	var/direction = game_data["direction"]
	var/list/food = game_data["food"]
	var/grid_size = game_data["grid_size"]

	// Get head position
	var/list/head = snake[1]
	var/new_x = head[1]
	var/new_y = head[2]

	// Calculate new head position based on direction
	switch(direction)
		if("up")
			new_y--
		if("down")
			new_y++
		if("left")
			new_x--
		if("right")
			new_x++

	// Check wall collision
	if(new_x < 1 || new_x > grid_size || new_y < 1 || new_y > grid_size)
		game_data["game_over"] = TRUE
		return

	// Check self collision
	for(var/list/segment in snake)
		if(segment[1] == new_x && segment[2] == new_y)
			game_data["game_over"] = TRUE
			return

	// Add new head
	snake.Insert(1, list(new_x, new_y))

	// Check if food eaten
	if(new_x == food[1] && new_y == food[2])
		game_data["score"] += 10
		// Generate new food
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
		// Remove tail if no food eaten
		snake.len--


// ==================== MINESWEEPER GAME ====================

/obj/structure/machinery/computer/proc/initialize_minesweeper()
	var/grid_size = 10
	var/mine_count = 15
	var/list/grid = list()

	// Initialize empty grid
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

	// Place mines randomly
	var/placed_mines = 0
	while(placed_mines < mine_count)
		var/x = rand(1, grid_size)
		var/y = rand(1, grid_size)
		if(!grid[y][x]["mine"])
			grid[y][x]["mine"] = TRUE
			placed_mines++

	// Calculate numbers
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

/obj/structure/machinery/computer/proc/render_minesweeper_game()
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

	// Render grid
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
						// Color code numbers
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

/obj/structure/machinery/computer/proc/handle_minesweeper_input(href_list)
	if(href_list["ms_restart"])
		initialize_minesweeper()
		return

	if(href_list["ms_reveal"])
		var/coords = href_list["ms_reveal"]
		var/list/parts = splittext(coords, ",")
		var/x = text2num(parts[1])
		var/y = text2num(parts[2])

		reveal_minesweeper_cell(x, y)

/obj/structure/machinery/computer/proc/reveal_minesweeper_cell(x, y)
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
		// Reveal all mines
		for(var/ty = 1 to grid_size)
			for(var/tx = 1 to grid_size)
				grid[ty][tx]["revealed"] = TRUE
		return

	if(cell["count"] == 0)
		// Auto-reveal adjacent cells (flood fill)
		for(var/dy = -1 to 1)
			for(var/dx = -1 to 1)
				if(dx == 0 && dy == 0)
					continue
				var/nx = x + dx
				var/ny = y + dy
				if(nx >= 1 && nx <= grid_size && ny >= 1 && ny <= grid_size)
					if(!grid[ny][nx]["revealed"] && !grid[ny][nx]["flagged"])
						reveal_minesweeper_cell(nx, ny)

	// Check win condition
	check_minesweeper_win()

/obj/structure/machinery/computer/proc/check_minesweeper_win()
	var/list/grid = game_data["grid"]
	var/grid_size = game_data["grid_size"]
	var/mine_count = game_data["mine_count"]

	var/revealed_count = 0
	for(var/y = 1 to grid_size)
		for(var/x = 1 to grid_size)
			if(grid[y][x]["revealed"] && !grid[y][x]["mine"])
				revealed_count++

	if(revealed_count == (grid_size * grid_size) - mine_count)
		game_data["game_over"] = TRUE
		game_data["won"] = TRUE

// Include Mini Doom game
#include "minidoom.dm"
