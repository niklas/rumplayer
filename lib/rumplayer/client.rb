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
    trap('INT') do
      buddies.unregister(self)
      exit
    end
    say "waiting for command"
    sleep 100000
    log "tired of waiting"
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

  def key(char)
    log "Pressed #{char}"
  end

  private
  def run_mplayer argv=argv, options ={}
    rd, wr = IO.pipe
    @mplayer = fork do
      STDIN.reopen(rd)
      command = [Rumplayer::MplayerCommand] + options.to_a.flatten + argv
      exec(*command)
    end
    Process::detach(@mplayer)
    @mplayer_pipe = wr
    forward_keys
    log "Finished playing #{argv.inspect}"
  end

  def forward_keys
    while true
      char = read_char
      key(char)
      buddies.key(char)
    end
  end

  def read_char
    begin
      # save previous state of stty
      old_state = `stty -g`
      # disable echoing and enable raw (not having to press enter)
      system "stty raw -echo"
      c = STDIN.getc.chr
    rescue => ex
      puts "#{ex.class}: #{ex.message}"
      puts ex.backtrace
    ensure
      # restore previous state of stty
      system "stty #{old_state}"
    end
    return c
  end
end
