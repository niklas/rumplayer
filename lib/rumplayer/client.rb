require 'drb'

class Rumplayer::Client
  def self.wait
    STDERR.puts "waiting"
  end

  def self.run(argv=[])
    new(argv).run
  end

  attr_reader :argv
  def initialize(argv=[])
    @argv = argv
  end

  def run argv=argv
    STDERR.puts "Running #{argv.inspect}"
    tell(argv)
    system(MplayerCommand, *argv)
  end

  def tell argv=argv
    STDERR.puts "Telling #{argv.inspect}"
  end
end
