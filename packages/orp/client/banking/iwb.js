let timerCount = 0;
let currentDiv = null;

//let inHand = 0;
let inBank = 0;

/*const lackOfBankError = `<div class="field"><div class="control" style="margin-bottom: 12px;"><div class="notification is-danger"><button class="delete" id="lackOfBank"></button>You don't have enough in your bank to withdraw this amount!</div></div></div>`;
const lackOfHandError = `<div class="field"><div class="control" style="margin-bottom: 12px;"><div class="notification is-danger"><button class="delete" id="lackOfHand"></button>You don't have enough in hand to deposit this amount!</div></div></div></div>`;
const mustEnterNumberError = (deposit) => `<div class="field"><div class="control" style="margin-bottom: 12px;"><div class="notification is-danger"><button class="delete" id="lackOfHand"></button>You must enter in a number to ${deposit ? 'deposit' : 'withdraw'}.</div></div></div></div>`;*/

const numbersWithCommas = (x) => x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");

const show = (hand, bank, statements) => {
	//inHand = hand;
	inBank = bank;

	$('#currentbalance').text(`$${numbersWithCommas(bank)}`);
	$('#statement-log').html("");
	
	statements.forEach((statement) => {
		console.log(statement);
		$('#statement-log').append(`<div class="columns"><div class="column">${statement.purchase}</div><div class="column">${statement.moneyin > 0 ? `$${statement.moneyin}` : ''}</div><div class="column">${statement.moneyout > 0 ? `-$${statement.moneyout}` : ''}</div></div>`);
	});

	$('#loading').show();
	timerCount += 1;
	
	let interval = setInterval(() => {
		console.log(timerCount);
		timerCount += 1;
		if (timerCount === 6) {
			$('#loading').hide();
			$('#atm').show();

			currentDiv = $('#atm');
			clearInterval(interval);
		} else {
			$('.iwb-pinbox').append("*");
		}
	}, 600);
}

const hide = () => {
	if (currentDiv === null) return;
	currentDiv.hide();
	currentDiv = null;
}

const setBank = (amount) => {
	amount < 0 ? inBank -= (amount / -1) : inBank += amount;
	$('#currentbalance').text(`$${numbersWithCommas(inBank)}`);
};

/*const setHand = (amount) => {
	amount < 0 ? inHand -= (amount / -1) : inHand += amount;
};*/

const transactionSuccessful = () => {
	hide();
	$('#thankyou').show();
	setTimeout(() => {
		CallEvent("iwb:hidegui");
	}, 4000);
};

