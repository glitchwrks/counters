# counters
Sinatra app that provides counters to glitchwrks.com

This is a little Sinatra app that handles hit counters (or 'traffic analytics,' if hit counters are too 90's) for glitchwrks.com . This is currently deployed on an OpenBSD 7.6 host.

### Project Pieces

- Sinatra
- ActiveRecord
- Capistrano 3 for deployments
- Puma for app serving

Currently using MariaDB for the database, but it uses nothing specific to MariaDB and works fine with even SQLite. It can be run as a Puma application, or directly via `ruby counters.rb`.

### Counters

This feature is broken into two main DB models: Counter and Hit. Counters are parent objects to Hits; that is, Counters have many Hits. They also contain an IPv4 preload and IPv6 preload. Preloads allow for nonzero starting points, which also allows for consolidating hits. Additionally, SitewideCounters aggregate all unique hits for all counters. Hits store the IP address, first appearance, most recent appearance, and whether the IP was IPv6 or not.

The rake task `counter:consolidate_hits` allows for keeping the DB small by consolidating all hits for a counter into the counter's preload value. The current hits are counted, added to the counter's preload, and then deleted.

Doing a HTTP GET to `/:name` will return a bit of JavaScript to write the current hit count to the document. Including `?ipv6=true` in the query params will cause the IPv6 count to be displayed, too.

### Test Suite

This application uses [RSpec](http://rspec.info/). To run the test suite on a new workstation, do:

```
rake db:test:prepare
rspec
```

[SimpleCov](https://github.com/simplecov-ruby/simplecov) provides code coverage reporting.

### Capistrano Tasks

To manage the Puma process on the application server, a custom Capistrano task, `puma:restart` has been defined. This task uses OpenBSD's [`doas`](https://man.openbsd.org/OpenBSD-7.6/doas) to invoke the rc-script that controls the Puma process.

### Removed Legacy Features

The following features were once part of this application, when it was called `site_services`, but have since been moved to [`rails_services`](https://github.com/glitchwrks/rails_services). The final versions of these features are available at the following SHAs:

* [CAPTCHA Service](https://github.com/glitchwrks/counters/tree/024c61351deba8b09e3c518979aa1c664420e8fb)
* [Preorders](https://github.com/glitchwrks/counters/tree/3054dc5f87e2bd73e95b2ba6d5ab6aa67731e8b0)
* [Contact Form](https://github.com/glitchwrks/counters/tree/b598178877676fe3e3d95532cc90ef9bc3e6bd19)
* [Text Email Sending Service](https://github.com/glitchwrks/counters/tree/6f2cb5e72846eba2dfa18c6d69d9dbb56dd1b406)
