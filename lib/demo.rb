require 'rubygems'

Gem.clear_paths
ENV['GEM_HOME'] = '/home/avishek/jruby/jruby-1.6.4/lib/ruby/gems/1.8'
ENV['GEM_PATH'] = '/home/avishek/jruby/jruby-1.6.4/lib/ruby/gems/1.8'

require 'basis_processing'

class Demo < Processing::App
	app = self
	def setup
		smooth
		no_loop
		background(0,0,0)
		color_mode(RGB, 1.0)
		stroke(1,1,0,1)
		@highlight_block = lambda do |p|
					rect_mode(CENTER)
					stroke(1,0,0)
					fill(1,0,0)
					rect(p[:x], p[:y], 5, 5)
				   end

		@passive_block = lambda do |p|
					rect_mode(CENTER)
					stroke(1,1,0,1)
					fill(1,1,0)
					rect(p[:x], p[:y], 5, 5)
				   end

		points = []
		200.times {|n|points << {:x => n, :y => random(300)}}

		@basis = CoordinateSystem.standard({:minimum => 0, :maximum => 200}, {:minimum => 0, :maximum => 300}, self)
		screen_transform = Transform.new({:x => 3, :y => -2}, {:x => 300, :y => 900})
		@screen = Screen.new(screen_transform, self, @basis)
		@screen.draw_axes(10,10)
		stroke(1,1,0,1)
		fill(1,1,0)
		rect_mode(CENTER)
		points.each do |p|
			@screen.plot(p, :track => true) {|p| rect(p[:x], p[:y], 5, 5)}
		end
	end
	
	def draw
	end
end

w = 1200
h = 1000

Demo.send :include, Interactive
Demo.new(:title => "My Sketch", :width => w, :height => h)

