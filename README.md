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

`curl --form u=http://yahoo.com http://0.0.0.0:3000`

## result

```json
{
  "title":        "Yahoo",
  "description":  "A new welcome to Yahoo. The new Yahoo experience makes it easier to discover the news and information that you care about most. It's the web ordered for you.",
  "canonical":    "https://www.yahoo.com/",
  "image":        "https://s.yimg.com/dh/ap/default/130909/y_200_a.png",
  "favicon":      "https://s.yimg.com/rz/l/favicon.ico"
}
```
