require 'drb/observer'
class Rumplayer::Server
  include Rumplayer::Log
  include Rumplayer::Config
  include DRb::DRbObservable
  include DRb::DRbUndumped

  def self.start(argv=[])
    new.start
  end

  def start
    log "Starting Server"
    DRb.start_service(uri, self)
    DRb.thread.join
  end

  def run(argv=[])
    log "One Client told #{argv.inspect}"
    changed
    if @observer_peers
      log "Telling all other #{@observer_peers.size} clients" 
      notify_observers(argv)
      log "Told observers"
    else
      log "Told no one. Your are watching alone"
    end
  end
end
