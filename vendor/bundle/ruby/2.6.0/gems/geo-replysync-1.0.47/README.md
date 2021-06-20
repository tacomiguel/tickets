# Geo::Replysync

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/geo/replysync`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'geo-replysync'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install geo-replysync

## Usage

**Instalación en la App que envía al replicador**

Hay que incluir el modulo `Geo::Utils::ModelCallbacks` dentro de un modelo o en `ApplicationRecord` si se desea que todos los modelos envien su datos al replicador

```ruby
class User < ApplicationRecord
    include Geo::Utils::ModelCallbacks
    self.replicator_callbacks = [:create, :update, :destroy]
    self.replicator_conditions = [:email]
    self.replicator_fields = [:email, :password]
end
```

`replicator_callbacks` es opcional en el modelo, por defecto la gema envia al replicador a los 3 callbacks cuando no se especifica de manera explicita, pero podemos configurarlo de acuerdo a las necesidades del proyecto. Por ejemplo si solo queremos que envie data al replicador cuando se crea un nuevo usuario.
```ruby
self.replicator_callbacks = [:create]
```

`replicator_conditions` es obligatorio si no la gema no envia nada al replicador, aqui se indican los campos que identifican al modelo el cual se usará buscar el registro en las aplicaciones que reciben la data. Por ejemplo en este caso el email unico por usuario 
```ruby
self.replicator_conditions = [:email]
```

`replicator_fields` es opcional aqui indicamos que campos queremos enviar en la data a los demas sistemas, sino se indica por defecto enviara todos sus campos salvo los siguientes campos (id, created_at, updated_at, encrypted_password)
```ruby
self.replicator_fields = [:email, :password]
```

**Instalación en la App que recibe del replicador**

Ejecutar el siguiente comando, este comando por defecto llama al comando geo:utils:sync_user_tags
```bash
rails g geo:utils:install
```
Este comando instala el controlador `geoutils_controller.rb`, el archivo `geo.utils.whitelist.yml` para configurar que campos se pueden modificar en tu application, y te agrega una ruta al archivo `routes.rb

Puedes editar el archivo whitelist de tu applicacion
```yml
# config/geo.utils.whitelist.yml

Tables:
  Users:
    fields:
      - email
      - password

```

Este comando solo instala un job para sincronizar con CAS los tags del usuario

```bash
geo:utils:sync_user_tags
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/geo-replysync. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/geo-replysync/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Geo::Replysync project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/geo-replysync/blob/master/CODE_OF_CONDUCT.md).
