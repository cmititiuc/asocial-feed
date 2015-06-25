class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_posts, only: [:index, :create, :update]

  # GET /posts
  # GET /posts.json
  def index
    @post = Post.new
    @day = nil
    @current_or_guest_user = current_or_guest_user
    @tags = current_or_guest_user.owned_tags
    @examples = %w(_emphasis_ *strong* -deleted\ text- +inserted\ text+ ^superscript^ ~subscript~
                   @code@ h3.\ Header\ 3 bq.\ Blockquote #\ Numeric\ list *\ Bulleted\ list)
    @examples << "\"This is a link (This is a title)\":http://example.org"
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    respond_to do |format|
      format.html
      format.json {
        @post.body = RedCloth.new(@post.body).to_html.html_safe
        render :json => @post.to_json(:include => :tags)
      }
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
    @tags = current_or_guest_user.owned_tags
  end

  # GET /posts/1/edit
  def edit
    @current_or_guest_user = current_or_guest_user
    @tags = @current_or_guest_user.owned_tags
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @current_or_guest_user = current_or_guest_user
    tag_list = params[:post].delete(:tag_list)
    @post = current_or_guest_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        current_or_guest_user.tag(@post, :with => tag_list.join(','), :on => :tags) unless tag_list.nil?

        format.html { redirect_to (params[:return_to] ? params[:return_to] : @post), notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
        format.js { render :create, :locals => { notice: 'Post was successfully created.' }}
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
        format.js { render :create, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    @current_or_guest_user = current_or_guest_user
    tag_list = params[:post].delete(:tag_list)

    respond_to do |format|
      if @post.update(post_params)
        current_or_guest_user.tag(@post, :with => tag_list.join(','), :on => :tags) unless tag_list.nil?

        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
        format.js { render :update, :locals => { notice: 'Post was successfully updated.' }}
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
        format.js { render :update, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @current_or_guest_user = current_or_guest_user
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
      format.js { render :destroy, :locals => { notice: 'Post was successfully destroyed.' }}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = current_or_guest_user.posts.find(params[:id])
    end

    def set_posts
      @posts = current_or_guest_user.posts
      if params[:tags]
        if params[:tags] == ''
          @posts = @posts.tagged_with(current_or_guest_user.owned_tags.map(&:name), :exclude => true)
        else
          @posts = @posts.tagged_with(params[:tags])
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:body, :user_id, :return_to, :tag_list => [])
    end
end
