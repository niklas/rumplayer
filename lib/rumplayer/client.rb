class Rumplayer::Client
  include DRb::DRbUndumped
  include Rumplayer::Log
  include Rumplayer::Config
  include Rumplayer::Mplayer

  def self.wait
    new.wait
  end

  def self.run(argv=[])
    client = new(argv).run_and_tell
  end

  attr_reader :argv
  def initialize(argv=[])
    @argv = argv
  end

  def run_and_tell argv=argv
    enter
    tell(argv)
  end

  def run argv=argv
    log "Running #{argv.inspect}"
    if is_slave?
      @mplayer_thread = Thread.start{ run_mplayer argv }
    else
      run_mplayer argv
    end
  end

  def wait
    enter
    say "waiting for command"
    sleep 100000
    log "tired of waiting"
  end

  def enter
    say "Connecting.."
    log "Started as %s" % start_service.uri
    buddies.register(self, name)
    trap('INT') { leave }
  end

  def start_service
    @service = DRb.start_service(config['uri'], self, DRbFire::ROLE => DRbFire::CLIENT)
    @service
  end

  def leave
    log "leaving"
    buddies.unregister(self) if @buddies
    DRb.stop_service
    kill_mplayer!
    log "joining loose threads"
    @mplayer_thread.join(1) if @mplayer_thread
    log "exiting"
    DRb.thread.join if DRb.thread
    say "killing remaining %i threads (you may want ctrl+c manually)" % Thread.list.size
    Thread.list.map(&:kill)
    exit
  end

  def say(message="no message")
    STDERR.puts message
  end

  def tell argv=argv
    log "Telling #{argv.inspect}"
    buddies.run(argv.dup)
  end

  def buddies
    @buddies ||= DRbObject.new(nil, config['uri'])
  end

  def is_slave?
    argv.empty?
  end

end
