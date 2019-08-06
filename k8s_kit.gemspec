# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','k8s_kit','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'k8s_kit'
  s.version = K8sKit::VERSION
  s.author = 'Your Name Here'
  s.email = 'your@email.address.com'
  s.homepage = 'http://your.website.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.rdoc_options << '--title' << 'k8s_kit' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'k8s_kit'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_runtime_dependency('gli','2.18.1')
end
