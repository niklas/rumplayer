module Rumplayer
  MplayerCommand = `which mplayer`.chomp
end
require 'lib/rumplayer/server'
require 'lib/rumplayer/client'
