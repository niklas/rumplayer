class Rumplayer::Server
  include Rumplayer::Log
  include Rumplayer::Config
  def self.start(argv=[])
    new.start
  end

  def start
    log "Starting Server"
    DRb.start_service(uri, self)
    DRb.thread.join
  end
end
