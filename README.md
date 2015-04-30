# DmtdVbmapp

The gem is provided to ease access to DMTD's vbmappdata.com service.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dmtd_vbmapp_data'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dmtd_vbmapp_data

## Configuration

Upon receiving an authorization token from Data Makes the Difference, add the following lines to your application's configuration: 

DmtdVbmappData.configure server_url: 'your_assigned_web_service_url' -- It can also be 'http://data-sandbox.vbmappapp.com' for testing purposes
DmtdVbmappData.configure auth_token: 'your_auth_token'
DmtdVbmappData.configure organization_id: your_organization_id 

## Contributing

1. Fork it ( https://github.com/[my-github-username]/dmtd_vbmapp_data/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
