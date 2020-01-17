let players = [];

$(document).ready(() => {
	//CallEvent('scorebork:ready');

	insertPlayer({id:1, name:"Logic Coolguy420", level:420, ping:250});
	insertPlayer({id:2, name:"Logic Gayguy69", level:420, ping:250});
	insertPlayer({id:3, name:"Logic Idiote69", level:420, ping:250});
	toggleScoreboard(true);
});

const toggleScoreboard = bool => bool ? $('body').show() : $('body').hide();

const removeElement = (array, elem) => {
    var index = array.indexOf(elem);
    if (index > -1) {
        array.splice(index, 1);
	}
}

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