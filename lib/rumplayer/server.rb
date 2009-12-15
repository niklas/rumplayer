class Rumplayer::Server
  include DRb::DRbUndumped
  include Rumplayer::Log
  include Rumplayer::Config

  class Watcher < Struct.new(:handler, :name)
    @@last_index = 0
    attr_reader :index
    def self.next_index
      @@last_index += 1
      @@last_index
    end
    def initialize(*args)
      super
      @index = self.class.next_index
    end
    def method_missing(method_name, *args, &block)
      handler.__send__(method_name, *args, &block)
    end
    def to_s
      "#{name} (#{index}) [#{handler.__drburi}]"
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
    DRb.start_service(config['uri'], self, DRbFire::ROLE => DRbFire::SERVER)
    DRb.thread.join
  end

  def register(client, name=nil)
    watcher = Watcher.new(client, name || client.inspect)
    log "connected #{watcher}"

    say("#{watcher.name} connected")
    watcher.say "Connected."
    if @watchers.empty?
      watcher.say "no other buddies connected (yet)"
    else
      watcher.say "Buddies: %s" % @watchers.map(&:name).join(', ')
    end
    @watchers << watcher
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
    log "disconnected #{watcher}"
    say("#{watcher.name} disconnected")
  end

end
