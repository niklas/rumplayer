module Rumplayer
  module Config
    def uri
      "druby://localhost:18383"
    end

    def username
      `whoami`.chomp
    end

    def hostname
      `hostname`.chomp
    end

    def name
      @name ||= [username, hostname].join('@')
    end
  end
end

