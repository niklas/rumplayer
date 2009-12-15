require 'drb'

class Rumplayer::Client
  def self.wait
    STDERR.puts "waiting"
  end

  def self.run(argv=[])
    STDERR.puts "Running #{argv.inspect}"
  end
end
