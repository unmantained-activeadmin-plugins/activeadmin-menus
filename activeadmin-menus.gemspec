$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_admin/menus/version"

Gem::Specification.new do |s|
  s.name        = "activeadmin-menus"
  s.version     = ActiveAdmin::Menus::VERSION
  s.authors     = ["Stefano Verna"]
  s.email       = ["stefano.verna@gmail.com"]
  s.homepage    = "https://github.com/stefanoverna/activeadmin-menus"
  s.summary     = "ActiveadminMenus."
  s.description = "ActiveadminMenus."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "README.md"]

  s.add_dependency "ancestry"
  s.add_dependency "activeadmin"
  s.add_dependency "activeadmin-sortable-tree"
  s.add_dependency "activeadmin-globalize"
end

