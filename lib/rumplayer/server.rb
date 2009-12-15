require 'drb/observer'
class Rumplayer::Server
  include Rumplayer::Log
  include Rumplayer::Config
  include DRb::DRbUndumped

  class Watcher < Struct.new(:handler, :name)
    def method_missing(method_name, *args, &block)
      handler.__send__(method_name, *args, &block)
    end
  end

  def self.start(argv=[])
    new.start
  end

  def initialize
    @watchers = []
  end

  def start
    log "Starting Server"
    DRb.start_service(uri, self)
    DRb.thread.join
  end

  def register(client, name=nil)
    watcher = Watcher.new(client, name || client.inspect)
    log "connected #{watcher.name}"

    say("#{watcher.name} connected")
    @watchers << watcher
    watcher.say("Connected.")
  end

  def unregister(client)
    if watcher = @watchers.find {|w| w.handler == client }
      watcher.say "Goodbye"
      remove_watcher watcher
    end
  end

  def method_missing(method_name, *args, &block)
    log "#{method_name} to all: #{args.inspect}"
    each_watcher do |watcher|
      watcher.__send__(method_name, *args, &block)
    end
  end

  def each_watcher
    unless @watchers.blank?
      @watchers.each do |watcher|
        begin
          yield(watcher)
        rescue DRb::DRbConnError => e
          remove_watcher(watcher)
        end
      end
    end
  end

  def remove_watcher watcher
    @watchers.delete(watcher)
    log "disconnected #{watcher.name}"
    say("#{watcher.name} disconnected")
  end

end
