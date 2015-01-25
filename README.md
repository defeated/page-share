## about

A tiny service for scraping details about a webpage, for use in content
sharing. Uses naive heuristics like meta tags, open graph protocol and
twitter card markup.

## prerequisites

  `ruby 2.2.0`

## setup

  1. `bundle install`
  2. `bin/puma -C config/puma.rb`

## usage

Send a base64-encoded URL (e.g. yahoo.com):

`curl http://0.0.0.0:3000/aHR0cDovL3lhaG9vLmNvbS8=`

### result

```json
{
  "title":        "Yahoo",
  "description":  "A new welcome to Yahoo. The new Yahoo experience makes it easier to discover the news and information that you care about most. It's the web ordered for you.",
  "canonical":    "https://www.yahoo.com/",
  "image":        "https://s.yimg.com/dh/ap/default/130909/y_200_a.png",
  "favicon":      "https://s.yimg.com/rz/l/favicon.ico"
}
```

## jsonp callbacks

Append `callback=foo` querystring parameter, where `foo` is the name of your
local javascript function.

`curl http://0.0.0.0:3000/aHR0cDovL3lhaG9vLmNvbS8=?callback=jsonp`

### result

```json
jsonp({
  "title":        "Yahoo",
  "description":  "A new welcome to Yahoo. The new Yahoo experience makes it easier to discover the news and information that you care about most. It's the web ordered for you.",
  "canonical":    "https://www.yahoo.com/",
  "image":        "https://s.yimg.com/dh/ap/default/130909/y_200_a.png",
  "favicon":      "https://s.yimg.com/rz/l/favicon.ico"
})
```
