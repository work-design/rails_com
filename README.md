# RailsCom
Rails 通用基础库

## 功能
* 
* rails and ruby core extension;
* methods deal rails model/controller/routes etc.
* some helpers, for generator uuid based on time and more;

## 模块
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
* 支持通过 ACME 自动申请及更新 SSL 证书

## 例子 
[examples](examples)
* puma
* configs

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

## 注意
* 仅支持 webpacker, 不再支持 sprockets

## 版权
采用 MIT 版权协议 [MIT](https://opensource.org/licenses/MIT).
