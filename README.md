freshsales-analytics
=====================

## Description

freshsales-analytics is a ruby library for tracking the users and their activities in your ruby application.  

## Installation

```
gem install 'freshsales-analytics'
```

After installing the gem, create a file "config/fs_analytics_config.yml". Copy and paste the snippet below in the .yml file you created.

```
app_token: "FRESHSALES_APP_TOKEN"
url: "FRESHSALES_URL"
```


## Getting Started

```
# Sample for Tracking the users:

  new_lead = {
    'First name' => 'John', #Replace with first name of the user
    'Last name' => 'Doe',  #Replace with last name of the user
    'Email' => 'john.doe@example.com',  #Replace with email of the user
    'Alternate contact number' => '98765432', #Replace with a custom field
    'company' => {
      'Name' => 'Example.com', #Replace with company name
      'Website' => 'www.example.com' #Replace with website of company
    }
  }

  identifier = 'john.doe@example.com' #Replace with user's unique identifier

  begin
    FreshsalesAnalytics::identify(identifier, new_lead)
  rescue FreshsalesAnalytics::Exceptions => exc
    p '#{exc.err_obj}: #{exc.message}'
  end

# Sample for Tracking the Events:

  sample_event_properties = {
    'user email' => 'user@abc.com'  #Replace this with the event you want to track
  }

  begin
    FreshsalesAnalytics::trackEvent('Inviting Users', sample_event_properties)
  rescue FreshsalesAnalytics::Exceptions => exc
    p '#{exc.err_obj}: #{exc.message}'
  end

```

## Documentation
  
  Documentation is available at [freshsales.io/libraries/ruby](https://www.freshsales.io/libraries/ruby)

## License

Copyright (c) 2016 Freshsales

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.