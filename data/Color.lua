require("class")
Color = class(function(self, r, g, b, a)
	self.r = r
	self.g = g
	self.b = b
	self.a = a
end)

function Color.lerp(from, to, p)
	return Color(
		from.r+(to.r-from.r)*p,
		from.g+(to.g-from.g)*p,
		from.b+(to.b-from.b)*p,
		from.a+(to.a-from.a)*p);
end

function Color:clone()
	return Color(self.r, self.g, self.b, self.a)
end

function Color.set(color)
	love.graphics.setColor(color.r, color.g, color.b, color.a)
end