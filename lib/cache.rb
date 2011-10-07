class Cache
	def initialize(artist)
		@artist = artist
	end

	def refresh
		@artist.save("buffer.jpg")
		@cached_image = @artist.loadImage("buffer.jpg")
		self
	end
	
	def restore
		@artist.image(@cached_image, 0, 0)
		self
	end
end

