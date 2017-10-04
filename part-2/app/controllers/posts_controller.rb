get "/posts" do
  @posts = Post.order("created_at DESC")
  erb :'posts/index'
end

post "/posts" do
  @post = Post.new(params[:post])
  if request.xhr?
    if @post.save
      erb :"/posts/_post", layout: false, locals: { post: @post }
    else
      @errors = @post.errors
      status 422
      erb :"/posts/new"
    end
  else
    if @post.save
      redirect "posts/#{@post.id}"
    else
      @errors = @post.errors.full_messages
      erb :"posts/new"
    end
  end
end

get "/posts/new" do
  @post = Post.new
  erb :'posts/new'
end

get "/posts/:id" do
  @post = Post.find(params[:id])
  erb :'posts/show'
end

put "/posts/:id/like" do
  @post = Post.find(params[:id])
  @post.increment!(:likes_count)
  redirect "/posts/#{@post.id}"
end
