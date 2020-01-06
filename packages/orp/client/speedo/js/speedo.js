function toggleSpeedometer(status) {
	if (status) {
		$('canvas[data-type="radial-gauge"]').show();
	} else {
		$('canvas[data-type="radial-gauge"]').hide();
	}
}

function setSpeedoSpeed(value) {
	if (value < 0) value = 0;
	else if (value > 220) value = 220;

	$('canvas[data-type="radial-gauge"]').attr('data-value', `${value}`);
}

function speedoShouldBeReady() {
	alert("Speedo Should Be Ready")
}

$(document).ready(function () {
	CallEvent('speedo:debug', 'Speedo is now ready!');
});