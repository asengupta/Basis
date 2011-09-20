spec = Gem::Specification.new do |s| 
  s.name = "basis-processing"
  s.version = "0.4.4"
  s.author = "Avishek Sen Gupta"
  s.email = "avishek.sen.gupta@gmail.com"
  s.homepage = "http://avishek.net/blog"
  s.platform = Gem::Platform::RUBY
  s.summary = "Some description"
  s.files = `git ls-files`.split("\n")
  s.summary = %q{Basis provides a set of classes for easily plotting and transforming arbitrary 2D coordinate systems by specifying their basis vectors in Ruby-Processing.}
  s.description = %q{Basis provides a set of classes for easily plotting and transforming arbitrary 2D coordinate systems by specifying their basis vectors in Ruby-Processing.}
end
