module Rumplayer::Mplayer
  MplayerCommand = `which mplayer`.chomp
  MplayerOptions = %w(-really-quiet)

  def key(char)
    leave if char == "\003"
    leave if char == "q"
    synchronize do
      @mplayer_pipe.print char
    end if @mplayer_pipe
  end

  def kill_mplayer!
    Process.kill("TERM", @mplayer) if mplayer_is_running?
    clean_up_all_traces_of_mplayer!
  end

  def mplayer_is_running?
    @mplayer and `ps -p #{@mplayer}`.chomp.lines.count > 1
  end

  def clean_up_all_traces_of_mplayer!
    @mplayer_pipe.close rescue nil
    @mplayer = nil
  end

  private
  def run_mplayer argv=argv, options ={}
    kill_mplayer!
    log "starting mplayer"
    rd, wr = IO.pipe
    @mplayer = fork do
      STDIN.reopen(rd)
      command = [MplayerCommand] + MplayerOptions + options.to_a.flatten + argv
      exec(*command)
    end
    Process::detach(@mplayer)
    @mplayer_pipe = wr
    forward_keys
    clean_up_all_traces_of_mplayer!
    log "Finished playing #{argv.inspect}"
  end

  def forward_keys
    while @mplayer
      char = read_char
      if ["\003", "q"].include? char
        buddies.say("#{user} has quit. You should quit, too (with 'q' or ctrl+c)")
        buddies.leave
      else
        buddies.key(char)
      end
    end
  end

  def read_char
    begin
      # save previous state of stty
      old_state = `stty -g`
      # disable echoing and enable raw (not having to press enter)
      system "stty raw -echo"
      c = STDIN.getc.chr
      if c == "\e"
        extra_thread = Thread.new do
          c = c + STDIN.getc.chr
          c = c + STDIN.getc.chr
        end
        extra_thread.join(0.00001)
        extra_thread.kill
      end
    rescue => ex
      puts "#{ex.class}: #{ex.message}"
      puts ex.backtrace
    ensure
      # restore previous state of stty
      system "stty #{old_state}"
    end
    return c
  end

  def synchronize(&block)
    @mplayer_mutex ||= Mutex.new
    @mplayer_mutex.synchronize(&block)
  end
end
