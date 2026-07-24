/obj/item/device/cotablet
	icon = 'icons/obj/items/devices.dmi'
	name = "command tablet"
	desc = "A portable command interface used by top brass, capable of issuing commands over long ranges to their linked computer. Built to withstand a nuclear bomb."
	suffix = "\[3\]"
	icon_state = "Cotablet"
	item_state = "Cotablet"
	unacidable = TRUE
	indestructible = TRUE
	req_access = list(ACCESS_MARINE_SENIOR)
	var/on = TRUE // 0 for off
	var/cooldown_between_messages = COOLDOWN_COMM_MESSAGE

	var/tablet_name = "Commanding Officer's Tablet"

	var/announcement_title = COMMAND_ANNOUNCE
	var/announcement_faction = FACTION_MARINE
	var/add_pmcs = TRUE

	var/datum/tacmap/tacmap
	var/minimap_type = MINIMAP_FLAG_USCM

	// Games system
	var/games_enabled = TRUE
	var/game_screen = 0
	var/current_game = null
	var/game_data = null

	COOLDOWN_DECLARE(announcement_cooldown)
	COOLDOWN_DECLARE(distress_cooldown)

/obj/item/device/cotablet/Initialize()
	tacmap = new /datum/tacmap/drawing(src, minimap_type)
	if(SSticker.mode && MODE_HAS_FLAG(MODE_FACTION_CLASH))
		add_pmcs = FALSE
	else if(SSticker.current_state < GAME_STATE_PLAYING)
		RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, PROC_REF(disable_pmc))
	return ..()

/obj/item/device/cotablet/Destroy()
	QDEL_NULL(tacmap)
	return ..()

/obj/item/device/cotablet/proc/disable_pmc()
	if(MODE_HAS_FLAG(MODE_FACTION_CLASH))
		add_pmcs = FALSE
	UnregisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP)

/obj/item/device/cotablet/attack_self(mob/living/carbon/human/user as mob)
	..()

	var/obj/item/card/id/card = user.get_idcard()
	if(allowed(user) && card?.check_biometrics(user))
		tgui_interact(user)
	else
		to_chat(user, SPAN_DANGER("Access denied."))

/obj/item/device/cotablet/ui_static_data(mob/user)
	var/list/data = list()

	data["faction"] = announcement_faction
	data["cooldown_message"] = cooldown_between_messages
	data["distresstimelock"] = DISTRESS_TIME_LOCK

	return data

/obj/item/device/cotablet/ui_data(mob/user)
	var/list/data = list()

	data["alert_level"] = GLOB.security_level
	data["evac_status"] = SShijack.evac_status
	data["endtime"] = announcement_cooldown
	data["distresstime"] = distress_cooldown
	data["worldtime"] = world.time

	return data

/obj/item/device/cotablet/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(!allowed(user))
		return UI_UPDATE
	if(!on)
		return UI_DISABLED

