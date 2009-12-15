class Rumplayer::Client
  include Rumplayer::Log
  include Rumplayer::Config
  include DRb::DRbUndumped

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
    run(argv)
    tell(argv)
  end

  def run argv=argv
    log "Running #{argv.inspect}"
    #system(Rumplayer::MplayerCommand, *argv)
    system('ls', *( %w(-l) + argv ) )
  end

  def wait
    log "waiting"
    DRb.start_service
    buddies.add_observer(self)
    sleep 100000
    log "stopped waiting"
  end

  def update(argv=[])
    log "Got told: #{argv.inspect}"
    run(argv)
  end

  def tell argv=argv
    log "Telling #{argv.inspect}"
    buddies.run(argv)
  end

  def buddies
    @buddies ||= DRbObject.new_with_uri(uri)
  end
end
