module Rumplayer
  module Config
    def username
      `whoami`.chomp
    end

    def hostname
      `hostname`.chomp
    end

    def name
      @name ||= [username, hostname].join('@')
    end

    def config_path
      File.join( ENV['HOME'], '.rumplayer.yml' )
    end

    def config_exists?
      File.exists? config_path
    end

    def default_config
      {
        'uri' => "drbfire://localhost:18383"
      }
    end

    def config
      return @config if @config
      unless config_exists?
        write_default_config 
        say "written default config to #{config_path}"
        say "please edit it"
      end
      load_config
    end

    private
    def write_default_config
      write_config default_config
    end

    def write_config config=@config
      File.open(config_path, 'w') do |f|
        f.puts config.to_yaml
      end
    end

    def load_config
      @config = YAML.load( File.read(config_path ))
      log "loaded config %s" % @config.inspect
      @config
    end
  end
end

