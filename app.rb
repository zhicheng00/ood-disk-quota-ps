require 'erubi'
require './command'

set :erb, :escape_html => true

if development?
  require 'sinatra/reloader'
  also_reload './command.rb'
end

helpers do
  def dashboard_title
    "NUS HPC OnDemand"
  end

  def dashboard_url
    "/pun/sys/dashboard/"
  end

  def title
    "Disk Quota"
  end
end

# Define a route at the root '/' of the app.
get '/' do
  @command = Command.new
  @quotas, @error = @command.exec

  # Render the view
  erb :index
end
