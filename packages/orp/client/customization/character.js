$(document).ready(() => {
	let lastTab = $('.tabs ul li.is-active');
	let lastPage = $('#appearance');

	let lastSkinRadio = null;
	let lastHairRadio = null;

	let maxHair = 1;
	let maxFaces = 1;

	let shirts = [];
	let trousers = [];
	let shoes = [];

	let lastShirt = shirts.length > 0 ? 1 : 0;
	let lastTrouser = trousers.length > 0 ? 1 : 0;
	let lastShoe = shoes.length > 0 ? 1 : 0;

	$('#face').attr("max", maxFaces);
	$('#hair').attr("max", maxHair);

	$('#shirtlabel').text(`${shirts.length === 0 ? '0' : '1'}/${shirts.length}`);
	$('#pantslabel').text(`${trousers.length === 0 ? '0' : '1'}/${trousers.length}`);
	$('#shoeslabel').text(`${trousers.length === 0 ? '0' : '1'}/${shoes.length}`);

	const setShirts = (shirtsArray) => {
		shirts = shirtsArray;
		$('#shirtlabel').text(`${shirts.length === 0 ? '0' : '1'}/${shirts.length}`);
		lastShirt = 1;
	}

	const setPants = (pantsArray) => {
		trousers = pantsArray;
		$('#pantslabel').text(`${trousers.length === 0 ? '0' : '1'}/${trousers.length}`);
	}

	const setShoes = (shoesArray) => {
		shoes = shoesArray;
		$('#shoeslabel').text(`${trousers.length === 0 ? '0' : '1'}/${shoes.length}`);
	}

	setShirts(["Shirt 1", "Shirt 2", "Shirt 3", "Shirt 4"]);
	console.log("LASTSHIRT LENGTH IS " + lastShirt);

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
	});
});