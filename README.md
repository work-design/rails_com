# RailsCom
Rails Common engine, with many sugars!

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'rails_com'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install rails_com
```
## Features
* examples: puma, configs etc.
* rails and ruby core extension;
* methods deal rails model/controller/routes etc.
* some helpers, for generator uuid based on time and more;

### View: add link
```erb
<%= link_to locales_path, class: 'item', remote: true, id: 'locales_show' do %>
  <i class="translate icon"></i>
<% end %>
```


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).