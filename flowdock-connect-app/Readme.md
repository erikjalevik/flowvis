# Flowdock connect app
This app is based on [Flowdock OAuth Demo](https://github.com/flowdock/flowdock-oauth-demo).

It has some modifications in the views.

See section **Setup** for instructions to run this app.


# Flowdock OAuth Client Demo

This repo contains a demo application that uses [Flowdock API](https://flowdock.com/api)
via OAuth 2.0. The client-side part utilises [Flowdock Sreaming API](https://flowdock.com/api/streaming).

The app fetches latest chat messages for the selected flow in Flowdock and
streams new messages. Messages can also be sent to the flow.

[App.rb](https://github.com/flowdock/flowdock-oauth-demo/blob/master/app.rb)
contains Sinatra app that is the redirect URL endpoint for OAuth.

[Index.html](https://github.com/flowdock/flowdock-oauth-demo/blob/master/static/index.html)
is a JavaScript client that interacts with Flowdock API using CORS.

## Setup

 - configure OAuth credentials and cookie secret as environment variables
(or .env). See sample.env.

You need to have bundler gem installed: `sudo gem install bundle` and the Ruby version defined in the `Gemfile`. [RVM](https://rvm.io) can be used to manage different Ruby versions.

## Installing and running

 - `bundle install`
 - `foreman start`

 The Ruby application is used to sever the client-side JS and as redirect
 endpoint for OAuth.

 Flowdock OAuth credentials can be created at
 https://www.flowdock.com/oauth/applications.

## Connecting

Open `localhost:5000` in the browser and authenticate your Flowdock user account to use the app. You need to have a websocket in `localhost:8001` running. When you select the flow, incoming stream of messages are sent to the websocket.
