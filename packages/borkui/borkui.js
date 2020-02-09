let elements = [];
let elementId = 0;

$(document).ready(() => {
	CallEvent('borkui:ready');

	/*createUI(0);
	addTitle('Bork UI');
	addDivider();
	addInformation('This is just a basic test.');
	addDivider();
	addTextInput('Name:');
	addDropdown(['test of the century', 'test2']);
	addButton('test', 'is-success');
	showUI(1);*/
});

function createUI(align = 0) {
	switch (align) {
		case 1: {
			$('.wrapper').css({'margin-left': '0%', 'margin-right': '66%'});
			break;
		}
		case 2: {
			$('.wrapper').css({'margin-left': '66%', 'margin-right': '0%'});
			break;
		}
		default: {
			$('.wrapper').css({'margin-left': '33%', 'margin-right': '33%'});
			break;
		}
	}
}

function addTitle(text) {
	$('#title').text(`${text}`);
}

function addInformation(text, anchor = 0) {
	/* 
		Anchors:
		0: center
		1: left
		2: right
	*/

	let alignment;
	switch (anchor) {
		case 1: {
			alignment = ' style="text-align: left;"';
			break;
		}
		case 2: {
			alignment = ' style="text-align: right;"';
			break;
		}
		default: {
			alignment = '';
			break;
		}
	}

	alert('addInformation called: '+ text);

	$('#card').append(`<div${alignment}><span>${text}</span></div>`);
}

function addDivider() {
	$('#content').append('<div class="is-divider"></div>');
}

function addButton(text, colour = 'is-dark', size = 1, rounded = false, fullwidth = true, anchor = 0) {
	/* 
		Anchors:
		0: center
		1: left
		2: right
	*/

	/* 
		Sizes:
		0 - Small
		1 - Normal (Default)
		2 - Medium
		3 - Large
	*/

	let alignment;
	let chosen_size;

	switch (anchor) {
		case 1: {
			alignment = ' style="text-align: left;"';
			break;
		}
		case 2: {
			alignment = ' style="text-align: right;"';
			break;
		}
		default: {
			alignment = '';
			break;
		}
	}

	switch (size) {
		case 0: {
			chosen_size = 'is-small';
			break;
		}
		case 2: {
			chosen_size = 'is-medium';
			break;
		}
		case 3: {
			chosen_size = 'is-large';
			break;
		}
		default: {
			chosen_size = '';
			break;
		}
	}

	elementId += 1;
	elements.push([elementId, true]);
	
	console.log('Button ID: '+ elementId);
	
	if (colour.startsWith('is-')) {
		$('#content').append(`<div${alignment}><button class="button ${colour} ${chosen_size} ${fullwidth ? 'is-fullwidth' : ''} ${rounded ? 'is-rounded' : ''}" id="${elementId}">${text}</button></div>`)
	} else {
		$('#content').append(`<div${alignment}><button class="button ${chosen_size} ${fullwidth ? 'is-fullwidth' : ''} ${rounded ? 'is-rounded' : ''}" id="${elementId}" style="background-color: ${colour};">${text}</button></div>`)
	}
}

function addTextInput(label, size = 1, type = 0, placeholder = '') {
	/* 
		Types:
		0: text
		1: password
	*/

	let chosen_size;
	let chosen_type;
	switch (size) {
		case 0: {
			chosen_size = 'is-small';
			break;
		}
		case 2: {
			chosen_size = 'is-medium';
			break;
		}
		case 3: {
			chosen_size = 'is-large';
			break;
		}
		default: {
			chosen_size = '';
			break;
		}
	}

	switch (type) {
		case 1: {
			chosen_type = 'password';
			break;
		}
		default: {
			chosen_type = 'text';
			break;
		}
	}

	elementId += 1;
	elements.push([elementId, false]);

	console.log('Text Input ID: '+ elementId);

	if (placeholder !== '') placeholder = "placeholder=\""+placeholder+"\"";
	$('#content').append(`<div class="field"><div class="control"><label class="label">${label}</label><input class="input ${chosen_size}" id="${elementId}" type="${chosen_type}" ${placeholder}></div></div>`);
}

function addDropdown(options, size = 1, rounded = false, label = '') {
	let optionhtml = '';
	let chosen_size;
	switch (size) {
		case 0: {
			chosen_size = 'is-small';
			break;
		}
		case 2: {
			chosen_size = 'is-medium';
			break;
		}
		case 3: {
			chosen_size = 'is-large';
			break;
		}
		default: {
			chosen_size = '';
			break;
		}
	}

	options.forEach((option) => {
		optionhtml += `<option>${option}</option>`;
	});

	elementId += 1;
	elements.push([elementId, false]);

	console.log('Dropdown ID: '+ elementId);

	if (label.length > 0) {
		label = `<label class="label">${label}</label>`;
	}

	$('#content').append(`<div class="field"><div class="control">${label}<div class="select ${chosen_size}"><select id="${elementId}">${optionhtml}</select></div></div></div>`);
}

/*function addButtonsSideBySide(...buttons) {
	/*
		Must be given:
		text - Text to be displayed.
		colour - Colour to set the button.

	let html = '<div class="columns">';
	let buttonshtml = [];

	if (buttons.length <= 4) {
		for (let button of buttons) {
			if (button[1].startsWith('is-')) {
				buttonshtml.push(`<div class="column"><button class="button ${button[1]} is-fullwidth" id="${buttonCount}">${button[0]}</button></div>`);
			} else {
				buttonshtml.push(`<div class="column"><button class="button is-fullwidth" id="${buttonCount}" style="background-color: ${button[0]};">${text}</button></div>`)
			}
		}

		buttonshtml.forEach((button) => {
			html += button;
		});

		html += '</div>'
		$('#card').append(html);
	}
}*/

function clearUI() {
	$('#content').html('');
	$('#title').text('');
	CallEvent('borkui:OnHideMenu');
}

function showUI(id) {
	if ($('body').is(':hidden')) {
		$('body').show();
		$('button').on('click', function (e) {
			e.preventDefault();
			//let returnValues = [id, (parseInt($(this).attr('id')) - elements.length) + 1]; // id is dialogid, second id is button clicked.
		
			elements.forEach((element) => {
				if (!element[1]) {
					// add a new string variable, and concat the elements together and then pass it in the place of "text" in CallEvent(...)
					console.log($(`#${element[0]}`).val());
					//returnValues.push($(`#${element[0]}`).val());
				}
			});
		
			//console.log(returnValues);
			CallEvent('borkui:OnDialogSubmit', Math.floor(id), Math.floor((parseInt($(this).attr('id')) - elements.length) + 1), "test");
		});
	}
}

function hideUI(id) {
	if ($('body').is(':visible')) {
		$('body').hide();
		$('button').off();
	}
}