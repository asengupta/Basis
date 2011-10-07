module Interactive
	attr :screen, :basis, :index
	def self.included(base)
		base.class_eval do
			alias :old_setup :setup
			def setup
				puts "LoL"
				old_setup
				@index = @screen.build
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
		closest_onscreen_point = @screen.transformed(closest)
		distance = (closest_onscreen_point[:x] - p[:x])**2 + (closest_onscreen_point[:y] - p[:y])**2
		if distance > 14.0
			@points_to_highlight = []
			redraw
			return
		end
		@points_to_highlight = [closest]
		redraw
	end

	def draw
		@screen.join = false
		@old_points ||= []
		@points_to_highlight ||= []
		@old_points.each do |old|
			@screen.plot(old) {|p| @passive_block.call(p) if @passive_block}
		end
		@points_to_highlight.each do |new_rectangle|
			@screen.plot(new_rectangle) {|p| @highlight_block.call(p) if @highlight_block}
		end
		@old_points = @points_to_highlight
	end
end

