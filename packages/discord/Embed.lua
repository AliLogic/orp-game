Embed = {colour = '#FFFFFF', title = '', description = '', fields = {}}

function Embed:New()
	local object = {}

	setmetatable(object, self)
	self.__index = self

	return object
end

function Embed:SetColour(colour)
	self.colour = colour or '#FFFFFF'
end

function Embed:SetTitle(title)
	self.title = title
end

function Embed:SetDescription(description)
	self.description = description
end

function Embed:AddField(field, value, inline)
	table.insert(self.fields, {field = field, value = value, inline = inline or false})
end