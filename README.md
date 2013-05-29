# ActiveAdmin Menus

```
WARNING - this is a WIP, use at your own risk!
```

## Installation

```ruby
gem 'activeadmin-menus', github: "stefanoverna/activeadmin-menus", branch: "master"
```

```
rails g active_admin:menus:install
rake db:migrate
```

## Basic usage

Edit `app/admin/menus.rb` to your needs:

```ruby
ActiveAdmin::Menus.configure do |c|
  # Areas are specific parts of a page layout, you can add many of them
  c.add_area :main_navigation
  
  c.add_predefined_item :home do |i|
    # Specify how to render the menu item
    i.renderer = lambda { link_to 'Home', root_path }
  end
  
  c.add_resource_class Page do |i|
    # Specify how to render the menu item
    i.renderer = lambda { |page| link_to page.title, page }
  end
end
```

## Advanced usage

### Areas

```ruby
c.add_area :header do |a|
  # This wraps lists of sibling items
  # `content` is the list of sibling items
  # `item` is the parent item (when rendering the root menu items, it will be nil)
  a.list_wrapper = lambda { |content, item| content_tag(:ul, content) }

  # This wraps the single menu item
  a.item_wrapper = lambda { |content, active, item| content_tag(:li, content) }

  # This specifies how to render custom (i.e. Label + URL) menu items
  a.custom_item_renderer = lambda { |item| link_to(item.label, item.url) }
end
```

### Resource items

```ruby
c.add_resource_class Page do |i|
  # This specifies the method to call to retreive the list of resources that 
  # can be used to build menu items. Lambdas are also allowed
  # i.collection = lambda { Page.all }
  i.collection = :all

  # This specifies how to render a resource into the menu.
  i.renderer = lambda { |page, active, item| link_to page.title, page }

  # This specifies if the menu item is active for the current request
  i.active_if = lambda { |page, item| controller_name == "pages" && action_name == "show" }
end
```

### Predefined menu items

```ruby
c.add_predefined_item :home do |i|
  # This specifies how to render the item into the menu
  i.renderer = lambda { |active, item| link_to active, 'Home', root_path }

  # This specifies if the menu item is active for the current request
  i.active_if = lambda { |item| action_name == "homepage" }
end
```

## Available/overridable helpers

See `lib/active_admin/menus/helpers.rb` for the complete list of overridable
helpers.

### `active_menu_item_attributes(active)`

This specifies the standard way to define an active menu item. Defaults to 
`{class: 'active'}`

### `active_link_to(active, label, url)`

Default renderers use this method to produce links. Active links will use
`active_menu_item_attributes`.


### `render_menu(area)`

This renders a complete menu for the specified area.

