require 'matrix'

class Matrix
	alias_method :multiply, :*
	def *(another)
		return multiply(Matrix.columns([[another[:x], another[:y]]])) if another.kind_of? Hash
		multiply(another)
	end
	
	def as_hash
		{:x => self[0,0], :y => self[1,0]}
	end
end

