require './SusiWars'
require './middlewares/chat'

Faye::WebSocket.load_adapter('thin')

use SusiWars::Echo

run SusiWars::App
