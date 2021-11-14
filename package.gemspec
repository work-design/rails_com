Gem::Specification.new do |s|
  s.name = 'rails_com'
  s.version = '1.3.0'
  s.authors = ['qinmingyuan']
  s.email = ['mingyuan0715@foxmail.com']
  s.homepage = 'https://github.com/work-design/rails_com'
  s.summary = 'Rails Engine with common utils'
  s.description = 'Common utils for Rails Application'
  s.license = 'MIT'

  s.files = Dir[
    '{app,config,db,lib}/**/*',
    'Rakefile',
    'LICENSE',
    'README.md'
  ]
  s.require_paths = ['lib']

  s.add_dependency 'rails', '>= 6.1'
  s.add_dependency 'jbuilder'
  s.add_dependency 'rails_extend'
  s.add_dependency 'httpx', '~> 0.16'
  s.add_dependency 'http-form_data', '~> 2.3'
  s.add_dependency 'default_where', '~> 2.2'
  s.add_dependency 'kaminari'
  s.add_dependency 'closure_tree', '>= 7.3'
  s.add_dependency 'acts_as_list', '>= 1.0'
  s.add_dependency 'acme-client'
  s.add_dependency 'turbo-rails'
  s.add_dependency 'net-smtp'
  s.add_dependency 'net-pop'
end
