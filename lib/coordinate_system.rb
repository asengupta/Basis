require 'ranges'
require 'ruby-processing'
require 'hash_vector'
require 'matrix_extensions'

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
	attr_accessor :x_basis_vector, :y_basis_vector, :basis_matrix

	def self.standard(x_range, y_range, artist, labels = {:x => 'x', :y => 'y'})
		x_basis_vector = {:x => 1.0, :y => 0.0, :label => labels[:x]}
		y_basis_vector = {:x => 0.0, :y => 1.0, :label => labels[:y]}

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
		@basis_transform = Matrix.rows(transform)
		@basis_matrix = Matrix.rows(
				[
					[@x_basis_vector[:x],@y_basis_vector[:x]],
					[@x_basis_vector[:y],@y_basis_vector[:y]]
				])

		@inverse_basis = @basis_matrix.inverse
		@standard_transform = @basis_matrix*@basis_transform*@inverse_basis
	end

	def tick_vectors
		{
			:x_tick_vector => (rotation(-90)*@x_basis_vector).as_hash,
			:y_tick_vector => (rotation(90)*@y_basis_vector).as_hash
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
		Matrix.rows([[cos(radians), -sin(radians)],[sin(radians),cos(radians)]])
	end


	def standard_basis(point)
		standard_point = @basis_matrix* point
		r = @standard_transform * standard_point
		{:x => r[0,0], :y => r[1,0]}
	end

	def original(onscreen_point)
		p1 = @standard_transform.inverse * onscreen_point
		o = @basis_matrix.inverse* p1
		{:x => o[0][0], :y => o[1][0]}
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
			hair_end = @y_basis_vector*@y_axis.range.interval + standard_basis(raw_origin)
			lines << {:from => hair_origin, :to => hair_end}
		end
		@y_axis.range.run(y_basis_interval) do |i,v|
			raw_origin = {:x => @x_axis.range.minimum, :y => i}
			hair_origin = standard_basis(raw_origin)
			hair_end = @x_basis_vector*@x_axis.range.interval + standard_basis(raw_origin)
			lines << {:from => hair_origin, :to => hair_end}
		end
		lines
	end
end

