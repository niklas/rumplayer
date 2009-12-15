require_dependency 'drbfire'
module Rumplayer
  include DRb::DRbUndumped


  module Log
    def log(message)
      if $options[:verbose]
        STDERR.puts message
      end
    end
  end
end