$(document).ready(() => {
	$('#withdrawamount').numeric();
	$('#depositamount').numeric();

	CallEvent("iwb:ready");
	/*show(0, 1, [{
		purchase: "Refund from Ottos Autos",
		in: 100000,
		out: 0
	},
	{
		purchase: "Multiple items from Onset Gas Station",
		in: 0,
		out: 26.79
	}]);*/

	$('#close').on('click', (e) => {
		if (currentDiv === null) return;
		CallEvent("iwb:hidegui");
	});

	$('#withdraw-button').on('click', (e) => {
		e.preventDefault();
		currentDiv = $('#withdraw');

		$('#atm').hide();
		$('#withdraw').show();
	});

	$('#deposit-button').on('click', (e) => {
		e.preventDefault();
		currentDiv = $('#deposit');

		$('#atm').hide();
		$('#deposit').show();
	});

	$('#backdeposit').on('click', (e) => {
		e.preventDefault();
		$('#deposit').hide();
		$('#atm').show();
		currentDiv = $('#atm');
	});

	$('#backwithdraw').on('click', (e) => {
		e.preventDefault();
		$('#withdraw').hide();
		$('#atm').show();
		currentDiv = $('#atm');
	});

	$('#withdrawother-button').on('click', (e) => {
		e.preventDefault();
		$('#withdraw').hide();
		$('#withdrawother').show();
		currentDiv = $('#withdrawother');
	});

	$('#backwithdrawother').on('click', (e) => {
		e.preventDefault();
		$('#withdrawother').hide();
		$('#withdraw').show();
		currentDiv = $('#withdraw');
	});

	$('#statement-button').on('click', (e) => {
		e.preventDefault();
		currentDiv.hide();
		currentDiv = $('#statement');
		$('#statement').show()
	});

	$('#backstatement').on('click', (e) => {
		e.preventDefault();
		currentDiv.hide();
		currentDiv = $('#atm');
		$('#atm').show();
	});

	$('#10, #100, #20, #500, #50, button.button#withdrawother').on('click', function (e) {
		let amount;
		if ($(this).attr("id") !== "withdrawother" && currentDiv.attr("id") !== "withdrawother") {
			amount = parseInt($(this).attr("id"));
		} else {
			amount = parseInt($('#withdrawamount').val());
		}

		CallEvent("iwb:withdraw", isNaN(amount) ? null : amount);

		/*if (isNaN(amount)) {
			if (currentDiv.attr("id") === "withdrawother") {
				$('#withdrawerror2').html(mustEnterNumberError(false));

				$('button.delete#lackOfHand').on('click', (e) => {
					e.preventDefault();
					$('#withdrawerror2').html("");
					$('button.delete#lackOfHand').off();
				});
	
				setTimeout(() => {
					console.log($('#withdrawerror'));
					if ($('#withdrawerror2').html() === "") return console.log("already closed");
					$('#withdrawerror2').html("");
					$('button.delete#lackOfHand').off();
				}, 5000);
			} else {
				$('#withdrawerror').html(mustEnterNumberError(false));

				$('button.delete#lackOfHand').on('click', (e) => {
					e.preventDefault();
					$('#withdrawerror').html("");
					$('button.delete#lackOfHand').off();
				});
	
				setTimeout(() => {
					console.log($('#withdrawerror'));
					if ($('#withdrawerror').html() === "") return console.log("already closed");
					$('#withdrawerror').html("");
					$('button.delete#lackOfHand').off();
				}, 5000);
			}
		} else {
			if (amount <= inBank) {
				setBank(-amount);
				setHand(amount);

				console.log(currentDiv + " this is the currentDiv, and it should be withdraw.");
				// CallEvent here.
	
				currentDiv.hide();
				$('#thankyou').show();
				setTimeout(() => {
					// CallEvent to hide
				}, 4000);
			} else {
				if (currentDiv.attr("id") === "withdrawother") {
					$("#withdrawerror2").html(lackOfBankError);
		
					$('button.delete#lackOfBank').on('click', (e) => {
						e.preventDefault();
						$('#withdrawerror2').html("");
						$('button.delete#lackOfBank').off();
					});
		
					setTimeout(() => {
						console.log($('#withdrawerror2'));
						if ($('#withdrawerror2').html() === "") return console.log("already closed");
						$('#withdrawerror2').html("");
						$('button.delete#lackOfBank').off();
					}, 5000);
				} else {
					$("#withdrawerror").html(lackOfBankError);
		
					$('button.delete#lackOfBank').on('click', (e) => {
						e.preventDefault();
						$('#withdrawerror').html("");
						$('button.delete#lackOfBank').off();
					});
		
					setTimeout(() => {
						console.log($('#withdrawerror'));
						if ($('#withdrawerror').html() === "") return console.log("already closed");
						$('#withdrawerror').html("");
						$('button.delete#lackOfBank').off();
					}, 5000);
				}
			}
		}*/
	});

	$('button.button.is-primary.is-large#depositother').on('click', (e) => {
		let amount = parseInt($('#depositamount').val());
		CallEvent("iwb:deposit", isNaN(amount) ? null : amount);

		/*if (isNaN(amount)) {
			$("#depositerror").html(mustEnterNumberError(false));

			$('button.delete#lackOfHand').on('click', (e) => {
				e.preventDefault();
				$('#depositerror').html("");
				$('button.delete#lackOfHand').off();
			});

			setTimeout(() => {
				console.log($('#depositerror'));
				if ($('#depositerror').html() === "") return console.log("already closed");
				$('#depositerror').html("");
				$('button.delete#lackOfHand').off();
			}, 5000);
		} else {
			if (inHand >= amount) {
				setBank(amount);
				setHand(-amount);

				//console.log(currentDiv + " this is the currentDiv, and it should be withdraw.");
				// CallEvent here.
	
				currentDiv.hide();
				$('#thankyou').show();
				setTimeout(() => {
					// CallEvent to hide
				}, 4000);
			} else {
				if (currentDiv.attr("id") === "withdrawother") {
					$("#withdrawerror2").html(lackOfBankError);
		
					$('button.delete#lackOfBank').on('click', (e) => {
						e.preventDefault();
						$('#withdrawerror2').html("");
						$('button.delete#lackOfBank').off();
					});
		
					setTimeout(() => {
						console.log($('#withdrawerror2'));
						if ($('#withdrawerror2').html() === "") return console.log("already closed");
						$('#withdrawerror2').html("");
						$('button.delete#lackOfBank').off();
					}, 5000);
				} else {
					$("#withdrawerror").html(lackOfBankError);
		
					$('button.delete#lackOfBank').on('click', (e) => {
						e.preventDefault();
						$('#withdrawerror').html("");
						$('button.delete#lackOfBank').off();
					});
		
					setTimeout(() => {
						console.log($('#withdrawerror'));
						if ($('#withdrawerror').html() === "") return console.log("already closed");
						$('#withdrawerror').html("");
						$('button.delete#lackOfBank').off();
					}, 5000);
				}
			}
		}*/
	});
});