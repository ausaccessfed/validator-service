## Design and structure

### Snapshot flow

1. The Validator is seeded with known attributes, but these can be extended and modified in the Admin interface.
2. Attributes are passed from [ausaccessfed/shib-rack](https://github.com/ausaccessfed/shib-rack).
3. If they are within the set of known attributes, they are saved to a snapshot.  Unknown attributes are excluded from the snapshot.
4. Snapshots are presented to the Subject with attribute and category level validation applied to them.
5. Edge cases, such as a changing Shared Token will be highlighted to the Subject.

### Admin Interface

1. An Admin role is seeded with the entitlement of `urn:mace:aaf.edu.au:ide:internal:aaf-admin`.
2. A Subject's entitlements are provisioned via an Identity Enhancement service (such as [AAF's IdE](https://ide.aaf.edu.au/)) when they login.
3. An Admin tab is available on the main navigation bar if they have the correct role available.

## Setup

### All Environments

Make sure you have configured:

- `config/deploy.yml`
- `config/validator_service.yml`
- `config/api-client.crt` <sup>`^`</sup>
- `config/api-client.key` <sup>`^`</sup>

`^` For API authorization to your IdE Service.

### Development

#### Setting up a development environment

1. Be using Ruby 2.3+.
2. Run `bin/setup` (and read the output for any additional steps).
3. Run `guard`.

#### Setting yourself up as an Admin user

A shortcut for adding yourself as an Admin is the following:

`rails c`

```ruby
SubjectRole.create!(subject: Subject.last, role: Role.first)
```

#### AAF gems

This project uses the following AAF gems:

- [AAF Gumboot](https://github.com/ausaccessfed/aaf-gumboot)
- [AAF Secure Headers](https://github.com/ausaccessfed/aaf-secure_headers)
- [AAF Lipstick](https://github.com/ausaccessfed/aaf-lipstick)
- [Shib Rack](https://github.com/ausaccessfed/shib-rack)
- [Super Identity](https://github.com/ausaccessfed/super-identity)
- [Accession](https://github.com/ausaccessfed/accession)
- [Valhammer](https://github.com/ausaccessfed/valhammer)

### Production

#### Setting up a production environment

`bin/setup` *SHOULD NOT* be used for configuring a production environment.

Standard Rails deployment practices should be followed.  These include:

- Setting the correct environmental variables:
  - `RAILS_ENV=production`
  - `VALIDATOR_DB_NAME`
  - `VALIDATOR_DB_USERNAME`
  - `VALIDATOR_DB_PASSWORD`
  - `SECRET_KEY_BASE`
- Running `bundle install`
- Running `bundle exec torba pack`
- Creating the DB and loading the schema:
  - `rails db:create`
  - `rails db:schema:load`
  - `rails db:seed`
