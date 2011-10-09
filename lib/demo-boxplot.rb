require 'rubygems'
Gem.clear_paths
ENV['GEM_HOME'] = '/home/avishek/jruby/jruby-1.6.4/lib/ruby/gems/1.8'
ENV['GEM_PATH'] = '/home/avishek/jruby/jruby-1.6.4/lib/ruby/gems/1.8'

require 'basis_processing'

class BoxPlotSketch < Processing::App
	def setup
		@screen_height = 900
		@width = width
		@height = height
		no_loop
		smooth
		background(0,0,0)
		color_mode(HSB, 1.0)
		box = {:minimum => 20, :maximum => 70, :q1 => 30, :q2 => 40, :q3 => 50}
		@x_unit_vector = {:x => 1.0, :y => 0.15}
		@y_unit_vector = {:x => 0.2, :y => 1.0}
		@screen_transform = Transform.new({:x => 5.0, :y => -5.0}, {:x => @width/2, :y => @screen_height})
		x_range = ContinuousRange.new({:minimum => 0.0, :maximum => 80.0})
		y_range = ContinuousRange.new({:minimum => 0.0, :maximum => 80.0})
		@c = CoordinateSystem.new(Axis.new(@x_unit_vector,x_range), Axis.new(@y_unit_vector,y_range), self, [[1,0],[0,1]])
		@screen = Screen.new(@screen_transform, self, @c)
		stroke(0.3,1,1)
		no_fill
		position = 20
		box_width = 20
		whisker_width = 10
		@screen.plot(box) do |o,s|
			s.in_basis do
				rect(position - box_width/2, o[:q1], box_width, o[:q2] - o[:q1])
				rect(position - box_width/2, o[:q2], box_width, o[:q3] - o[:q2])
				line(position, o[:q3], position, o[:maximum])
				line(position, o[:q1], position, o[:minimum])
				line(position - whisker_width/2, o[:minimum], position + whisker_width/2, o[:minimum])
				line(position - whisker_width/2, o[:maximum], position + whisker_width/2, o[:maximum])
			end
		end
		
		@screen.draw_axes(10, 4)
	end
end

h = 950
w = 1000
BoxPlotSketch.new(:title => "Box Plot", :width => w, :height => h)

