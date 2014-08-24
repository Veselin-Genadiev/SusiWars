require_relative 'SusiWars'
require_relative 'middlewares/chat'
require_relative 'environment'

Faye::WebSocket.load_adapter('thin')

use SusiWars::Echo

run SusiWars::App
