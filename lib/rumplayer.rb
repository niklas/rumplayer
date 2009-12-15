require 'drb/drb'

module Rumplayer
  include DRb::DRbUndumped
  MplayerCommand = `which mplayer`.chomp

  module Config
    def uri
      "druby://localhost:18383"
    end
  end

  module Log
    def log(message)
      if $options[:verbose]
        STDERR.puts message
      end
    end
  end
end
