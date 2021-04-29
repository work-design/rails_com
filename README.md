# RailsCom
Rails 通用基础库，对 Rails 的各个组件进行了扩展。

## 功能模块
* 对 Ruby 的核心类进行扩展，[链接](lib/rails_com/core)
* 对 Rails 的核心类进行扩展
  * ActiveStorage：[链接](lib/rails_com/active_storage) 
    * 通过 url 同步文件；
    * 将文件复制到镜像服务器；
* 支持通过 ACME 自动申请及更新 SSL 证书
* Rails 元信息 : Controller/Model/Routes
  
### 工具类
  * UidHelper：基于时间生成 UUID，精确到微秒
  * TimeHelper
  * Jobber
  * IpHelper

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
* 仅支持 [webpacker](https://github.com/rails/webpacker)，不再支持 [sprockets](https://github.com/rails/sprockets)

## 版权
遵循 [MIT](https://opensource.org/licenses/MIT) 版权协议
