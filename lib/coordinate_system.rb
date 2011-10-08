require 'ranges'
require 'ruby-processing'
require 'matrix_operations'
require 'hash_vector'

include Math

class Axis
	attr_accessor :basis_vector, :range
	def initialize(basis_vector, range)
		@basis_vector = basis_vector
		@range = range
	end
end

class CoordinateSystem
	CROSSHAIR_SCALE = 5000
	UNIT_TRANSFORM = [[1,0],[0,1]]

	include MatrixOperations
	attr_accessor :x_basis_vector, :y_basis_vector

	def self.standard(x_range, y_range, artist)
		x_basis_vector = {:x => 1.0, :y => 0.0}
		y_basis_vector = {:x => 0.0, :y => 1.0}

		x_range = ContinuousRange.new(x_range)
		y_range = ContinuousRange.new(y_range)

		CoordinateSystem.new(Axis.new(x_basis_vector,x_range), Axis.new(y_basis_vector,y_range), artist, UNIT_TRANSFORM)
	end
	
	def initialize(x_axis, y_axis, artist, transform = UNIT_TRANSFORM)
		@artist = artist
		@x_axis = x_axis
		@y_axis = y_axis
		@x_basis_vector = x_axis.basis_vector
		@y_basis_vector = y_axis.basis_vector
		@basis_transform = transform
		@basis_matrix = 
				[
					[@x_basis_vector[:x],@y_basis_vector[:x]],
					[@x_basis_vector[:y],@y_basis_vector[:y]]
				]

		d = @basis_matrix[0][0]*@basis_matrix[1][1] - @basis_matrix[0][1]*@basis_matrix[1][0]
		@inverse_basis = 
				[
					[@basis_matrix[1][1]/d, -@basis_matrix[0][1]/d],
					[-@basis_matrix[1][0]/d, @basis_matrix[0][0]/d]
				]

		@standard_transform = MatrixOperations::into2Dx2D(MatrixOperations::into2Dx2D(@basis_matrix, @basis_transform), @inverse_basis)
	end

	def tick_vectors
		{
			:x_tick_vector => MatrixOperations::into2Dx1D(rotation(-90),@x_basis_vector),
			:y_tick_vector => MatrixOperations::into2Dx1D(rotation(90),@y_basis_vector)
		}
	end

	def x_ticks(x_basis_interval)
		lines = []
		t_vectors = tick_vectors
		@x_axis.range.run(x_basis_interval) do |i,v|
			tick_origin = standard_basis({:x => i, :y => 0})
			lines << {:label => v, :from => tick_origin, :to => tick_origin + t_vectors[:x_tick_vector]}
		end
		lines
	end

	def y_ticks(y_basis_interval)
		lines = []
		t_vectors = tick_vectors
		@y_axis.range.run(y_basis_interval) do |i,v|
			tick_origin = standard_basis({:x => 0, :y => i})
			lines << {:label => v, :from => tick_origin, :to => tick_origin + t_vectors[:y_tick_vector]}
		end
		lines
	end

	def rotation(angle)
		radians = angle * PI/180.0
		[[cos(radians), -sin(radians)],[sin(radians),cos(radians)]]
	end


	def standard_basis(point)
		basis_matrix =
		[
			[@x_basis_vector[:x], @y_basis_vector[:x]],
			[@x_basis_vector[:y], @y_basis_vector[:y]]
		]
		standard_point = MatrixOperations::into2Dx1D(basis_matrix, point)

		MatrixOperations::into2Dx1D(@standard_transform, standard_point)
	end

	def original(onscreen_point)
		p1 = MatrixOperations::into2Dx1D(MatrixOperations::inverse2D(@standard_transform), onscreen_point)
		basis_matrix =
		[
			[@x_basis_vector[:x], @y_basis_vector[:x]],
			[@x_basis_vector[:y], @y_basis_vector[:y]]
		]
		MatrixOperations::into2Dx1D(MatrixOperations::inverse2D(basis_matrix), p1)
	end
	
	def crosshairs(p)
		crosshair_x_p1 = (@x_basis_vector*CROSSHAIR_SCALE) + standard_basis(p)
		crosshair_x_p2 = (@x_basis_vector*(-CROSSHAIR_SCALE)) + standard_basis(p)
		crosshair_y_p1 = (@y_basis_vector*CROSSHAIR_SCALE) + standard_basis(p)
		crosshair_y_p2 = (@y_basis_vector*(-CROSSHAIR_SCALE)) + standard_basis(p)
		[{:from => crosshair_x_p1, :to => crosshair_x_p2}, {:from => crosshair_y_p1, :to => crosshair_y_p2}]
	end
	
	def grid_lines(x_basis_interval, y_basis_interval)
		lines = []
		@x_axis.range.run(x_basis_interval) do |i,v|
			raw_origin = {:x => i, :y => @y_axis.range.minimum}
			hair_origin = standard_basis(raw_origin)
			hair_end = standard_basis((@y_basis_vector*@y_axis.range.interval) + raw_origin)
			lines << {:from => hair_origin, :to => hair_end}
		end
		@y_axis.range.run(y_basis_interval) do |i,v|
			raw_origin = {:x => @x_axis.range.minimum, :y => i}
			hair_origin = standard_basis(raw_origin)
			hair_end = standard_basis((@x_basis_vector*@x_axis.range.interval) + raw_origin)
			lines << {:from => hair_origin, :to => hair_end}
		end
		lines
	end
end

