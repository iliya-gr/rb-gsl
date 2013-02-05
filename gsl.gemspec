# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'gsl/version'

Gem::Specification.new do |gem|
  gem.name              = "gsl"
  gem.version           = GSL::VERSION
  gem.authors           = ['Yoshiki Tsunesada', 'David MacMahon']
  gem.email             = ['y-tsunesada@mm.em-net.ne.jp']
  gem.description       = %q{Ruby/GSL is a Ruby interface to the GNU Scientific Library, for numerical computing with Ruby}
  gem.summary           = %q{Ruby interface to GNU Scientific Library}
  gem.homepage          = 'http://rb-gsl.rubyforge.org/'
  gem.rubyforge_project = 'rb-gsl' 

  gem.files             = `git ls-files`.split($/)
  gem.executables       = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files        = gem.files.grep(%r{^(tests|spec|features)/})
  gem.require_paths     = ["lib"]

  gem.required_ruby_version = '>= 1.8.1'
  gem.requirements << 'GSL (http://www.gnu.org/software/gsl/)'
  gem.add_dependency  'narray', '>= 0.5.9'

  gem.extra_rdoc_files = `git ls-files rdoc`.split($/)

  gem.extensions = %w[ext/extconf.rb]
end