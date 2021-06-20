# Gnext

Gnext is a ruby gem for the ERPNext Rest api.

## Documentación Frappe Framework
[Manipulating Documents](https://frappeframework.com/docs/user/en/guides/integration/rest_api/manipulating_documents)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gnext'
```

or a specific version

```ruby
gem 'gnext', '1.0.x'
```

And then execute:

```bash
$ bundle install
```

## Usage

### Initialization

The gem can automatically load the authentication settings from the *.env.development* file.

#### User/Password Authentication
```bash
ERP_API_URL=
ERP_USER=
ERP_PASSWORD=
ERP_AUTHENTICATION_TYPE=password
```

#### Token Authentication
```bash
ERP_API_URL=
ERP_API_KEY=
ERP_API_SECRET=
ERP_AUTHENTICATION_TYPE=token   # optional
```

#### Global configuration
If you want to customize the gem options, add a new initializer file, *config/initializers/gnext.rb*

```ruby
# Be sure to restart your server when you modify this file.

Gnext.configure do |config|
  # The base url from erpnext
  config.base_url = ENV['ERP_API_URL']

  # The username to use during login.
  config.username = ENV['ERP_USER']

  # The password to use during login.
  config.password = ENV['ERP_PASSWORD']

  # The security api token to use during login.
  config.api_key = ENV['ERP_API_KEY']

  # The security api secret to use during login.
  config.api_secret = ENV['ERP_API_SECRET']

  # The type of authentication is used to determine which one to use in case
  # there is availability for `token` authentication or `password` authentication
  config.authentication_type = ENV['ERP_AUTHENTICATION_TYPE']

  # The options per handle retry middleware
  config.retry_options = {}

  # The options per handle retry middleware
  config.deep_merge_of_retry_options = true

  # Faraday request read/open timeout.
  config.timeout

  # Faraday adapter to use. Defaults to Faraday.default_adapter.
  config.adapter

  # A Proc that is called with the response body after a successful authentication.
  config.authentication_callback =  Proc.new { |body| Rails.logger.debug body.to_s }

  # Set SSL options
  config.ssl = {}

  # A Hash that is converted to HTTP headers
  config.request_headers = {}
end
```

#### Create Instance
```ruby
options = {
  base_url: 'url',
  username: 'username',
  # ...
}

client = Gnext::Client.new(options)

client.doctype('doctype').where(field: 'value')

client.logout # if use User/Password Authentication
```

***You can also use the global instance***
```ruby
Gnext::Client.doctype('doctype').where(field: 'value')
```



### Endpoint Builder
The build of an endpoint begins by calling the doctype method

#### Doctype
```ruby
endpoint_builder = Gnext::Client.doctype('doctype')
```

#### Fields
```ruby
endpoint_builder = endpoint_builder.select('field_one', 'field_two', :field_three)
```

#### Filters
```ruby
endpoint_builder = endpoint_builder.where(field_one: 'value', fied_two: ['value 1', 'value 2'])

endpoint_builder = endpoint_builder.where('field_three', '>', 20)

endpoint_builder = endpoint_builder.where('field_four', 'in', ['value 1', 'value 2', 'value 3'])

# Operators to filter
# "=", ">", "<", ">=", "<=", "like", "not like", "in", "not in", "between"
```

#### Limit Page
With this parameter you can change the page size. Default: 20.
```ruby
endpoint_builder = endpoint_builder.limit(50)
```

#### Limit Start
```ruby
endpoint_builder = endpoint_builder.offset(50)
```



### Manipulating DocTypes

#### List Documents
Get a list of documents of this DocType.

```ruby
endpoint_builder = Gnext::Client.doctype('doctype').where(field_one: 'value', fied_two: 'value')

# a single call
# return first document
document = endpoint_builder.first_doc
puts document

# a single call
# returns only the documents of the first page
# recommendation set a high limit if the number of documents will be greater than 20 `.limit(100)`
documents = endpoint_builder.list # o .list_all
puts documents

# multiple call
# fetch documents in batch
# each by document
endpoint_builder.list_each do |document|
  puts document
end

# multiple call
# fetch documents in batch
# each by documents batch
endpoint_builder.list_in_batches do |documents|
  puts documents
end
```

#### Create Document
Create a new document of this DocType.

```ruby
Gnext::Client.doctype('doctype').create({fieldname: 'value'})
```

#### Find Document
Retrieve a specific document by name (ID).

```ruby
Gnext::Client.doctype('doctype').find('document_name')
```

#### Update Document
Update a specific document.

```ruby
Gnext::Client.doctype('doctype').update({name: 'document_name', fieldname: 'value'})
# o
Gnext::Client.doctype('doctype').update('document_name', {fieldname: 'value'})
```

#### Delete Document
The name (ID) of the document you'd like to delete.

```ruby
Gnext::Client.doctype('doctype').delete('document_name')
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
