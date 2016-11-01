# Serializr

Serializr is a library for creating canonical JSON representation of objects
for your RESTful APIs.

Think of the serializers as the view layer of your application. They are not
the only JSON representation of an object, but they are _the_ representation
you wanna show to the API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'serializr'
```

## Usage

Using the serializr library is pretty simple. To generate your first
serializer, execute:

    $ rails generate serializr User id name email

The output should hint that the generator created two files:

    create  app/serializers/application_serializer.rb
    create  app/serializers/user_serializer.rb

The `app/serializers/user_serializer.rb` file should contain:

```ruby
class UserSerializer < ApplicationSerializer
  attributes :id, :name, :email
end
```

This says: expect the object to be serialized to respond to `#id`, `#name` and
`#email` and show the resulting JSON as:

```json
{
  "id": 42,
  "name": "John Doe",
  "email": "john@nsa.gov"
}
```

Oh, wait... Your users don't respond to `#name`?

```ruby
class UserSerializer < ApplicationSerializer
  attributes :id, :name, :email

  def name
    "#{object.first_name} #{object.last_name}"
  end
end
```

That's fine. Your serializers can render fields your object don't respond to.

Now, to render the JSON object, you need to say the following in your
controller:

```ruby
class UsersController < ApplicationController
  def show
    user = User.find(params[:id])

    render json: user
  end
end
```

The serializr library hooks itself into `ActionController::Base` or
`ActionController::API` and it can infer the `UserSerializer` out of the `User`
object. You can also be explicit, in which case the inferring logic won't be
triggered at all.

```ruby
class UsersController < ApplicationController
  def show
    user = User.find(params[:id])

    render json: user, serializer: UserSerializer
  end
end
```

You can also render collections of objects:

```ruby
class FriendsController < ApplicationController
  def index
    user = User.friends_of(params[:id])

    render json: friends
  end
end
```

Being explicit here may have performance benefits, as to guess the Serializer
class to use, we need to unroll the collection. The explicit usage, unarguably,
looks pretty awesome as well, so you can wow your friends! Which, is always
cool, you know. 😎

```ruby
class FriendsController < ApplicationController
  def index
    user = User.friends_of(params[:id])

    render json: friends, serializer: UserSerializer[]
  end
end
```

And this is how you drop `Action View` off your API's, kids!

(_Not really, but anyway, I have the stage now, I do the typing. Fuck off and
call my therapist!_)

### 1️⃣  Last Thing

To fill the API cliché, we need to go over one last file:
`app/serializers/application_serializer.rb`. At first, it looks like this:

```ruby
class ApplicationSerializer < Serializr
end
```

The grown ups call it [Layer
Supertype](http://martinfowler.com/eaaCatalog/layerSupertype.html). We'll call
it that thing that looks like `ApplicationController` and serves the same
purpose, but for the serializers, not the controllers. You can use it to put
common utilities shared by all the serializers.

For example:

```ruby
class ApplicationSerializer < Serializr
  # You may need the routes helpers, so you can link between resources in your
  # JSON responses.
  inlcude Rails.application.routes.url_helpers

  EPOCH_TIME = Time.at(0).in_time_zone('UTC')

  # You may wanna render this timestamp instead of `null` for unset timestamps.
  # Or do whatever, really. I'm not your parents.
  def render_timestamp(timestamp)
    timestamp || EPOCH_TIME
  end
end
```

### 1️⃣  Last Thing, For Real This Time

Serializr? Really? I know. It's fine.

You can require `serializr`, you can require `serializer` as well. The
constants? Both of `Serializr` and `Serializer` point to the same thing. Same
for the generators. Use whatever your brain and 🖐 like.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/gsamokovarov/serializr. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.

## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
