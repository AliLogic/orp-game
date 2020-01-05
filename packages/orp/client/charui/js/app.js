$(window).on('load', () => {
	const MAX_CHARACTERS = 3;
	const character = [];

	for (let i = 1; i <= MAX_CHARACTERS; i++) {
		console.log(i);
		console.log($(".info.bottom#name" + i))
		character.push({
			name: $(".info.top#name" + i),
			level: $("#name" + i + "level"),
			cash: $("#name" + i + "cash"),
			info: $(".info.bottom#name" + i),
			spawn: $("#name" + i + "spawn"),
			delete: $("#name" + i + "delete")
		});
	}

	const setCharacterInfo = (char) => {
		//char = JSON.parse(char);
		console.log(character[char.slot].info);

		/* Display stuff */
		character[char.slot].name.text(char.firstname + " " + char.lastname);
		character[char.slot].level.text(char.level);
		character[char.slot].cash.text(numberWithCommas(char.cash));

		/* JQuery Stuff */
		character[char.slot].info.show();
		$("#name" + (char.slot + 1) + "spawntext").text("Spawn Character");
		character[char.slot].delete.removeClass('is-static');
	}

	const clearCharacterInfo = (slot) => {
		character[slot].name.text("Empty Character Slot " + (slot + 1));
		character[slot].level.text("0");
		character[slot].cash.text("0");

		character[slot].info.hide();
		$("#name" + (slot + 1) + "spawntext").text("Create Character");
		if (!character[slot].delete.hasClass('is-static')) character[slot].delete.addClass('is-static');
	}

	const numberWithCommas = (x) => {
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}

	/*setCharacterInfo({
		slot: 0,
		firstname: "John",
		lastname: "Doe",
		level: 1,
		cash: 90
	});

	setCharacterInfo({
		slot: 1,
		firstname: "John",
		lastname: "Appleseed",
		level: 5,
		cash: 50000
	});

	setCharacterInfo({
		slot: 2,
		firstname: "Jane",
		lastname: "Smith",
		level: 10,
		cash: 2500
	});*/

	$("button").on('click', function (e) {
		let id = $(this).attr("id");
		
		if (id === "name1spawn") {
			if (parseInt($(`.info.bottom#name${parseInt(/\d/.exec(id))} #name${parseInt(/\d/.exec(id))}level`).text()) === 0) {
				console.log("Create at Slot 1")
				ue.game.callevent('charui:create', '[1]');
			} else {
				console.log("Spawn at Slot 1")
				ue.game.callevent('charui:spawn', `[1, '${character[0].name.text()}']`);
			}
		} else if (id === "name1delete") {
			ue.game.callevent('charui:delete', '[1]');
		} else if (id === "name2spawn") {
			if (parseInt($(`.info.bottom#name${parseInt(/\d/.exec(id))} #name${parseInt(/\d/.exec(id))}level`).text()) === 0) {
				console.log("Create at Slot 2")
				ue.game.callevent('charui:create', '[2]');
			} else {
				console.log("Spawn at Slot 2")
				ue.game.callevent('charui:spawn', `[2, '${character[1].name.text()}']`);
			}
		} else if (id === "name2delete") {
			ue.game.callevent('charui:delete', '[2]');
		} else if (id === "name3spawn") {
			if (parseInt($(`.info.bottom#name${parseInt(/\d/.exec(id))} #name${parseInt(/\d/.exec(id))}level`).text()) === 0) {
				console.log("Create at Slot 3")
				ue.game.callevent('charui:create', '[3]');
			} else {
				console.log("Spawn at Slot 3")
				ue.game.callevent('charui:spawn', `[3, '${character[2].name.text()}']`);
			}
		} else if (id === "name3delete") {
			ue.game.callevent('charui:delete', '[3]');
		}
	});

	function toggleCharMenu() {
		ue.game.callevent("charui:debug", `['toggleCharMenu called.']`)
		$('#body').toggle();
	}
	//toggleCharMenu();

});