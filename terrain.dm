world
	tick_lag = 0.5
	turf = /turf/dirt
	view = 5
	New()
		..()
		maxx = 50
		maxy = 5750
		maxz = 1
		CreateReferences()
		CreateAtmosphere()
		spawn(9)
			MakeAirPockets()
		//spawn(10)
		MovementLoop()
		spawn(10)
			AddLoot()
		spawn(10)
			AutoJoin()
		spawn(30)
			CreateBackground()
	proc
		AutoJoin()
			for(var/y = maxy, y >= 1, y--)
				for(var/x = 1, x <= maxx, x++)
					var/turf/dirt/T = locate(x, y, maxz)
					if(istype(T, /turf/dirt))
						T.AutoJoin16()
				sleep(1)

		MovementLoop()
			spawn(1)
				MovementLoop()
			for(var/mob/M in world)
				M.fuel_counter++
				if(M.fuel_counter == 30)
					M.fuel_counter = 0
					M.fuel--
				var/ismoving = 0
				if(M.moving > 0)
					ismoving = 1
					M.moving--
					if(!M.moving)
						M.pixel_step_size = 0
				if(M.airborne)
					ismoving = 1
					M.airborne--
					M.fall_distance = 0
					continue
				if(M.moving < 0)
					M.moving = 0
				var/turf/T = get_step(M, SOUTH)
				if(!T.density)
					step(M, SOUTH)
				else
					if(M.fall_distance > 3)
						M.Damage(M.fall_distance - 3)
					M.fall_distance = 0

		Earthquake()
			for(var/turf/dirt/T in world)
				if(prob(5))
					T = new /turf/underground(T, TRUE)
			for(var/turf/air/T in world)
				if(prob(20))
					T = new /turf/dirt(T, TRUE)

		CreateReferences()
			var/obj/mineable/O
			for(var/X in typesof(/obj/mineable))
				if(!istype(X, /obj/mineable))
					O = new X()
					ref_mineables += O
			for(var/x = 1, x <= 115, x++)
				var/icon/I = icon('background_dirt.dmi', "[x]")
				ref_backgrounds += I

		CreateAtmosphere()
			for(var/x = 1, x <= maxx, x++)
				for(var/y = maxy - 20, y <= maxy, y++)
					var/turf/T = locate(x,y,maxz)
					T = new /turf/air(T)

		CreateBackground()
			var/temp
			for(var/y = maxy - sky_offset - 1, y >= 1, y--)
				temp = world.maxy - y
				temp = round(temp / 50) + 1
				for(var/x = 1, x <= maxx, x++)
					var/turf/T = locate(x,y,maxz)
					T.underlays += ref_backgrounds[temp]
				//sleep(1)

		MakeAirPockets()
			for(var/y = maxy - 23, y >= maxy - 524, y--)
				for(var/x = 1, x <= maxx, x++)
					if(prob((y+500-maxy) / 30))
						var/turf/T = locate(x,y,maxz)
						T = new /turf/underground(T)

		AddLoot()
			var/curset = 1
			for(var/y = maxy - sky_offset - 1, y >= 1, y--)
				var/mod = maxy - sky_offset - y
				if(mod % 250 == 0)
					curset = (maxy - sky_offset - y) / 250 + 1
				for(var/x = 1, x <= maxx, x++)
					if(prob(7))
						var/turf/T = locate(x,y,maxz)
						if(istype(T, /turf/dirt))
							var/type = WeightedPick(sets[curset])
							new type(T)
				sleep(1)

