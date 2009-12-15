class Rumplayer::Client
  include Rumplayer::Log

  def self.wait
    log "waiting"
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

  def tell argv=argv
    log "Telling #{argv.inspect}"
  end
end
