# site_services
Sinatra app that provides services to glitchwrks.com

This is a little Sinatra app that handles dynamic content for glitchwrks.com. Right now it's handling hit counters (or 'traffic analytics,' if hit counters are too 90's) and a contact form. This is currently deployed on an OpenBSD 5.8 host running nginx.

### Project Pieces

- Sinatra
- ActiveRecord
- Capistrano 3 for deployments
- Unicorn for app serving

Currently using MariaDB for the database, but it uses nothing specific to MariaDB and works fine with even SQLite. It can be run as a Unicorn application, or directly via `ruby site_services.rb`.

### Counters

This feature is broken into two main DB models: Counter and Hit. Counters are parent objects to Hits; that is, Counters have many Hits. They also contain an IPv4 preload and IPv6 preload. Preloads allow for nonzero starting points, which also allows for consolidating hits. Additionally, SitewideCounters aggregate all unique hits for all counters. Hits store the IP address, first appearance, most recent appearance, and whether the IP was IPv6 or not.

The rake task `counter:consolidate_hits` allows for keeping the DB small by consolidating all hits for a counter into the counter's preload value. The current hits are counted, added to the counter's preload, and then deleted. 

### Contact Form

Better than just sticking one's email address on the Internet, right? Simple target for a form hosted on the main site. I wanted to do a few things with it:

- Configurable for production/dev work, so emails could go to [mailtrap.io](https://mailtrap.io)
- Sanitize emails to plaintext
- Save emails that don't get sent, for whatever reason

This feature is controlled through [/config/email.yml](https://github.com/chapmajs/site_services/blob/master/config/email.yml.example). There are two main sections to the YAML file: a per-environment definition for the mail server to use (`development` given in the example), and a `contact_mailer` section which controls a few aspects of the mailer. It allows changing the destination email and persistence of failed/suspicious emails.

`save_suspicious_messages`, when set to `true`, causes emails that get something stripped out of them by [Sanitize](https://github.com/rgrove/sanitize) to get stored in the DB for analysis.

`save_failed_messages`, when set to `true`, causes emails that don't pass a CAPTCHA to get stored for analysis.

### Preorders

An endpoint for processing project preorders, this is an attempt to gauge interest in open source hardware projects before doing an initial production run of boards. Does a couple things:

- Validates CAPTCHA so the form is more resistant to being used for spamming
- Strips preorder fields, persists to DB
- Emails a confirmation with the details of the preorder and a link to verify
- Handles the verification URL

There's no interface for viewing the preorders as I intend to dump the DB and load it into something else for order processing. There's a `rake` task for creating projects to be used with preorders, it follows as:

```
rake project:create NAME=project-name PRINTABLE_NAME='The Printable Name'
```

`NAME` is what comes in on the `POST` to `/preorder/project-name` and `PRINTABLE_NAME` is the name used in the confirmation email.

### CAPTCHA Service

This service was written for the Preorder feature, but is generic and can be used elsewhere. It uses Google's [reCAPTCHA service](https://www.google.com/recaptcha). The service is configured through [/config/recaptcha.yml](https://github.com/chapmajs/site_services/blob/master/config/recaptcha.yml.example) which allows per-action API key specification.

If the CAPTCHA verification fails, the failure is logged to the DB with the response from Google and the IP that the request was made from.