/obj/item/device/cotablet/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/device/cotablet/tgui_interact(mob/user, datum/tgui/ui, datum/ui_state/state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CommandTablet", "Command Tablet")
		ui.open()

/obj/item/device/cotablet/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui.user
	switch(action)
		if("announce")
			if(user.client.prefs.muted & MUTE_IC)
				to_chat(user, SPAN_DANGER("You cannot send Announcements (muted)."))
				return

			if(!COOLDOWN_FINISHED(src, announcement_cooldown))
				to_chat(user, SPAN_WARNING("Please wait [COOLDOWN_TIMELEFT(src, announcement_cooldown)/10] second\s before making your next announcement."))
				return FALSE

			var/input = stripped_multiline_input(user, "Please write a message to announce to the [MAIN_SHIP_NAME]'s crew and all groundside personnel.", "Priority Announcement", "")
			if(!input || !COOLDOWN_FINISHED(src, announcement_cooldown) || !(user in dview(1, src)))
				return FALSE

			var/signed = null
			if(ishuman(user))
				var/mob/living/carbon/human/human_user = user
				var/obj/item/card/id/id = human_user.get_idcard()
				if(id)
					var/paygrade = get_paygrades(id.paygrade, FALSE, human_user.gender)
					signed = "[paygrade] [id.registered_name]"

			marine_announcement(input, announcement_title, faction_to_display = announcement_faction, add_PMCs = add_pmcs, signature = signed)
			message_admins("[key_name(user)] has made a command announcement.")
			log_announcement("[key_name(user)] has announced the following: [input]")
			COOLDOWN_START(src, announcement_cooldown, cooldown_between_messages)
			. = TRUE

		if("award")
			if(announcement_faction != FACTION_MARINE)
				return
			open_medal_panel(user, src)
			. = TRUE

		if("mapview")
			tacmap.tgui_interact(user)
			. = TRUE

		if("evacuation_start")
			if(announcement_faction != FACTION_MARINE)
				return

			if(GLOB.security_level < SEC_LEVEL_RED)
				to_chat(user, SPAN_WARNING("The ship must be under red alert in order to enact evacuation procedures."))
				return FALSE

			if(SShijack.evac_admin_denied)
				to_chat(user, SPAN_WARNING("The USCM has placed a lock on deploying the evacuation pods."))
				return FALSE

			if(!SShijack.initiate_evacuation())
				to_chat(user, SPAN_WARNING("You are unable to initiate an evacuation procedure right now!"))
				return FALSE

			log_game("[key_name(user)] has called for an emergency evacuation.")
			message_admins("[key_name_admin(user)] has called for an emergency evacuation.")
			log_ares_security("Initiate Evacuation", "Called for an emergency evacuation.", user)
			. = TRUE

		if("distress")
			if(!SSticker.mode)
				return FALSE //Not a game mode?

			if(GLOB.security_level == SEC_LEVEL_DELTA)
				to_chat(user, SPAN_WARNING("The ship is already undergoing self destruct procedures!"))
				return FALSE

			for(var/client/C in GLOB.admins)
				if((R_ADMIN|R_MOD) & C.admin_holder.rights)
					playsound_client(C,'sound/effects/sos-morse-code.ogg',10)
			SSticker.mode.request_ert(user)
			to_chat(user, SPAN_NOTICE("A distress beacon request has been sent to USCM Central Command."))
			COOLDOWN_START(src, distress_cooldown, COOLDOWN_COMM_REQUEST)
			return TRUE

		if("games")
			interact_games(user)
			return TRUE

/obj/item/device/cotablet/pmc
	desc = "A special device used by corporate PMC directors."

	tablet_name = "Site Director's Tablet"

	announcement_title = PMC_COMMAND_ANNOUNCE
	announcement_faction = FACTION_PMC

	minimap_type = MINIMAP_FLAG_PMC

/obj/item/device/cotablet/upp

	desc = "A special device used by field UPP commanders."

	tablet_name = "UPP Field Commander's Tablet"

	announcement_title = UPP_COMMAND_ANNOUNCE
	announcement_faction = FACTION_UPP
	req_access = list(ACCESS_UPP_LEADERSHIP)

	minimap_type = MINIMAP_FLAG_UPP

/obj/item/device/cotablet/rmc

	desc = "A special device used by field RMC commanders."

	tablet_name = "RMC Field Commander's Tablet"

	announcement_title = TWE_COMMAND_ANNOUNCE
	announcement_faction = FACTION_TWE
	req_access = list(ACCESS_TWE_LEADERSHIP)
	minimap_type = MINIMAP_FLAG_TWE


// ==================== GAMES SYSTEM FOR COMMAND TABLET ====================

/obj/item/device/cotablet/proc/interact_games(mob/user)
	var/dat = "<HEAD><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += "<A href='byond://?src=\ref[src];mach_close=tablet_games'>Close</A><br><br>"

	switch(game_screen)
		if(0) // Main menu
			dat += "<center><h3>[src.tablet_name]</h3></center><HR>"
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

	show_browser(user, dat, "Tablet Games", "tablet_games", width = 600, height = 520)

/obj/item/device/cotablet/Topic(href, href_list)
	if(href_list["mach_close"])
		close_browser(usr, href_list["mach_close"])
		return

	if(games_enabled)
		handle_games_topic(href_list)

/obj/item/device/cotablet/proc/handle_games_topic(href_list)
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

	interact_games(usr)


// ==================== SNAKE GAME ====================

/obj/item/device/cotablet/proc/initialize_snake()
	game_data = list(
		"snake" = list(list(5, 5), list(4, 5), list(3, 5)),
		"direction" = "right",
		"food" = list(10, 10),
		"score" = 0,
		"game_over" = FALSE,
		"grid_size" = 20
	)

/obj/item/device/cotablet/proc/render_snake_game()
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

/obj/item/device/cotablet/proc/handle_snake_input(href_list)
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

/obj/item/device/cotablet/proc/move_snake()
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

/obj/item/device/cotablet/proc/initialize_minesweeper()
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

/obj/item/device/cotablet/proc/render_minesweeper_game()
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

/obj/item/device/cotablet/proc/handle_minesweeper_input(href_list)
	if(href_list["ms_restart"])
		initialize_minesweeper()
		return

	if(href_list["ms_reveal"])
		var/coords = href_list["ms_reveal"]
		var/list/parts = splittext(coords, ",")
		var/x = text2num(parts[1])
		var/y = text2num(parts[2])

		reveal_minesweeper_cell(x, y)

/obj/item/device/cotablet/proc/reveal_minesweeper_cell(x, y)
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

/obj/item/device/cotablet/proc/check_minesweeper_win()
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

