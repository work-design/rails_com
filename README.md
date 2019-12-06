# RailsCom
Rails 通用基础库

## 功能
* examples: puma, configs etc.
* rails and ruby core extension;
* methods deal rails model/controller/routes etc.
* some helpers, for generator uuid based on time and more;

## Module
* Ruby core extension
* Rails meta information: Controller/Model/Routes
* Rails core extension
  - ActiveStorage sync with url
  - ActiveStorage copy to mirror
* Utils
  - UidHelper
  - TimeHelper
  - Jobber
  - IpHelper
  
### Locals support

```erb
<%= render 'shared/locales' %>
```

## 支持 enum
```yaml
# zh.yml
activerecord:
  enum:
    notification:
      receiver_type:
        User: 全体用户
        Member: 成员
```

```ruby
t.select :receiver_type, options_for_select(Notification.options_i18n(:receiver_type))
```

* Override 
```yaml
activerecord:
  enum:
    notification:
      receiver_type:
        User: 全体用户
        Member: # remain this blank
```

## License
The gem is available as open source under the terms of the [LGPL License](https://opensource.org/licenses/LGPL-3.0).
