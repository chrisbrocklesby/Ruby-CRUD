###### Required #######
require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/database.db")

class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String, :required => true
  property :slug, String, :required => true
  property :body, Text, :required => true
end

DataMapper.finalize.auto_upgrade!

get "/" do
  erb :home
end

get "/post" do
  @posts = Post.all
  erb :index
end

get "/post/new" do
  erb :new
end

post "/post/new" do
  data = Post.new
  data.title = params[:title]
  data.slug = params[:slug]
  data.body = params[:body]
  
  if(data.save)
    @message = "Your new post was saved."
  else
    @message = "Your new post was NOT saved."
  end
  
  erb :new
end

get "/post/edit/:id" do
  @post = Post.get(params[:id])
  erb :edit
end

post "/post/edit/:id" do
  data = Post.get(params[:id]).update(
    :title => params[:title], 
    :slug => params[:slug], 
    :body => params[:body]
  )
  
  if(data)
    @message = "Your new post was updated."
  else
    @message = "Your new post was NOT updated."
  end

  redirect('/post')
end

get "/post/:id" do
  @post = Post.get(params[:id])
  erb :view
end

get "/post/delete/:id" do
  Post.get(params[:id]).destroy
  redirect('/post')
end