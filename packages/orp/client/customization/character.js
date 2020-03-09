let lastTab = null;
let lastPage = null;

let lastSkinRadio = null;
let lastHairRadio = null;

let shirts = [];
let trousers = [];
let shoes = [];

let lastShirt = shirts.length > 0 ? 1 : 0;
let lastTrouser = trousers.length > 0 ? 1 : 0;
let lastShoe = shoes.length > 0 ? 1 : 0;

$(document).ready(() => {

	lastTab = $('.tabs ul li.is-active');
	lastPage = $('#appearance');


	$('#shirtlabel').text(`${shirts.length === 0 ? '0' : '1'}/${shirts.length}`);
	$('#pantslabel').text(`${trousers.length === 0 ? '0' : '1'}/${trousers.length}`);
	$('#shoeslabel').text(`${trousers.length === 0 ? '0' : '1'}/${shoes.length}`);

	$('.tabs ul li').on('click', function (e) {
		e.preventDefault();
		console.log("clicked");

		lastTab.removeClass("is-active");
		$(this).addClass("is-active");
		
		lastPage.hide();
		$(`#${($(this).attr("id").split("-")[0])}`).show();

		lastPage = $(`#${($(this).attr("id").split("-")[0])}`);
		lastTab = $(this);
	});

	$('.radio').on('click', function (e) {
		e.preventDefault();

		if ($(this).hasClass("skin")) {	
			if (lastSkinRadio !== null) lastSkinRadio.removeClass("is-active");
			$(this).addClass("is-active");
			lastSkinRadio = $(this);
		} else if ($(this).hasClass("hair")) {
			if (lastHairRadio !== null) lastHairRadio.removeClass("is-active");
			$(this).addClass("is-active");
			lastHairRadio = $(this);
		}
	});

	$('button.button#shirtleft').on('click', function (e) {
		e.preventDefault();
		console.log("shirt left clicked");
		console.log((shirts.length - shirts.length) + 1);
		if (lastShirt < ((shirts.length - shirts.length) + 1)) {
			console.log("not possible");
		} else {
			lastShirt -= 1;
			$('#shirtinput').val(shirts[lastShirt - 1]);
			console.log("very possible");
		}
		console.log(lastShirt);
	});

	$('button.button#shirtright').on('click', function (e) {
		e.preventDefault();
		console.log("shirt right clicked");
		console.log(lastShirt);
		if (lastShirt >= shirts.length) {
			console.log("not possible");
		} else {
			lastShirt += 1;
			$('#shirtinput').val(shirts[lastShirt - 1]);
			console.log("very possible");
		}
		console.log(lastShirt);
	});

	$('#submit').on('click', function (e) {
		e.preventDefault();

		CallEvent("Customization_OnSubmit", [lastShirt, lastTrouser, lastShoe, $('#skinslider').attr("max"), JSON.stringify(/[0-9]{1,3}, [0-9]{1,3}, [0-9]{1,3}/.exec(lastSkinRadio.css("background-color")).split(",")), $('#hairslider').attr("max"), JSON.stringify(/[0-9]{1,3}, [0-9]{1,3}, [0-9]{1,3}/.exec(lastHairRadio.css("background-color")).split(","))]);
	});

	CallEvent("Customization_DocumentReady");
});

function setShirts(shirtsArray) {
	shirts = shirtsArray;
	$('#shirtlabel').text(`${shirts.length === 0 ? '0' : '1'}/${shirts.length}`);
	lastShirt = 1;
}

function setPants(pantsArray) {
	trousers = pantsArray;
	$('#pantslabel').text(`${trousers.length === 0 ? '0' : '1'}/${trousers.length}`);
}

function setShoes(shoesArray) {
	shoes = shoesArray;
	$('#shoeslabel').text(`${trousers.length === 0 ? '0' : '1'}/${shoes.length}`);
}

function setHairAmount(amount) {
	$('#hairslider').attr("max", Number.isInteger(amount) ? amount : '1');
	$('#hairlabel').text(`${Number.isInteger(amount) ? '1' : NaN}/${Number.isInteger(amount) ? amount : NaN}`);
}

function setFaceAmount(amount) {
	$('#faceslider').attr("max", Number.isInteger(amount) ? amount : '1');
	$('#facelabel').text(`${Number.isInteger(amount) ? '1' : NaN}/${Number.isInteger(amount) ? amount : NaN}`);
}