module Interactive
	attr :screen, :basis

	def mouseMoved(p)
		p = {:x => p.getX(), :y => p.getY()}
		@old_points ||= []
		@points_to_highlight = []
		original_point = @screen.original(p)
		original_point = {:x => original_point[:x], :y => original_point[:y]}
		index = @screen.points.index {|i| (i[:x] - original_point[:x]).abs < 1.0 && (i[:y] - original_point[:y]).abs < 1.0}
		return if index == nil
		@points_to_highlight = [{:x => @screen.points[index][:x], :y => @screen.points[index][:y]}]
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

