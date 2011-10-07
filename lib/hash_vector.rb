class Hash
	def *(scalar)
		{:x => self[:x] * scalar.to_f, :y => self[:y] * scalar.to_f}
	end
	def +(vector)
		{:x => self[:x] + vector[:x], :y => self[:y] + vector[:y]}
	end
end

