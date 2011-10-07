require 'rubygems'

Gem.clear_paths
ENV['GEM_HOME'] = '/home/avishek/jruby/jruby-1.6.4/lib/ruby/gems/1.8'
ENV['GEM_PATH'] = '/home/avishek/jruby/jruby-1.6.4/lib/ruby/gems/1.8'

require 'basis_processing'

class Demo < Processing::App
	include Interactive
	app = self
	def setup
		smooth
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

		x_basis_vector = {:x => 1.0, :y => 0.0}
		y_basis_vector = {:x => 0.0, :y => 1.0}

		x_range = ContinuousRange.new({:minimum => 0, :maximum => 200})
		y_range = ContinuousRange.new({:minimum => 0, :maximum => 300})

		@basis = CoordinateSystem.new(Axis.new(x_basis_vector,x_range), Axis.new(y_basis_vector,y_range), [[4,0],[0,2]], self)
		screen_transform = SignedTransform.new({:x => 1, :y => -1}, {:x => 300, :y => 900})
		@screen = Screen.new(screen_transform, self, @basis)
		@screen.join=true
		@screen.draw_axes(10,10)
		stroke(1,1,0,1)
		fill(1,1,0)
		rect_mode(CENTER)
		points.each do |p|
			@screen.plot(p, :track => true) {|p| rect(p[:x], p[:y], 5, 5)}
		end
		@index = @screen.build
	end
end

w = 1200
h = 1000

Demo.new(:title => "My Sketch", :width => w, :height => h)