var
	ref_mineables[] = list()
	ref_backgrounds[] = list()
	sky_offset = 20
	set1[] = list(/obj/mineable/bits_of_silver=13, /obj/mineable/nuggets_of_silver=9, /obj/mineable/chunks_of_silver=5, /obj/mineable/silver=3, /obj/mineable/bits_of_gold=8, /obj/mineable/nuggets_of_gold=5, /obj/mineable/chunks_of_gold=3, /obj/mineable/bits_of_platinum=3, /obj/mineable/nuggets_of_platinum=2, /obj/mineable/bits_of_absol=3)
	set2[] = list(/obj/mineable/bits_of_silver=17, /obj/mineable/nuggets_of_silver=11, /obj/mineable/chunks_of_silver=6, /obj/mineable/silver=4, /obj/mineable/bits_of_gold=10, /obj/mineable/nuggets_of_gold=7, /obj/mineable/chunks_of_gold=4, /obj/mineable/gold=2, /obj/mineable/bits_of_platinum=5, /obj/mineable/nuggets_of_platinum=3, /obj/mineable/chunks_of_platinum=2, /obj/mineable/bits_of_absol=4, /obj/mineable/nuggets_of_absol=3, /obj/mineable/bits_of_electrum=2, /obj/mineable/bits_of_opal=2)
	set3[] = list(/obj/mineable/chunks_of_silver=8, /obj/mineable/silver=5, /obj/mineable/nuggets_of_gold=8, /obj/mineable/chunks_of_gold=5, /obj/mineable/gold=3, /obj/mineable/bits_of_platinum=6, /obj/mineable/nuggets_of_platinum=4, /obj/mineable/chunks_of_platinum=3, /obj/mineable/platinum=2, /obj/mineable/bits_of_absol=5, /obj/mineable/nuggets_of_absol=3, /obj/mineable/chunks_of_absol=3, /obj/mineable/bits_of_electrum=3, /obj/mineable/nuggets_of_electrum=2, /obj/mineable/bits_of_peridot=3, /obj/mineable/bits_of_opal=3)
	set4[] = list(/obj/mineable/silver=6, /obj/mineable/chunks_of_gold=6, /obj/mineable/gold=4, /obj/mineable/bits_of_platinum=7, /obj/mineable/nuggets_of_platinum=5, /obj/mineable/chunks_of_platinum=4, /obj/mineable/platinum=3, /obj/mineable/bits_of_absol=6, /obj/mineable/nuggets_of_absol=4, /obj/mineable/chunks_of_absol=3, /obj/mineable/absol=2, /obj/mineable/bits_of_electrum=4, /obj/mineable/nuggets_of_electrum=3, /obj/mineable/chunks_of_electrum=2, /obj/mineable/bits_of_einsteinium=2, /obj/mineable/bits_of_peridot=3, /obj/mineable/pieces_of_peridot=2, /obj/mineable/bits_of_opal=4, /obj/mineable/pieces_of_opal=3)
	set5[] = list(/obj/mineable/gold=5, /obj/mineable/chunks_of_platinum=4, /obj/mineable/platinum=3, /obj/mineable/nuggets_of_absol=5, /obj/mineable/chunks_of_absol=4, /obj/mineable/absol=3, /obj/mineable/bits_of_electrum=5, /obj/mineable/nuggets_of_electrum=3, /obj/mineable/chunks_of_electrum=3, /obj/mineable/electrum=2, /obj/mineable/bits_of_einsteinium=3, /obj/mineable/nuggets_of_einsteinium=2, /obj/mineable/bits_of_sapphire=2, /obj/mineable/bits_of_peridot=4, /obj/mineable/pieces_of_peridot=3, /obj/mineable/big_pieces_of_peridot=2, /obj/mineable/bits_of_opal=5, /obj/mineable/pieces_of_opal=3, /obj/mineable/big_pieces_of_opal=2)
	set6[] = list(/obj/mineable/chunks_of_platinum=5, /obj/mineable/platinum=4, /obj/mineable/chunks_of_absol=4, /obj/mineable/absol=3, /obj/mineable/nuggets_of_electrum=4, /obj/mineable/chunks_of_electrum=3, /obj/mineable/electrum=2, /obj/mineable/bits_of_einsteinium=3, /obj/mineable/nuggets_of_einsteinium=2, /obj/mineable/bits_of_sapphire=3, /obj/mineable/bits_of_peridot=4, /obj/mineable/pieces_of_peridot=3, /obj/mineable/big_pieces_of_peridot=2, /obj/mineable/pieces_of_opal=3, /obj/mineable/big_pieces_of_opal=3)
	set7[] = list(/obj/mineable/platinum=4, /obj/mineable/absol=4, /obj/mineable/nuggets_of_electrum=4, /obj/mineable/chunks_of_electrum=3, /obj/mineable/electrum=3, /obj/mineable/bits_of_einsteinium=3, /obj/mineable/nuggets_of_einsteinium=3, /obj/mineable/bits_of_sapphire=3, /obj/mineable/pieces_of_peridot=4, /obj/mineable/big_pieces_of_peridot=3, /obj/mineable/pieces_of_opal=4, /obj/mineable/big_pieces_of_opal=3, /obj/mineable/opal=2)
	set8[] = list(/obj/mineable/bits_of_adamantite=2, /obj/mineable/absol=4, /obj/mineable/chunks_of_electrum=4, /obj/mineable/electrum=3, /obj/mineable/bits_of_einsteinium=4, /obj/mineable/nuggets_of_einsteinium=3, /obj/mineable/chunks_of_einsteinium=2, /obj/mineable/bits_of_sapphire=3, /obj/mineable/pieces_of_sapphire=2, /obj/mineable/big_pieces_of_peridot=3, /obj/mineable/peridot=2, /obj/mineable/big_pieces_of_opal=3, /obj/mineable/opal=3)
	set9[] = list(/obj/mineable/bits_of_adamantite=3, /obj/mineable/electrum=4, /obj/mineable/nuggets_of_einsteinium=4, /obj/mineable/chunks_of_einsteinium=3, /obj/mineable/bits_of_sapphire=4, /obj/mineable/pieces_of_sapphire=3, /obj/mineable/big_pieces_of_peridot=4, /obj/mineable/peridot=3, /obj/mineable/big_pieces_of_opal=4, /obj/mineable/opal=3)
	set10[] = list(/obj/mineable/bits_of_adamantite=3, /obj/mineable/chunks_of_einsteinium=3, /obj/mineable/einsteinium=2, /obj/mineable/pieces_of_sapphire=3, /obj/mineable/big_pieces_of_sapphire=2, /obj/mineable/peridot=3, /obj/mineable/bits_of_emerald=2, /obj/mineable/opal=3)
	set11[] = list(/obj/mineable/bits_of_adamantite=3, /obj/mineable/nuggets_of_adamantite=2, /obj/mineable/chunks_of_einsteinium=3, /obj/mineable/einsteinium=2, /obj/mineable/pieces_of_sapphire=3, /obj/mineable/big_pieces_of_sapphire=2, /obj/mineable/peridot=3, /obj/mineable/bits_of_emerald=2)
	set12[] = list(/obj/mineable/bits_of_adamantite=4, /obj/mineable/nuggets_of_adamantite=3, /obj/mineable/chunks_of_adamantite=2, /obj/mineable/chunks_of_einsteinium=4, /obj/mineable/einsteinium=3, /obj/mineable/big_pieces_of_sapphire=3, /obj/mineable/sapphire=2, /obj/mineable/bits_of_ruby=2, /obj/mineable/bits_of_emerald=3, /obj/mineable/pieces_of_emerald=2)
	set13[] = list(/obj/mineable/nuggets_of_adamantite=3, /obj/mineable/chunks_of_adamantite=3, /obj/mineable/einsteinium=3, /obj/mineable/big_pieces_of_sapphire=3, /obj/mineable/sapphire=3, /obj/mineable/bits_of_ruby=3, /obj/mineable/bits_of_emerald=3, /obj/mineable/pieces_of_emerald=3, /obj/mineable/big_pieces_of_emerald=2)
	set14[] = list(/obj/mineable/nuggets_of_adamantite=3, /obj/mineable/chunks_of_adamantite=3, /obj/mineable/adamantite=2, /obj/mineable/einsteinium=4, /obj/mineable/big_pieces_of_sapphire=4, /obj/mineable/sapphire=3, /obj/mineable/bits_of_ruby=3, /obj/mineable/pieces_of_ruby=2, /obj/mineable/bits_of_emerald=4, /obj/mineable/pieces_of_emerald=3, /obj/mineable/big_pieces_of_emerald=2)
	set15[] = list(/obj/mineable/nuggets_of_adamantite=4, /obj/mineable/chunks_of_adamantite=3, /obj/mineable/adamantite=3, /obj/mineable/einsteinium=4, /obj/mineable/sapphire=3, /obj/mineable/bits_of_ruby=3, /obj/mineable/pieces_of_ruby=3, /obj/mineable/big_pieces_of_ruby=2, /obj/mineable/bits_of_emerald=4, /obj/mineable/pieces_of_emerald=3, /obj/mineable/big_pieces_of_emerald=3, /obj/mineable/emerald=2)
	set16[] = list(/obj/mineable/nuggets_of_adamantite=4, /obj/mineable/chunks_of_adamantite=3, /obj/mineable/adamantite=3, /obj/mineable/einsteinium=4, /obj/mineable/sapphire=4, /obj/mineable/bits_of_ruby=4, /obj/mineable/pieces_of_ruby=3, /obj/mineable/big_pieces_of_ruby=2, /obj/mineable/bits_of_emerald=4, /obj/mineable/pieces_of_emerald=4, /obj/mineable/big_pieces_of_emerald=3, /obj/mineable/emerald=2)
	set17[] = list(/obj/mineable/nuggets_of_adamantite=4, /obj/mineable/chunks_of_adamantite=4, /obj/mineable/adamantite=3, /obj/mineable/einsteinium=5, /obj/mineable/sapphire=4, /obj/mineable/bits_of_diamond=2, /obj/mineable/bits_of_ruby=4, /obj/mineable/pieces_of_ruby=3, /obj/mineable/big_pieces_of_ruby=2, /obj/mineable/bits_of_emerald=5, /obj/mineable/pieces_of_emerald=4, /obj/mineable/big_pieces_of_emerald=3, /obj/mineable/emerald=2)
	set18[] = list(/obj/mineable/nuggets_of_adamantite=5, /obj/mineable/chunks_of_adamantite=4, /obj/mineable/adamantite=3, /obj/mineable/einsteinium=5, /obj/mineable/sapphire=4, /obj/mineable/bits_of_diamond=2, /obj/mineable/bits_of_ruby=4, /obj/mineable/pieces_of_ruby=3, /obj/mineable/big_pieces_of_ruby=3, /obj/mineable/ruby=2, /obj/mineable/bits_of_emerald=5, /obj/mineable/pieces_of_emerald=4, /obj/mineable/big_pieces_of_emerald=3, /obj/mineable/emerald=3)
	set19[] = list(/obj/mineable/nuggets_of_adamantite=5, /obj/mineable/chunks_of_adamantite=5, /obj/mineable/adamantite=4, /obj/mineable/einsteinium=6, /obj/mineable/sapphire=5, /obj/mineable/bits_of_diamond=3, /obj/mineable/bits_of_ruby=5, /obj/mineable/pieces_of_ruby=4, /obj/mineable/big_pieces_of_ruby=3, /obj/mineable/ruby=2, /obj/mineable/bits_of_emerald=6, /obj/mineable/pieces_of_emerald=5, /obj/mineable/big_pieces_of_emerald=4, /obj/mineable/emerald=3)
	set20[] = list(/obj/mineable/nuggets_of_adamantite=6, /obj/mineable/chunks_of_adamantite=6, /obj/mineable/adamantite=5, /obj/mineable/einsteinium=7, /obj/mineable/sapphire=6, /obj/mineable/bits_of_diamond=4, /obj/mineable/pieces_of_diamond=2, /obj/mineable/bits_of_ruby=6, /obj/mineable/pieces_of_ruby=5, /obj/mineable/big_pieces_of_ruby=4, /obj/mineable/ruby=3, /obj/mineable/bits_of_emerald=7, /obj/mineable/pieces_of_emerald=6, /obj/mineable/big_pieces_of_emerald=5, /obj/mineable/emerald=4)
	set21[] = list(/obj/mineable/nuggets_of_adamantite=8, /obj/mineable/chunks_of_adamantite=7, /obj/mineable/adamantite=5, /obj/mineable/einsteinium=8, /obj/mineable/sapphire=7, /obj/mineable/bits_of_diamond=4, /obj/mineable/pieces_of_diamond=3, /obj/mineable/big_pieces_of_diamond=2, /obj/mineable/bits_of_ruby=7, /obj/mineable/pieces_of_ruby=5, /obj/mineable/big_pieces_of_ruby=5, /obj/mineable/ruby=4, /obj/mineable/bits_of_emerald=8, /obj/mineable/pieces_of_emerald=7, /obj/mineable/big_pieces_of_emerald=6, /obj/mineable/emerald=5)
	set22[] = list(/obj/mineable/nuggets_of_adamantite=9, /obj/mineable/chunks_of_adamantite=8, /obj/mineable/adamantite=6, /obj/mineable/einsteinium=9, /obj/mineable/sapphire=8, /obj/mineable/bits_of_diamond=5, /obj/mineable/pieces_of_diamond=3, /obj/mineable/big_pieces_of_diamond=3, /obj/mineable/bits_of_ruby=8, /obj/mineable/pieces_of_ruby=6, /obj/mineable/big_pieces_of_ruby=5, /obj/mineable/ruby=4, /obj/mineable/bits_of_emerald=9, /obj/mineable/pieces_of_emerald=8, /obj/mineable/big_pieces_of_emerald=7, /obj/mineable/emerald=5)
	set23[] = list(/obj/mineable/nuggets_of_adamantite=10, /obj/mineable/chunks_of_adamantite=9, /obj/mineable/adamantite=7, /obj/mineable/einsteinium=11, /obj/mineable/sapphire=9, /obj/mineable/bits_of_diamond=6, /obj/mineable/pieces_of_diamond=4, /obj/mineable/big_pieces_of_diamond=3, /obj/mineable/diamond=2, /obj/mineable/bits_of_ruby=9, /obj/mineable/pieces_of_ruby=7, /obj/mineable/big_pieces_of_ruby=6, /obj/mineable/ruby=5, /obj/mineable/bits_of_emerald=11, /obj/mineable/pieces_of_emerald=9, /obj/mineable/big_pieces_of_emerald=8, /obj/mineable/emerald=6)
	sets[] = list(set1, set2, set3, set4, set5, set6, set7, set8, set9, set10, set11, set12, set13, set14, set15, set16, set17, set18, set19, set20, set21, set22, set23)

