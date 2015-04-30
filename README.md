# DmtdVbmapp

[![CI Status](http://img.shields.io/travis/foscomputerservices/dmtd_vbmapp_data.svg?style=flat)](https://travis-ci.org/foscomputerservices/dmtd_vbmapp_data)
[![Version](https://img.shields.io/gem/v/dmtd_vbmapp_data.svg?style=flat)](http://www.rubydoc.info/github/foscomputerservices/dmtd_vbmapp_data/master)
[![License](https://img.shields.io/github/license/foscomputerservices/dmtd_vbmapp_data.svg?style=flat)](http://www.rubydoc.info/github/foscomputerservices/dmtd_vbmapp_data/master)

The gem is provided to ease access to DMTD's vbmappapp.com REST service.

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

```ruby
DmtdVbmappData.configure server_url: 'your_assigned_web_service_url' # It can also be 'http://data-sandbox.vbmappapp.com' for testing purposes
DmtdVbmappData.configure auth_token: 'your_auth_token'
DmtdVbmappData.configure organization_id: your_organization_id
```

## Further Reading

Full documentation of the gem can be found at: [http://www.rubydoc.info/github/foscomputerservices/dmtd_vbmapp_data/master](http://www.rubydoc.info/github/foscomputerservices/dmtd_vbmapp_data/master)  

## Contributing

1. Fork it ( https://github.com/[my-github-username]/dmtd_vbmapp_data/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
