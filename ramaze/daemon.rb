require 'thread'
require 'json'
require 'ramaze'
require 'tinder'

load '/misc/git/weefire/weefire-config.rb'

module Weefire
  class Daemon
    def initialize
      @campfire = Tinder::Campfire.new( ::Weefire::CAMPFIRE_SUBDOMAIN, :token => ::Weefire::CAMPFIRE_API_TOKEN )
      @room = @campfire.find_room_by_name( ::Weefire::CAMPFIRE_ROOM )
      @unread = @room.transcript( Date.today ).map { |msg|
        "<#{msg[:id]}> #{msg[:message]}"
      }
      @mutex = Mutex.new

      Thread.new do
        @room.listen do |msg|
          $stderr.puts "Received: #{msg.inspect}"
          @mutex.synchronize do
            @unread << "<#{msg[:user][:name]}> #{msg[:body]}"
          end
        end
      end
    end

    def unread
      messages = []
      @mutex.synchronize do
        messages = @unread
        @unread = []
      end
      messages
    end

    def recent
      @room.transcript Date.today
    end

    def say( message )
      @room.speak message
    end
  end
end

$weefire_daemon = Weefire::Daemon.new

class MainController < Ramaze::Controller
  provide( :json, :type => 'application/json' ) { |action, value| value.to_json }

  def index
  end

  def unread
    $weefire_daemon.unread
  end

  def recent
    $weefire_daemon.recent
  end

  def say( message )
    $weefire_daemon.say message
  end
end

Ramaze.start :adapter => :thin, :port => 7001