atom/movable
	Bump(atom/bumpee)
		bumpee.Bumped(src)
atom
	proc
		Bumped(atom/bumper)



proc
	WeightedPick(fedlist[])
		var/picklist[] = fedlist.Copy()
		var/nlist[] = list()
		for(var/X in picklist)
			while(picklist[X] > 0)
				nlist += list(X)
				picklist[X]--
		return pick(nlist)

client
	perspective = EDGE_PERSPECTIVE
	Move(newloc, dirtry)
		if(mob.moving)
			return
		else
			. = ..()
			mob.moving += 1

mob
	icon = 'vehicle.dmi'
	icon_state = "digger"

	verb
		who()
			for(var/mob/M in world)
				src << "[M] ([M.client.inactivity/10] seconds inactive)"
		movedelay(val as num)
			move_delay = val
		move(dir as num, steps as num)
			while(steps)
				step(src, dir)
				steps--
		teleport(dir as num, steps as num)
			while(steps)
				loc = get_step(src, dir)
				steps--
		eq()
			world.Earthquake()
		writemycode()
			for(var/x = 1, x <= 23, x++)
				world << "set[x], \..."
		fullspit()
			spit(1, 100, "set1")
			spit(25, 125, "set2")
			spit(50, 150, "set3")
			spit(75, 175, "set4")
			spit(100, 200, "set5")
			spit(125, 215, "set6")
			spit(150, 230, "set7")
			spit(165, 255, "set8")
			spit(180, 280, "set9")
			spit(205, 300, "set10")
			spit(230, 320, "set11")
			spit(250, 360, "set12")
			spit(270, 400, "set13")
			spit(285, 440, "set14")
			spit(300, 480, "set15")
			spit(300, 490, "set16")
			spit(300, 500, "set17")
			spit(300, 550, "set18")
			spit(300, 600, "set19")
			spit(300, 700, "set20")
			spit(300, 800, "set21")
			spit(300, 900, "set22")
			spit(300, 1000, "set23")
		spit(min as num, max as num, msg as text)
			var/div = max * 1.2
			world << "	[msg]\[\] = list(\..."
			var/first = 1
			for(var/obj/mineable/O in ref_mineables)
				if(O.value >= min && O.value <= max)
					if(!first)
						world << ", \..."
					first = 0
					var/temp = O.value
					temp = ((div/O.value)-1)*3+1
					temp = round(temp)+1
					world << "[O.type]=[temp]\..."
			world << ")"
		reboot()
			world.Reboot()

	New()
		..()
		loc = locate(world.maxx/2,world.maxy-15,world.maxz)
		Move(loc)
		pixel_y = -3
		drill = new /obj/overlay/drill(src.loc)
		jets = new /obj/overlay/jets(src.loc)
		smoke = new /obj/overlay/smoke(src.loc)
		jets.pixel_y = -31
		smoke.pixel_y = -2

	Move(newloc, dirtry)
		//for(var/turf/T in view(world.view*2))
		//	if(!T.underlays.len)
		//		T.underlays += icon('background_dirt.dmi', "[round((world.maxy - y) / 50)]")
		var/olddir = dir
		. = ..()
		drill.loc = src.loc
		jets.loc = src.loc
		smoke.loc = src.loc
		fuel -= 1
		switch(dir)
			if(EAST)
				smoke.pixel_x = -4
				smoke.dir = EAST
				drill.pixel_x = 30
				drill.pixel_y = -6
				drill.dir = EAST
				if(airborne > 2)
					airborne = rand(6,7)
					jets.Flash(airborne - 2)
			if(WEST)
				smoke.pixel_x = 4
				smoke.dir = WEST
				drill.pixel_x = -30
				drill.pixel_y = -6
				drill.dir = WEST
				if(airborne > 2)
					airborne = rand(6,7)
					jets.Flash(airborne - 2)
			if(SOUTH)
				drill.pixel_x = 0
				drill.pixel_y = -27
				drill.dir = SOUTH
				fall_distance += 1
				if(airborne > 2)
					airborne = rand(6,7)
					jets.Flash(airborne - 2)
				dir = olddir
			if(NORTH)
				airborne = rand(7,9)
				jets.Flash(airborne - 2)
				dir = olddir
		/*if(dir != SOUTH && !airborne)
			var/turf/T = get_step(newloc, SOUTH)
			if(!T.density)
				world << airborne
				airborne = rand(6,7)
				jets.Flash(airborne - 2)*/
		if(airborne)
			smoke.invisibility = 1
		else
			smoke.invisibility = 0

	Bump(atom/bumpee)
		..()
		if(istype(bumpee, /turf/dirt))
			var/turf/T = get_step(src, SOUTH)
			if(T.density)
				if(bumpee.y <= src.y)
					TryDig(bumpee)

	Stat()
		statpanel("Cargo")
		stat("Cash:", cash)
		stat("Fuel:", "[fuel]/[maxfuel]")
		stat("Hull:", "[hull]/[maxhull]")
		stat("Cargo:", "[contents.len]/[maxcontents]")
		stat("Location:", "[x],[y]")
		stat("Action", action)
		stat("Moving", moving)
		stat("Airborne", airborne)
		stat("Fall Distance", fall_distance)
		var/turf/T = locate(x+1,y,z)
		stat("Next to you", "[T]")
		stat("")
		stat("Cargo Hold:","")
		stat(contents)
		stat("")
		stat("Storage:","")
		stat(storage)

	var
		hull = 10
		maxhull = 10
		fuel = 400
		maxfuel = 400
		maxcontents = 8

		cash = 50

		storage[] = list()

		obj/overlay/drill
		obj/overlay/jets
		obj/overlay/smoke
		tmp/action = 0
		tmp/moving = 0
		tmp/airborne = 0
		tmp/fall_distance = 0
		tmp/fuel_counter = 0
		move_delay = 10

	proc
		Damage(val)
			hull -= val
			src << "Your hull is damaged! ([val])"
			if(hull <= 0)
				src << "You are DEAD!!"

		TryDig(turf/dirt/tile)
			if(action)
				return
			if(moving)
				return
			if(airborne)
				jets.Flash(1)
				airborne = 0
				return
			for(var/obj/O in tile)
				if(O.density)
					return
			Dig(tile)

		Dig(turf/dirt/tile)
			var/move_speed = move_delay
			move_speed += round(tile.speed_cost)
			fuel -= tile.fuel_cost
			tile = new /turf/underground(tile, TRUE)
			new /obj/flick/dirt_dug(tile)
			for(var/turf/dirt/T in view(1, tile))
				T.AutoJoin16()
			switch(dir)
				if(SOUTH)
					pixel_step_size = 25 / max(1, move_speed)
				if(EAST)
					pixel_step_size = 20 / max(1, move_speed)
					var/turf/T = get_step(tile, SOUTH)
					if(!T.density)
						airborne = move_speed
						jets.Flash(airborne - 2)
				if(WEST)
					pixel_step_size = 20 / max(1, move_speed)
					var/turf/T = get_step(tile, SOUTH)
					if(!T.density)
						airborne = move_speed
						jets.Flash(airborne - 2)
			step(src, src.dir)
			moving += move_speed
			drill.Flash(move_speed - pixel_step_size/2)


