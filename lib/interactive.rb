require 'cache'

module Interactive
	attr_accessor :screen, :basis, :index
	def self.included(base)
		base.class_eval do
			alias :old_setup :setup
			alias :old_draw :draw
			
			def setup
				old_setup
				@cache = Cache.new(self).refresh
				@index = @screen.build
			end
			
			def draw
				old_draw
				@screen.join = false
				@old_points ||= []
				@points_to_highlight ||= []
				@cache.restore if @old_points.count > 0
				@points_to_highlight.each do |p|
					@highlight_block.call(p[:original], p[:mapped], @screen) if @highlight_block
					@screen.draw_crosshairs(p[:original])
				end
				@old_points = @points_to_highlight
			end
		end
	end

	def mouseMoved(p)
		p = {:x => p.getX(), :y => p.getY()}
		@old_points ||= []
		@points_to_highlight ||= []
		original_point = @screen.original(p)
		closest_point = @index.nearest([original_point[:x], original_point[:y]])
		closest = @screen.points[closest_point[:id]]
		return if closest.nil?
		closest_onscreen_point = @screen.transformed(closest)
		distance = (closest_onscreen_point[:x] - p[:x])**2 + (closest_onscreen_point[:y] - p[:y])**2
		if distance > 14.0
			@points_to_highlight = []
			redraw
			return
		end
		@points_to_highlight = [{:original => closest, :mapped => closest_onscreen_point}]
		@screen.write(closest)
		redraw
	end

end

