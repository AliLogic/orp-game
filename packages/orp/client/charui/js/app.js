const MAX_CHARACTERS = 3;
const character = [];

CallEvent("charui:debug", 'charUI 1.0 Loaded!')
CallEvent("charui:debug", 'Now onto lower part of JS.')

function test() {
	CallEvent("charui:debug", 'test() works.')
}

function setCharacterInfo(char) {
	//char = JSON.parse(char);
	CallEvent("charui:debug", 'setCharacterInfo received.')
	console.log(character[char.slot].info);

	/* Display stuff */
	character[char.slot - 1].name.text(char.firstname + " " + char.lastname);
	character[char.slot - 1].level.text(char.level);
	character[char.slot - 1].cash.text(numberWithCommas(char.cash));

	/* JQuery Stuff */
	character[char.slot - 1].info.show();
	$("#name" + (char.slot) + "spawntext").text("Spawn Character");
	character[char.slot - 1].delete.removeClass('is-static');
}

function clearCharacterInfo(slot) {
	character[slot].name.text("Empty Character Slot " + (slot + 1));
	character[slot].level.text("0");
	character[slot].cash.text("0");

	character[slot].info.hide();
	$("#name" + (slot + 1) + "spawntext").text("Create Character");
	if (!character[slot].delete.hasClass('is-static')) character[slot].delete.addClass('is-static');
}

function numberWithCommas(x) {
	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function toggleCharMenu() {
	CallEvent("charui:debug", 'ToggleCharMenu called.')
	$('#body').toggle();
}

$(document).ready(function () {
	CallEvent("charui:debug", 'document is loading...')
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

	$("button").on('click', function (e) {
		let id = $(this).attr("id");
		
		if (id === "name1spawn") {
			if (parseInt($(`.info.bottom#name${parseInt(/\d/.exec(id))} #name${parseInt(/\d/.exec(id))}level`).text()) === 0) {
				console.log("Create at Slot 1")
				CallEvent('charui:create', 1);
			} else {
				console.log("Spawn at Slot 1")
				CallEvent('charui:spawn', [1, character[0].name.text()]);
			}
		} else if (id === "name1delete") {
			CallEvent('charui:delete', 1);
		} else if (id === "name2spawn") {
			if (parseInt($(`.info.bottom#name${parseInt(/\d/.exec(id))} #name${parseInt(/\d/.exec(id))}level`).text()) === 0) {
				console.log("Create at Slot 2")
				CallEvent('charui:create', 2);
			} else {
				console.log("Spawn at Slot 2")
				CallEvent('charui:spawn', [2, character[1].name.text()]);
			}
		} else if (id === "name2delete") {
			CallEvent('charui:delete', 2);
		} else if (id === "name3spawn") {
			if (parseInt($(`.info.bottom#name${parseInt(/\d/.exec(id))} #name${parseInt(/\d/.exec(id))}level`).text()) === 0) {
				console.log("Create at Slot 3")
				CallEvent('charui:create', 3);
			} else {
				console.log("Spawn at Slot 3")
				CallEvent('charui:spawn', [3, character[2].name.text()]);
			}
		} else if (id === "name3delete") {
			CallEvent('charui:delete', 3);
		}
	});

	CallEvent("charui:debug", 'Document is now ready!')
	//toggleCharMenu();
});