obj
	proc
		DrilledNearby()
		DiggerNearby()
	flick
		var
			delay = 5
		New()
			..()
			flick('dirt_dug.dmi', src)
			spawn(delay)
				del(src)
		dirt_dug
			icon = 'dirt.dmi'
			icon_state = "dug"
			delay = 5

	environment
		fuel_station
			icon = 'signs.dmi'
			icon_state = "fuel station"
			Bumped(mob/bumper)
				bumper.fuel = bumper.maxfuel
		storage_repository
			icon = 'signs.dmi'
			icon_state = "storage repository"
			Bumped(mob/bumper)
				if(bumper.contents.len)
					for(var/obj/mineable/O in bumper.contents)
						bumper.storage += O
						bumper.contents -= O
				else
					for(var/obj/mineable/O in bumper.storage)
						bumper.contents += O
						bumper.storage -= O
		trade_center
			icon = 'signs.dmi'
			icon_state = "trade center"
			Bumped(mob/bumper)
				for(var/obj/mineable/O in bumper.contents)
					bumper << "You sell \a [O] for [O.value] in cash."
					bumper.cash += O.value
					bumper.contents -= O
					del(O)
		upgrade_manufacturer
			icon = 'signs.dmi'
			icon_state = "upgrade manufacturer"
			Bumped(mob/bumper)
		maintenance_shop
			icon = 'signs.dmi'
			icon_state = "maintenance shop"
			Bumped(mob/bumper)
				bumper.hull = bumper.maxhull

		gas_pocket
			Bumped(mob/bumper)
				bumper.Damage(bumper.maxhull/2)
		lava
			Bumped(mob/bumper)
				bumper.Damage(bumper.maxhull/3)
			DrilledNearby()
				var/turf/T = locate(x, y-1, z)
				if(!T.density)
					T.density = T.density
					// do stuff here
		rock
			icon = 'rock.dmi'
			density = 1
			New()
				icon_state = "[rand(1,6)]"
			Bumped(mob/bumper)
				return

	mineable
		icon = 'mineables.dmi'
		var
			value = 0
		Bumped(mob/bumper)
			if(bumper.contents.len < bumper.maxcontents)
				bumper << "You picked up \a [src]."
				Move(bumper)
			else
				// Add fade effect here
				del(src)

		bits_of_silver
			icon_state = "silver 1"
			value = 25
		nuggets_of_silver
			icon_state = "silver 2"
			value = 35
		chunks_of_silver
			icon_state = "silver 3"
			value = 60
		silver
			icon_state = "silver 4"
			value = 90
		bits_of_gold
			icon_state = "gold 1"
			value = 40
		nuggets_of_gold
			icon_state = "gold 2"
			value = 55
		chunks_of_gold
			icon_state = "gold 3"
			value = 85
		gold
			icon_state = "gold 4"
			value = 120
		bits_of_platinum
			icon_state = "platinum 1"
			value = 75
		nuggets_of_platinum
			icon_state = "platinum 2"
			value = 95
		chunks_of_platinum
			icon_state = "platinum 3"
			value = 125
		platinum
			icon_state = "platinum 4"
			value = 150
		bits_of_adamantite
			icon_state = "adamantite 1"
			value = 250
		nuggets_of_adamantite
			icon_state = "adamantite 2"
			value = 320
		chunks_of_adamantite
			icon_state = "adamantite 3"
			value = 360
		adamantite
			icon_state = "adamantite 4"
			value = 420
		bits_of_absol
			icon_state = "absol 1"
			value = 85
		nuggets_of_absol
			icon_state = "absol 2"
			value = 110
		chunks_of_absol
			icon_state = "absol 3"
			value = 130
		absol
			icon_state = "absol 4"
			value = 165
		bits_of_electrum
			icon_state = "electrum 1"
			value = 120
		nuggets_of_electrum
			icon_state = "electrum 2"
			value = 150
		chunks_of_electrum
			icon_state = "electrum 3"
			value = 170
		electrum
			icon_state = "electrum 4"
			value = 200
		bits_of_einsteinium
			icon_state = "einsteinium 1"
			value = 170
		nuggets_of_einsteinium
			icon_state = "einsteinium 2"
			value = 200
		chunks_of_einsteinium
			icon_state = "einsteinium 3"
			value = 250
		einsteinium
			icon_state = "einsteinium 4"
			value = 300
		bits_of_sapphire
			icon_state = "sapphire 1"
			value = 190
		pieces_of_sapphire
			icon_state = "sapphire 2"
			value = 240
		big_pieces_of_sapphire
			icon_state = "sapphire 3"
			value = 290
		sapphire
			icon_state = "sapphire 4"
			value = 350
		bits_of_diamond
			icon_state = "diamond 1"
			value = 500
		pieces_of_diamond
			icon_state = "diamond 2"
			value = 650
		big_pieces_of_diamond
			icon_state = "diamond 3"
			value = 800
		diamond
			icon_state = "diamond 4"
			value = 1000
		bits_of_ruby
			icon_state = "ruby 1"
			value = 350
		pieces_of_ruby
			icon_state = "ruby 2"
			value = 420
		big_pieces_of_ruby
			icon_state = "ruby 3"
			value = 480
		ruby
			icon_state = "ruby 4"
			value = 550
		bits_of_peridot
			icon_state = "peridot 1"
			value = 135
		pieces_of_peridot
			icon_state = "peridot 2"
			value = 160
		big_pieces_of_peridot
			icon_state = "peridot 3"
			value = 200
		peridot
			icon_state = "peridot 4"
			value = 235
		bits_of_emerald
			icon_state = "emerald 1"
			value = 300
		pieces_of_emerald
			icon_state = "emerald 2"
			value = 350
		big_pieces_of_emerald
			icon_state = "emerald 3"
			value = 400
		emerald
			icon_state = "emerald 4"
			value = 475
		bits_of_opal
			icon_state = "opal 1"
			value = 120
		pieces_of_opal
			icon_state = "opal 2"
			value = 155
		big_pieces_of_opal
			icon_state = "opal 3"
			value = 185
		opal
			icon_state = "opal 4"
			value = 220

