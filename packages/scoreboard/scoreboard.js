let players = [];
let selectedlast = null;

const toggleScoreboard = bool => bool ? $('body').show() : $('body').hide();

const removeElement = (array, elem) => {
	var index = array.indexOf(elem);
    if (index > -1) {
        array.splice(index, 1);
	}
}

$(document).ready(() => {
	//CallEvent('scorebork:ready');

	toggleScoreboard(true);

	$('.table .body .data > .columns').on('click', function () {
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
	players.push([player.id, players.length + 1]);
	$('.table .body .data').append(`<div class="columns" id="${players.length}"><div class="column" id="id">${player.id}</div><div class="column" id="name">${player.name}</div><div class="column" id="level">${player.level}</div><div class="column" id="ping">${player.ping}</div></div>`);
}

function removePlayer(player) {
	if (players[player] === undefined) {
		//return CallEvent('scorebork:remove', 0);
		return false;
	}

	$(`.table .body .data #${players[player][1]}`).remove();
	removeElement(players, players[player]);
}

function updateValue(player, value, newvalue) {
	if (value !== "id" && value !== "name" && value !== "level" && value !== "ping") {
		//return CallEvent('scorebork:update', 0);
		return false;
	}

	if (players[player] === undefined) {
		//return CallEvent('scorebork:update', 0);
		return false;
	}

	$(`.table .body .data #${players[player][1]} #${value}`).text(newvalue);
	//return CallEvent('scorebork:update', 0);
	return true;
}