begin  
  require 'rubygems'
  require 'jeweler'  
  Jeweler::Tasks.new do |gemspec|  
    gemspec.name        = %q{rumplayer}
    gemspec.summary     = %q{watch common movies simultaneously}
    gemspec.description = %q{
      RumPlayer allows you and your buddies to watch movies simultaneously
      without sharing the room or continent. All participans must have a copy
      of the movie to watch.
    }
    gemspec.email       = %q{niklas+rumplayer@lanpartei.de}
    gemspec.homepage    = %q{http://github.com/niklas/rumplayer/}
    gemspec.authors     = ["Niklas Hofer"]
    gemspec.executables = %w{rumplayer}

    gemspec.has_rdoc    = false
    gemspec.files       = %w{
      README.mardown
      Rakefile
      rumplayer
      lib/rumplayer.rb
      lib/rumplayer/client.rb
      lib/rumplayer/server.rb
      lib/rumplayer/mplayer.rb
      lib/rumplayer/config.rb
    }
  end  
  Jeweler::GemcutterTasks.new  
rescue LoadError  
  puts "Jeweler not available. Install it with: sudo gem install jeweler"  
end
