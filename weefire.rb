require 'open-uri'
require 'json'
require 'cgi'

# callback for data received in input
def buffer_input_cb( data, buffer, input_data )
  s = input_data.to_s
  open "http://localhost:7001/say/#{ CGI.escape(s) }"
  bputs s
  Weechat::WEECHAT_RC_OK
end

# callback called when buffer is closed
def buffer_close_cb( data, buffer )
  Weechat::WEECHAT_RC_OK
end

def timer_cb( data, remaining_calls )
  messages = JSON.parse( open( 'http://localhost:7001/unread.json' ).read )
  messages.each do |m|
    bputs m
  end
  Weechat::WEECHAT_RC_OK
end

def bputs( s )
  Weechat.print $wf_buffer, s
end

def weechat_init
  Weechat.register( "weefire", "Pistos", "0.1", "MIT", "Interface to Campfire (chat)", '', '' )

  $wf_buffer = Weechat.buffer_new( "Weefire", "buffer_input_cb", "", "buffer_close_cb", "" )
  Weechat.buffer_set( $wf_buffer, 'title', 'Weefire - Campfire Bridge' )
  Weechat.hook_timer( 5 * 1000, 0, 0, "timer_cb", "" )

  Weechat::WEECHAT_RC_OK
end
