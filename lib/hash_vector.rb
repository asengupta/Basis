require 'matrix'

class Hash
	def *(scalar)
		{:x => self[:x] * scalar.to_f, :y => self[:y] * scalar.to_f}
	end
	def +(vector)
		return {:x => self[:x] + vector[:x], :y => self[:y] + vector[:y]} if vector.kind_of? Hash
		{:x => self[:x] + vector[0,0], :y => self[:y] + vector[1,0]}
	end

	def as_matrix
		Matrix.columns([[self[:x], self[:y]]])
	end
end

