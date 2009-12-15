require 'drb/drb'

module Rumplayer
  include DRb::DRbUndumped

  module Config
    def uri
      "druby://localhost:18383"
    end

    def username
      @username ||= [`whoami`.chomp, `hostname`.chomp].join('@')
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
