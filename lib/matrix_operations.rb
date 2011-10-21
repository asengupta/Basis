class Array
	def *(other)
		return into2Dx1D(other) if other.kind_of?(Hash)
		if self[0].count != other.count
			raise "Incompatible matrix structure."
		end
		result = []
		
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
		det = self.determinant
		[
			[self[1][1]/det, -self[0][1]/det],
			[-self[1][0]/det, self[0][0]/det]
		]
	end
	
	def determinant
		(self[0][0]*self[1][1] - self[0][1]*self[1][0]).to_f;
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
	
	def value
		self[0][0]
	end
end


