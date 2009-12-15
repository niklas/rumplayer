class Rumplayer::Client
  include Rumplayer::Log
  include Rumplayer::Config

  def self.wait
    new.wait
  end

  def self.run(argv=[])
    new(argv).run_and_tell
  end

  attr_reader :argv
  def initialize(argv=[])
    @argv = argv
  end

  def run_and_tell argv=argv
    log "Running #{argv.inspect}"
    tell(argv)
  end

  def run
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
    @buddies ||= DRbObject.new_with_uri(uri)
  end
end
