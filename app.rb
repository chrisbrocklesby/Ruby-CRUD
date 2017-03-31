###### Required #######
require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/database.db")

class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :slug, String
  property :body, Text
end

DataMapper.finalize

Post.auto_upgrade!

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
    @message = "Your post was saved."
  else
    @message = "Your post was NOT saved."
  end
  
  erb :new
end
  
get "/post/:id" do
  @post = Post.get(params[:id])
  erb :view
end

get "/post/delete/:id" do
  Post.get(params[:id]).destroy
  redirect('/post')
end