class LegendBox
	def initialize(artist, top_left = {:x => 20, :y => 20})
		@x = top_left[:x]
		@y = top_left[:y]
		@artist = artist
	end

	def draw(legend)
		@artist.rect(@x,@y,10,10)
		@artist.text(legend.strip == '' ? '[Unknown]' : legend, @x + 50, @y)
		@y += 15
	end
end

