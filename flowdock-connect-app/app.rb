require 'sinatra'
require 'omniauth'
require 'omniauth-flowdock'

$stdout.sync = true

use Rack::Session::Cookie, secret: ENV['COOKIE_SECRET']
set :public_folder, Proc.new { File.join(root, "static") }
use OmniAuth::Builder do
  provider :flowdock, ENV['FLOWDOCK_CLIENT_ID'], ENV['FLOWDOCK_CLIENT_SECRET'], scope: 'flow'
end

get '/auth/:name/callback' do
 auth = request.env['omniauth.auth']
 # do whatever you want with the information!
 auth.to_json
 erb :callback, locals: { token: auth["credentials"]["token"] }
end

get '/' do
  File.read('static/index.html')
end
