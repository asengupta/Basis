spec = Gem::Specification.new do |s| 
  s.name = "basis"
  s.version = "0.1"
  s.author = "Avishek Sen Gupta"
  s.email = "avishek.sen.gupta@gmail.com"
  s.homepage = "http://avishek.net/blog"
  s.platform = Gem::Platform::RUBY
  s.summary = "Some description"
  s.files = ['transform.rb', 'ranges.rb', 'coordinate_system.rb', 'matrix_operations.rb', 'screen.rb']
  s.summary = %q{Basis provides a set of classes for easily plotting and transforming arbitrary 2D coordinate systems by specifying their basis vectors in Ruby-Processing.}
  s.description = %q{Basis provides a set of classes for easily plotting and transforming arbitrary 2D coordinate systems by specifying their basis vectors in Ruby-Processing.}
end

