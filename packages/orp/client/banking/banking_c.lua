--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic_

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local web = 0

AddEvent("OnPackageStart", function()
	web = CreateWebUI(0, 0, 0, 0, 1, 16)
	SetWebAlignment(web, 0, 0)
	SetWebAnchors(web, 0, 0, 1, 1)
	SetWebURL(web, "http://asset/"..GetPackageName().."/client/banking/iwb.html")
	SetWebVisibility(web, WEB_HIDDEN)
end)

AddEvent("OnPackageStop", function()
	DestroyWebUI(web)
end)

-- Functions

-- Events

AddEvent("iwb:ready", function ()
	AddPlayerChat("Imminent Wealth Bank is now ready!")
end)

AddEvent("iwb:hidegui", function ()
	AddPlayerChat('hidegui called')
	ExecuteWebJS(web, "$('#thankyou').hide();")

	SetWebVisibility(web, WEB_HIDDEN)
	SetIgnoreLookInput(false)
	SetIgnoreMoveInput(false)
	ShowMouseCursor(false)
	SetInputMode(INPUT_GAME)
end)

AddEvent("iwb:deposit", function (amount)
	CallRemoteEvent("iwb:OnClientDeposit", amount)
end)

AddEvent("iwb:withdraw", function (amount)
	CallRemoteEvent("iwb:OnClientWithdraw", amount)
end)

AddRemoteEvent("iwb:opengui", function (hand, bank)
	AddPlayerChat("Opening ATM")

	local statement = {
		{
			purchase = "Refund from Bank of IWB",
			moneyin = 1000,
			moneyout = 0
		},
		{
			purchase = "Chicken from Cock N Bell",
			moneyin = 0,
			moneyout = 15
		}
	} -- Example of how statements should be formed.

	SetWebVisibility(web, WEB_VISIBLE)
	ExecuteWebJS(web, 'show('..bank..', '..json_encode(statement)..');')
	SetIgnoreLookInput(true)
	SetIgnoreMoveInput(true)
	ShowMouseCursor(true)
	SetInputMode(INPUT_GAMEANDUI)
end)

AddRemoteEvent("iwb:OnServerATMAction", function (amount)
	ExecuteWebJS(web, 'setBank('..amount..');')
	ExecuteWebJS(web, 'transactionSuccessful();')
end)