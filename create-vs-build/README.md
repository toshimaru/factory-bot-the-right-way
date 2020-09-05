## build_stubbed

```rb
class User < ActiveRecord::Base
  def new?
    created_at > 1.day.ago
  end
end
```

```rb
> u = FactoryBot.build_stubbed(:user, created_at: 1.day.ago)
> u.new?
=> false

> u = FactoryBot.build_stubbed(:user)
> u.new?
=> true
```
