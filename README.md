# site_services
Sinatra app that provides services to glitchwrks.com

This is a little Sinatra app that handles dynamic content for glitchwrks.com. Right now it's handling hit counters (or 'traffic analytics,' if hit counters are too 90's). This is currently deployed on an OpenBSD 5.8 host running nginx.

### Project Pieces

- Sinatra
- ActiveRecord
- Capistrano 3 for deployments
- Unicorn for app serving

Currently using MariaDB for the database, but it uses nothing specific to MariaDB and works fine with even SQLite. It can be run as a Unicorn application, or directly via `ruby site_services.rb`.

### Counters

This feature is broken into two main DB models: Counter and Hit. Counters are parent objects to Hits; that is, Counters have many Hits. They also contain an IPv4 preload and IPv6 preload. Preloads allow for nonzero starting points, which also allows for consolidating hits. Additionally, SitewideCounters aggregate all unique hits for all counters. Hits store the IP address, first appearance, most recent appearance, and whether the IP was IPv6 or not.

The rake task `counter:consolidate_hits` allows for keeping the DB small by consolidating all hits for a counter into the counter's preload value. The current hits are counted, added to the counter's preload, and then deleted. 