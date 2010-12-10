# Weefire

## Dependency gems

* tinder
* i18n
* ramaze
* json
* thin (optional)

## Setup

1. Copy or symlink weefire.rb to ~/.weechat/ruby/autoload
1. Copy weefire-config.rb.sample to weefire-config.rb .
1. Edit weefire-config.rb to taste.
1. If you don't want to use Thin, remove the ":adapter => :thin" part of ramaze/daemon.rb .
1. Change the "load....config" line in ramaze/daemon.rb to point to your weefire-config.rb .

## Running

1. Start ramaze/daemon.rb .
1. Start Weechat.
1. Enjoy.

## Support

Pistos @ irc.freenode.net#mathetes
