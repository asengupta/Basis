module Interactive
	attr :screen, :basis

	def mouseMoved(p)
		p = {:x => p.getX(), :y => p.getY()}
		@old_points ||= []
		@points_to_highlight = []
		index = @screen.points.index do |i|
			onscreen_point = @screen.transformed(i)
			(p[:x] - onscreen_point[:x]).abs < 4.0 && (p[:y] - onscreen_point[:y]).abs < 4.0
		end
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

