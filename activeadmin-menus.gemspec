$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_admin/menus/version"

Gem::Specification.new do |s|
  s.name        = "activeadmin-menus"
  s.version     = ActiveAdmin::Menus::VERSION
  s.authors     = ["Stefano Verna"]
  s.email       = ["stefano.verna@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ActiveadminMenus."
  s.description = "TODO: Description of ActiveadminMenus."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "ancestry"
  s.add_dependency "activeadmin-sortable-tree"
  s.add_dependency "activeadmin-globalize3"

  s.add_development_dependency "sqlite3"
end

