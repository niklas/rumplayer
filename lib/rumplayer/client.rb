class Rumplayer::Client
  include Rumplayer::Log
  include Rumplayer::Config

  def self.wait
    new.wait
  end

  def self.run(argv=[])
    new(argv).run
  end

  attr_reader :argv
  def initialize(argv=[])
    @argv = argv
  end

  def run argv=argv
    log "Running #{argv.inspect}"
    tell(argv)
    system(MplayerCommand, *argv)
  end

  def wait
    log "waiting"
  end

  def tell argv=argv
    log "Telling #{argv.inspect}"
    buddies.run(argv)
  end

  def buddies
    @buddies ||= DrbObject.new_with_uri(uri)
  end
end
