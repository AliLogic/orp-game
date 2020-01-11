$(document).ready(function() {

	$('input[type=range].slider').on('input', function () {
		CallEvent('charcustom:preview', [$(this).id, $(this).val()]);
	});

	$('#finish').on('click', function () {
		if (
			skinColorOptions == undefined ||
			hairOptions == undefined ||
			shirtOptions == undefined ||
			pantsOptions == undefined ||
			shoesOptions == undefined ||
			hairColourOptions == undefined
		) {
			CallEvent('charcustom:finish', [0]);
		} else {
			CallEvent('charcustom:finish', [
				$(`#1`).val(),
				$(`#2`).val(),
				$(`#3`).val(),
				$(`#4`).val(),
				$(`#5`).val(),
				$(`#6`).val(),
			]);
		}
	});

	$('#exit').on('click', function () {
		CallEvent('charcustom:exit');
	});

	CallEvent('charcustom:ready');
   
	/*setCharacterName('Filipe Hughes');
	setSliderOptions(1);
	setSliderOptions(2);
	setSliderOptions(3);
	setSliderOptions(4);
	setSliderOptions(5);
	setSliderOptions(6);
	toggleCustomisation();*/
});

let skinColourOptions = undefined;
let hairOptions = undefined;
let hairColourOptions = undefined;
let shirtOptions = undefined;
let pantsOptions = undefined;
let shoesOptions = undefined;

function setDisplayName(name) {
	$('#name').text(name);
}

function setDisplaySliderOptions(id, options) {
	switch (id) {
		case 1: {
			skinColourOptions = options;
			$(`#1`).attr('max', `${skinColourOptions.length}`);
		}
		case 2: {
			hairOptions = options;
			$(`#2`).attr('max', `${hairOptions.length}`);
		}
		case 3: {
			hairColourOptions = options;
			$(`#3`).attr('max', `${hairColourOptions.length}`);
		}
		case 4: {
			shirtOptions = options;
			$(`#4`).attr('max', `${shirtOptions.length}`);
		}
		case 5: {
			pantsOptions = options;
			$(`#5`).attr('max', `${pantsOptions.length}`);
		}
		case 6: {
			shoesOptions = options;
			$(`#6`).attr('max', `${shoesOptions.length}`);
		}
	}
}

function toggleCustomization(toggle) {
	$('body').toggle();
}