require 'ranges'
require 'transform'
require 'coordinate_system'

class Demo < Processing::App
	app = self
	def setup
		@screen_height = 900
		@width = width
		@height = height
		@screen_transform = SignedTransform.new({:x => 10, :y => -1}, {:x => 400, :y => @screen_height})
		frame_rate(30)
		smooth
		background(0,0,0)
		color_mode(RGB, 1.0)

		points = []

		100.times {points << {:x => random(200), :y => random(300)}}

		@x_unit_vector = {:x => 1.0, :y => 1.0}
		@y_unit_vector = {:x => -1.0, :y => 1.0}

		x_range = ContinuousRange.new({:minimum => 0, :maximum => 200})
		y_range = ContinuousRange.new({:minimum => 0, :maximum => 300})

		@c = CoordinateSystem.new(Axis.new(@x_unit_vector,x_range), Axis.new(@y_unit_vector,y_range), [[2,0],[0,2]], self)
		@c.draw_axes(@screen_transform)
		stroke(1,1,0,1)
		fill(1,1,0)
		points.each do |bin|
			standard_point = @c.standard_basis(bin)
			p = @screen_transform.apply(standard_point)
			ellipse(p[:x], p[:y], 5, 5)
		end
	end
	  

	def draw
	end
end

w = 1200
h = 1000

Demo.new(:title => "My Sketch", :width => w, :height => h)

