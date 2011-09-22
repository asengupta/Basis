module MatrixOperations
	def MatrixOperations.into2Dx2D(first, second)
		[
			[second[0][0]*first[0][0] + second[1][0]*first[0][1], second[0][1]*first[0][0] + second[1][1]*first[0][1]],
			[second[0][0]*first[1][0] + second[1][0]*first[1][1], second[0][1]*first[1][0] + second[1][1]*first[1][1]]
		]
	end

	def MatrixOperations.into2Dx1D(transform, point)
		{
			:x => transform[0][0]*point[:x] + transform[0][1]*point[:y], 
			:y => transform[1][0]*point[:x] + transform[1][1]*point[:y]
		}
	end

	def MatrixOperations.inverse2D(m)
		determinant = (m[0][0]*m[1][1] - m[0][1]*m[1][0]).to_f;
		[
			[m[1][1]/determinant, -m[0][1]/determinant],
			[-m[1][0]/determinant, m[0][0]/determinant]
		]
	end
end

