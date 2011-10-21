class Array
	def *(other)
		return into2Dx1D(other) if other.kind_of?(Hash)
		return into2Dx2D(other) if other.kind_of?(Array)
		raise "Cannot recognise operand type"
	end

	def into2Dx2D(second)
		[
			[second[0][0]*self[0][0] + second[1][0]*self[0][1], second[0][1]*self[0][0] + second[1][1]*self[0][1]],
			[second[0][0]*self[1][0] + second[1][0]*self[1][1], second[0][1]*self[1][0] + second[1][1]*self[1][1]]
		]
	end

	def into2Dx1D(point)
		{
			:x => self[0][0]*point[:x] + self[0][1]*point[:y], 
			:y => self[1][0]*point[:x] + self[1][1]*point[:y]
		}
	end

	def inverse
		determinant = (self[0][0]*self[1][1] - self[0][1]*self[1][0]).to_f;
		[
			[self[1][1]/determinant, -self[0][1]/determinant],
			[-self[1][0]/determinant, self[0][0]/determinant]
		]
	end
	
	def transpose
		[
			[self[0][0], self[1][0]],
			[self[0][1], self[1][1]]
		]
	end
	
	def minus(other)
		puts self
		[
			[self[0][0] - other[0][0], self[0][1] - other[0][1]],
			[self[1][0] - other[1][0], self[1][1] - other[1][1]]
		]
	end
end


