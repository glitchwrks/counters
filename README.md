# site_services
Sinatra app that provides services to glitchwrks.com

This is a little Sinatra app that handles dynamic content for glitchwrks.com. Right now it's handling hit counters (or 'traffic analytics,' if hit counters are too 90's). This is currently deployed on an OpenBSD 6.9 host running nginx.

### Project Pieces

- Sinatra
- ActiveRecord
- Capistrano 3 for deployments
- Unicorn for app serving

Currently using MariaDB for the database, but it uses nothing specific to MariaDB and works fine with even SQLite. It can be run as a Unicorn application, or directly via `ruby site_services.rb`.

### Counters

This feature is broken into two main DB models: Counter and Hit. Counters are parent objects to Hits; that is, Counters have many Hits. They also contain an IPv4 preload and IPv6 preload. Preloads allow for nonzero starting points, which also allows for consolidating hits. Additionally, SitewideCounters aggregate all unique hits for all counters. Hits store the IP address, first appearance, most recent appearance, and whether the IP was IPv6 or not.

The rake task `counter:consolidate_hits` allows for keeping the DB small by consolidating all hits for a counter into the counter's preload value. The current hits are counted, added to the counter's preload, and then deleted.

Doing a HTTP GET to `/counters/:name` will return a bit of JavaScript to write the current hit count to the document. Including `?ipv6=true` in the query params will cause the IPv6 count to be displayed, too.

### CAPTCHA Service

*This feature has been removed since it is no longer in use. [This SHA](https://github.com/chapmajs/site_services/tree/024c61351deba8b09e3c518979aa1c664420e8fb) contains the final version.*

### Preorders

*This has since been moved to a different project. [This SHA](https://github.com/chapmajs/site_services/tree/3054dc5f87e2bd73e95b2ba6d5ab6aa67731e8b0) contains the final version.*

### Contact Form

*This has since been moved to a different project. [This SHA](https://github.com/chapmajs/site_services/tree/b598178877676fe3e3d95532cc90ef9bc3e6bd19) contains the final version.*

### Text Email Sending Service

*This service was no longer being used and was removed. [This SHA](https://github.com/chapmajs/site_services/tree/6f2cb5e72846eba2dfa18c6d69d9dbb56dd1b406) contains the final version.*

### Test Suite

This application uses [RSpec](http://rspec.info/). To run the test suite on a new workstation, do:

```
rake db:test:prepare
rspec
```

[SimpleCov](https://github.com/simplecov-ruby/simplecov) provides code coverage reporting.
