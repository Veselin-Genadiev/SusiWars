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
          @clients.each { |client| client.send(event.data) }
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
