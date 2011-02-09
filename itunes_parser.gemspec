Gem::Specification.new do |s|
  s.name        = 'itunes_parser'
  s.version     = File.read("lib/itunes_parser.rb")[/VERSION = ['"](.*)['"]/, 1]

  s.authors     = ['Pete Higgins']
  s.email       = ['pete@peterhiggins.org']
  s.homepage    = 'http://github.com/phiggins/itunes_parser'
  s.summary     = 'iTunes XML parser'
  s.description = 'a fast iTunes XML parser based on Nokogiri'

  s.add_dependency "nokogiri", "~> 1.4"
  s.add_development_dependency "rspec", "~> 2"

  s.files       = %w[ Rakefile README.md itunes_parser.gemspec ]
  s.files       += %w[ lib examples spec ].map {|d| Dir["#{d}/**/*.rb"] }.flatten
end
