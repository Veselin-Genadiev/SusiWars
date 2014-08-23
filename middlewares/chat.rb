require 'faye/websocket'
require 'json'
require 'cgi'

module SusiWars
  class Echo
    KEEPALIVE_TIME = 15

    def initialize(app)
      @app = app
      @clients = []
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME})

        ws.on :open do |event|
          @clients << ws
        end

        ws.on :message do |event|
          @room = CGI::Cookie.parse(ws.env['HTTP_COOKIE'])['room']
          @clients.each do |client|
            @client_room = CGI::Cookie.parse(client.env['HTTP_COOKIE'])['room']
            if @client_room  == @room
              p [@client_room, @room]
              client.send(event.data)
            end
          end
        end

        ws.on :close do |event|
          @clients.delete(ws)
          ws = nil
        end
      else
        @app.call(env)
      end
    end
  end
end
