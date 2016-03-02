require 'slim'
require 'dm-core'
require 'slim/include'
require 'sinatra/base'
require 'dm-migrations'


class TaskList
  include DataMapper::Resource
  property :id, Serial
  property :url, String, :length => 256
  property :subject, String, :length => 256
  property :memo, String, :length => 1024
  property :del_flg, Boolean, :default => false
  property :create_dt, DateTime
  property :update_dt, DateTime
end

DataMapper.finalize

DataMapper.setup(:default, "yaml:///tmp/taskmanger")
TaskList.auto_upgrade!

class App < Sinatra::Base
  get '/' do
    @task = TaskList.all
    slim :index
  end

  get '/add' do
    slim :task
  end

  post '/add' do
    now = Time.now
    task = TaskList.create(:url => params[:url], :subject => params[:subject], :memo => params[:memo], :create_dt => now, :update_dt => now)
    @task = TaskList.first(:id => task[:id])
    slim :task
  end
  
  get '/task/:id' do
    @task = TaskList.first(:id => params[:id])
    slim :task
  end

  post '/task/{:id}' do
    task = TaskList.first(:id => params[:id])
    task.update(:url => params[:url], :subject => params[:subject], :memo => params[:memo], :update_dt => now)
    @task = TaskList.first(:id => params[:id])
    slim :task
  end
end

