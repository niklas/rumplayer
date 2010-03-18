RuMplayer
=========

Given you and (at least) one of your buddies want to watch movies together, but
on different devices which may be located (very) far from each other.

With RuMplayer you can watch them simultaneously without having to leave your comfy home.

### Requirements

* a public server where you can install RuMplayer an run the server.
* all your buddies must have 
** a copy of the movie to watch, named equal
** mplayer installed (apt, ports, you name it)


### Installation

    (sudo) gem update --system
    (sudo) gem install rumplayer

    rumplayer
    CTRL+C

Now, edit ~/.rumplayer.yml and add the url to you common server

### Usage

On the Server run:

    rumplayer -v --server


All your buddies wait for the movie to start by running

    cd /wherever/the/movie/is/located/
    rumplayer

You start the movie by supplying the filename

    cd /my/location/of/the/movie
    rumplayer movie.mkv

Now all your buddies can pause, seek or stop the movie. 
All these actions get distributed to all watchers.