var
	mineables_depth_150 = list(/obj/mineable/bits_of_silver=8, /obj/mineable/nuggets_of_silver=3, /obj/mineable/bits_of_gold=6, /obj/mineable/nuggets_of_gold=2)
	mineables_depth_350 = list(/obj/mineable/bits_of_silver=4, /obj/mineable/nuggets_of_silver=1, /obj/mineable/chunks_of_silver=1, /obj/mineable/bits_of_gold=3, /obj/mineable/nuggets_of_gold=1, /obj/mineable/bits_of_platinum=1)


obj
	overlay
		layer = MOB_LAYER+1
		animate_movement = SYNC_STEPS
		invisibility = 1
		drill
			icon = 'drill.dmi'
		jets
			icon = 'jets.dmi'
		smoke
			icon = 'smoke.dmi'
		New()
			..()
			Update()
		var
			flash_counter = 0
		proc
			Update()
				spawn(1)
					Update()
				if(flash_counter)
					flash_counter--
					if(flash_counter <= 0)
						invisibility = 1
			Flash(val)
				flash_counter = val
				if(val != 0)
					invisibility = 0
				else
					invisibility = 1


area
	icon = 'background_dirt.dmi'
	verb
		display()
			set src in world
			world << "icon is [icon] = [icon_state]"

