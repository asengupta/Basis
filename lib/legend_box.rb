class LegendBox
	def initialize(artist)
		@y = 30
		@artist = artist
	end

	def draw(legend)
		@artist.rect(30,@y,10,10)
		@artist.text(legend, 50, @y)
		@y += 15
	end
end

