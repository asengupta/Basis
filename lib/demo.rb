require 'ranges'
require 'transform'
require 'coordinate_system'
require 'screen'

class Demo < Processing::App
	app = self
	def setup
#		smooth
		background(0,0,0)
		color_mode(RGB, 1.0)
		stroke(1,1,0,1)

		points = []
		100.times {points << {:x => random(200), :y => random(300)}}

		x_basis_vector = {:x => 1.0, :y => 0.0}
		y_basis_vector = {:x => 0.0, :y => 1.0}

		x_range = ContinuousRange.new({:minimum => 0, :maximum => 200})
		y_range = ContinuousRange.new({:minimum => 0, :maximum => 300})

		basis = CoordinateSystem.new(Axis.new(x_basis_vector,x_range), Axis.new(y_basis_vector,y_range), [[4,0],[0,2]], self)
		screen_transform = SignedTransform.new({:x => 10, :y => -1}, {:x => 300, :y => 900})
		screen = Screen.new(screen_transform, self)
		screen.draw_axes(basis,10,10)
		stroke(1,1,0,1)
		fill(1,1,0)
		points.each do |p|
			screen.plot(p, basis)
		end
	end
	  
	def draw
	end
end

w = 1200
h = 1000

Demo.new(:title => "My Sketch", :width => w, :height => h)

