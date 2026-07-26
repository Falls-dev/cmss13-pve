// ==================== MINI DOOM GAME ====================

/obj/structure/machinery/computer/proc/initialize_minidoom()
	game_data = list(
		"player_x" = 5,
		"player_y" = 5,
		"player_health" = 100,
		"player_ammo" = 30,
		"enemies" = list(),
		"bullets" = list(),
		"score" = 0,
		"game_over" = FALSE,
		"grid_size" = 20
	)

	// Spawn some enemies
	for(var/i = 1 to 5)
		spawn_enemy()

/obj/structure/machinery/computer/proc/spawn_enemy()
	var/grid_size = game_data["grid_size"]
	var/x = rand(1, grid_size)
	var/y = rand(1, grid_size)
	var/list/enemy = list("x" = x, "y" = y, "health" = 30)
	game_data["enemies"] += list(enemy)

/obj/structure/machinery/computer/proc/render_minidoom()
	if(!game_data)
		initialize_minidoom()

	var/player_x = game_data["player_x"]
	var/player_y = game_data["player_y"]
	var/player_health = game_data["player_health"]
	var/player_ammo = game_data["player_ammo"]
	var/list/enemies = game_data["enemies"]
	var/list/bullets = game_data["bullets"]
	var/score = game_data["score"]
	var/game_over = game_data["game_over"]
	var/grid_size = game_data["grid_size"]

	var/dat = "<center>"
	dat += "<b>Health: [player_health]</b> | <b>Ammo: [player_ammo]</b> | <b>Score: [score]</b><BR><BR>"

	if(game_over)
		dat += "<font size=4 color='red'>GAME OVER</font><BR><BR>"
		dat += "<A href='byond://?src=\ref[src];md_restart=1'>Play Again</A><BR><BR>"
	else
		dat += "Use WASD to move, Click grid to shoot<BR><BR>"
		dat += "<A href='byond://?src=\ref[src];md_move=w'>W</A> "
		dat += "<A href='byond://?src=\ref[src];md_move=a'>A</A> "
		dat += "<A href='byond://?src=\ref[src];md_move=s'>S</A> "
		dat += "<A href='byond://?src=\ref[src];md_move=d'>D</A><BR><BR>"

	// Render grid
	dat += "<table border='1' cellpadding='0' cellspacing='0'>"
	for(var/y = 1 to grid_size)
		dat += "<tr>"
		for(var/x = 1 to grid_size)
			var/cell_content = "&nbsp;"
			var/bgcolor = "#222222"

			// Check if player
			if(player_x == x && player_y == y)
				cell_content = "@"
				bgcolor = "#00FF00"

			// Check if enemy
			for(var/list/enemy in enemies)
				if(enemy["x"] == x && enemy["y"] == y)
					cell_content = "E"
					bgcolor = "#FF0000"
					break

			// Check if bullet
			for(var/list/bullet in bullets)
				if(bullet["x"] == x && bullet["y"] == y)
					cell_content = "*"
					bgcolor = "#FFFF00"
					break

			if(!game_over)
				dat += "<td width='20' height='20' bgcolor='[bgcolor]' align='center' style='color: white;'><A href='byond://?src=\ref[src];md_shoot=1;md_shoot_x=[x];md_shoot_y=[y]'>[cell_content]</A></td>"
			else
				dat += "<td width='20' height='20' bgcolor='[bgcolor]' align='center' style='color: white;'>[cell_content]</td>"
		dat += "</tr>"
	dat += "</table>"

	dat += "</center>"
	return dat

/obj/structure/machinery/computer/proc/handle_minidoom_input(href_list)
	if(href_list["md_restart"])
		initialize_minidoom()
		return

	if(href_list["md_move"])
		var/direction = href_list["md_move"]
		move_player_minidoom(direction)

	if(href_list["md_shoot"])
		var/target_x = text2num(href_list["md_shoot_x"])
		var/target_y = text2num(href_list["md_shoot_y"])
		shoot_minidoom(target_x, target_y)

	// Update enemies
	update_minidoom()

/obj/structure/machinery/computer/proc/move_player_minidoom(direction)
	if(game_data["game_over"])
		return

	var/player_x = game_data["player_x"]
	var/player_y = game_data["player_y"]
	var/grid_size = game_data["grid_size"]

	var/new_x = player_x
	var/new_y = player_y

	switch(direction)
		if("w")
			new_y--
		if("s")
			new_y++
		if("a")
			new_x--
		if("d")
			new_x++

	if(new_x >= 1 && new_x <= grid_size && new_y >= 1 && new_y <= grid_size)
		game_data["player_x"] = new_x
		game_data["player_y"] = new_y

/obj/structure/machinery/computer/proc/shoot_minidoom(target_x, target_y)
	if(game_data["game_over"])
		return

	var/player_ammo = game_data["player_ammo"]
	if(player_ammo <= 0)
		return

	game_data["player_ammo"] = player_ammo - 1

	var/player_x = game_data["player_x"]
	var/player_y = game_data["player_y"]

	// Create bullet
	var/list/bullet = list("x" = player_x, "y" = player_y, "target_x" = target_x, "target_y" = target_y)
	game_data["bullets"] += list(bullet)

/obj/structure/machinery/computer/proc/update_minidoom()
	if(game_data["game_over"])
		return

	var/list/bullets = game_data["bullets"]
	var/list/enemies = game_data["enemies"]
	var/player_x = game_data["player_x"]
	var/player_y = game_data["player_y"]
	var/grid_size = game_data["grid_size"]

	// Move bullets and check collisions
	for(var/i = bullets.len to 1 step -1)
		var/list/bullet = bullets[i]
		var/bx = bullet["x"]
		var/by = bullet["y"]
		var/tx = bullet["target_x"]
		var/ty = bullet["target_y"]

		// Move bullet towards target
		if(bx < tx)
			bx++
		else if(bx > tx)
			bx--
		if(by < ty)
			by++
		else if(by > ty)
			by--

		bullet["x"] = bx
		bullet["y"] = by

		// Check if bullet reached target or out of bounds
		if((bx == tx && by == ty) || bx < 1 || bx > grid_size || by < 1 || by > grid_size)
			bullets.Cut(i, i + 1)
			continue

		// Check collision with enemies
		for(var/j = enemies.len to 1 step -1)
			var/list/enemy = enemies[j]
			if(enemy["x"] == bx && enemy["y"] == by)
				enemy["health"] -= 10
				bullets.Cut(i, i + 1)
				if(enemy["health"] <= 0)
					enemies.Cut(j, j + 1)
					game_data["score"] += 10
					// Spawn new enemy
					spawn_enemy()
				break

	// Move enemies towards player
	for(var/list/enemy in enemies)
		var/ex = enemy["x"]
		var/ey = enemy["y"]

		if(ex < player_x)
			ex++
		else if(ex > player_x)
			ex--
		if(ey < player_y)
			ey++
		else if(ey > player_y)
			ey--

		enemy["x"] = ex
		enemy["y"] = ey

		// Check if enemy reached player
		if(ex == player_x && ey == player_y)
			game_data["player_health"] -= 10
			if(game_data["player_health"] <= 0)
				game_data["game_over"] = TRUE
