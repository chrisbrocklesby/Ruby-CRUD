###### Required #######
require 'sinatra'
require 'data_mapper'

###### Database Components #######
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/database.db")

class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String, :required => true
  property :slug, String, :required => true
  property :body, Text, :required => true
end

DataMapper.finalize.auto_upgrade!

###### 404 Error ######
not_found do
  status 404
  erb :"error/404"
end

###### 500 Error ######
error 500 do
  status 500
  erb :"error/500"
end

###### Home Route #######
get "/" do
  @pageTitle = "Home Page"
  erb :home
end

###### Post Index Route #######
get "/post" do
  @pageTitle = "Post Index"
  @posts = Post.all # Get all posts.
  erb :"post/index"
end

###### New Post Routes #######
get "/post/new" do
  @pageTitle = "New Post"
  erb :"post/new"
end

post "/post/new" do
  data = Post.new
  data.title = params[:title]
  data.slug = params[:slug]
  data.body = params[:body]
  
  if(data.save)
    redirect('/post')
  else
    status 500
  end 
end

###### Edit Post Routes #######
get "/post/edit/:id" do
  @pageTitle = "Edit Post"
  @post = Post.get(params[:id]) # Get post by ID.
  erb :"post/edit"
end

post "/post/edit/:id" do
  data = Post.get(params[:id]).update(
    :title => params[:title], 
    :slug => params[:slug], 
    :body => params[:body]
  )
  
  if(data)
    redirect('/post')
  else
    status 500
  end 
end

###### View Post Route #######
get "/post/:id" do
  @pageTitle = "View Post"
  @post = Post.get(params[:id]) # Get post by ID.
  erb :"post/view"
end

###### Delete Post Route #######
get "/post/delete/:id" do
  Post.get(params[:id]).destroy # Get post by ID then delete.
  redirect('/post')
end