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
    tell(argv)
    run(argv)
  end

  def run argv=argv
    log "Running #{argv.inspect}"
    if is_slave?
      Thread.start{ run_mplayer argv }
    else
      run_mplayer argv
    end
  end

  def wait
    say "Connecting.."
    log "Started as %s" % DRb.start_service.uri
    buddies.register(self, username)
    say "waiting for command"
    sleep 100000
    log "tired of waiting"
  end

  def update(*args)
    log "Got told: #{args.inspect}"
  end

  def say(message="no message")
    STDERR.puts message
  end

  def tell argv=argv
    log "Telling #{argv.inspect}"
    buddies.run(argv)
  end

  def buddies
    @buddies ||= DRbObject.new_with_uri(uri)
  end

  def is_slave?
    argv.empty?
  end

  private
  def run_mplayer argv=argv
    system(Rumplayer::MplayerCommand, *argv)
    log "Finished playing #{argv.inspect}"
  end
end
