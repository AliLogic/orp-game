function toggleSpeedometer(status) {
	if (status) {
		$('canvas[data-type="radial-gauge"]').show();
	} else {
		$('canvas[data-type="radial-gauge"]').hide();
	}
}

function setSpeedoSpeed(value) {
	if (value < 0) value = value * -1;
	else if (value > 220) value = 220;

	$('#speed').attr('data-value', `${value}`);
}

function setSpeedoRPM(value) {
	if (value < 0) value = 0;
	else if (value > 8000) value = 8000;
	
	$('#rpm').attr('data-value', `${value}`);
}

$(document).ready(function () {
	CallEvent('speedo:debug', 'Speedo is now ready!');
});