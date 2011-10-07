class TextOutput
	def notify(point)
		$stdout.print("\r#{point.inspect}")
		$stdout.flush
	end
end

