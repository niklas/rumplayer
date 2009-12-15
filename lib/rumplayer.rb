require 'drb'

module Rumplayer
  MplayerCommand = `which mplayer`.chomp

  module Log
    def log(message)
      if $options[:verbose]
        STDERR.puts message
      end
    end
  end
end
require 'lib/rumplayer/server'
require 'lib/rumplayer/client'
