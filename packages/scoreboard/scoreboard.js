let players = [];
let selectedlast = null;

const toggleScoreboard = bool => bool ? $('body').show() : $('body').hide();

const removeElement = (array, elem) => {
	var index = array.indexOf(elem);
	if (index != -1) {
		array.splice(index, 1);
		return true;
	}
	return false;
}

$(document).ready(() => {
	//CallEvent('scorebork:ready');

	toggleScoreboard(true);

	$(document).on('click', '.table .body .data .columns', function () { // $('.table .body .data .columns .column').on('click', function () {
		console.log('selected');

		if (selectedlast !== null) {
			if (selectedlast.innerText === $(this).innerText && !selectedlast.hasClass('selected')) {
				$(this).removeClass('selected');
				console.log('selected is being deselected');
				return;
			}

			console.log(selectedlast);
			console.log($(this));

			selectedlast.removeClass('selected');
		}

		$(this).addClass('selected');
		selectedlast = $(this);

		/*if (selectedlast !== null) {
			if (selectedlast.css("background-color") === "rgb(255, 0, 0)") {
				selectedlast.css("background-color", "inherit");

				if (selectedlast !== $(this)) {
					$(this).css("background-color", "red");
				}
				console.log('set to inherit')
				return;
			}
		}

		if ($(this).css("background-color") === "rgb(255, 0, 0)") {
			$(this).css("background-color", "inherit");
			console.log("colour inherit");
		} else {
			$(this).css("background-color", "red");
			console.log("colour red");
		}

		selectedlast = $(this);*/

		/*if (selectedlast !== null) {
			if (selectedlast.css("background-color") === "rgba(0, 0, 0, 0)") {
				selectedlast.css("background-color", "inherit");
				selectedlast = $(this);
				console.log('colour inherit and THIS set');
			} else {
				selectedlast.css("background-color", "red");
				selectedlast = $(this);
			}
		}*/
	});
});

function insertPlayer(player) {

	removeElement(players, player.id); // remove if it exists already
	$('.table .body .data').append(`<div class="columns" id="${player.id}"><div class="column" id="id">${player.id}</div><div class="column" id="name">${player.name}</div><div class="column" id="level">${player.level}</div><div class="column" id="ping">${player.ping}</div></div>`);
	players.push(player.id);
	return true;
}

function removePlayer(playerid) {
	if (removeElement(players, playerid)) {
		$(`.table .body .data #${playerid}`).remove();
		console.log(`removePlayer(${playerid})`);
		return true;
	}
	return false;
}

function updateValue(player, value, newvalue) {
	if (value !== "id" && value !== "name" && value !== "level" && value !== "ping") {
		return false;
	}

	if (players.indexOf(player) === -1) {
		return false;
	}

	$(`.table .body .data #${players[player]} #${value}`).text(newvalue);
	return true;
}

function removePlayers() {
	
	$(`.table .body .data`).html('');
	players = [];
	return true;
}