turf
	Entered(mob/bumper)
		for(var/obj/O in src)
			bumper.Bump(O)

	Click()
		var/objs[] = list(/obj/environment/gas_pocket, /obj/environment/lava, /obj/environment/rock, /obj/environment/fuel_station, /obj/environment/storage_repository, /obj/environment/trade_center, /obj/environment/upgrade_manufacturer, /obj/environment/maintenance_shop)
		var/type = pick(objs)
		var/obj/O = new type(src)
		world << "Created [O]"

	New(loc, background)
		..()
		if(background)
			AddBackground()

	var
		fuel_cost = 1
		speed_cost = 0
		joinflag = 0
		joinstyle = 1
		autojointype

	proc
		AddBackground()
			var/temp = world.maxy - y
			temp = round(temp / 50) + 1
			world << "shade [temp] at [y]"
			underlays += ref_backgrounds[temp]


	air
		icon = 'sky.dmi'
		New()
			..()
			icon_state = "[world.maxy - y]"
		verb
			create(msg in list(/obj/environment/fuel_station, /obj/environment/storage_repository, /obj/environment/trade_center, /obj/environment/upgrade_manufacturer, /obj/environment/maintenance_shop))
				set src in world
				new msg(src)

	underground

	dirt
		icon = 'dirt.dmi'
		icon_state = "0"
		density = 1
		fuel_cost = 3
		verb
			display()
				set src in world
				world << "y [y] - underlays [underlays.len]"
		New()
			..()
			speed_cost = (world.maxy - y) / 1000

	rock
		icon = 'caves-joined.dmi'
		autojointype = /turf/rock

	proc
		AutoJoin16()
			var/value = 0
			var/turf/T = locate(x+1,y,z)
			if(istype(T,/turf/dirt) || !T)
				value += 2
			T = locate(x-1,y,z)
			if(istype(T,/turf/dirt) || !T)
				value += 8
			T = locate(x,y+1,z)
			if(istype(T,/turf/dirt) || !T)
				value += 1
			T = locate(x,y-1,z)
			if(istype(T,/turf/dirt) || !T)
				value += 4
			if(value == 15)
				icon_state = pick("a", "b", "c", "d")
			else
				icon_state = "[value]"

	proc
		AutoJoin32()
			// cardinal
			MatchTurf(NORTH,1)
			MatchTurf(EAST,4)
			MatchTurf(SOUTH,16)
			MatchTurf(WEST,64)
			// diagonal
			MatchTurf(NORTHEAST,2,5)
			MatchTurf(SOUTHEAST,8,20)
			MatchTurf(SOUTHWEST,32,80)
			MatchTurf(NORTHWEST,128,65)
			if(joinstyle == 1)
				icon_state = "[joinflag]"
			if(joinstyle == 2)
				overlays += image(src.icon, "[joinflag]")

		MatchTurf(direction,flag,mask=0)
			if((joinflag&mask)==mask)
				var/turf/T=get_step(src,direction)
				if(T)
					if(autojointype)
						if(autojointype == T.autojointype && T.icon_state)
							joinflag|=flag	// turn on the bit flag
							return
					else
						if(T.type==type && T.icon_state)
							joinflag|=flag	// turn on the bit flag
							return
			joinflag&=~flag     // turn off the bit flag

