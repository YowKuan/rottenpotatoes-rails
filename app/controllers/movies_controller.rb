class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @ratings_to_show = []
    @ordering_param = ''
#     session[:ratings] = params[:ratings] unless params[:ratings].nil?
#     session[:order] = params[:order] unless params[:order].nil?
#     logger.debug(session[:ratings])
#     logger.debug(session[:order])
    if params[:order]
      @movies = Movie.order(params[:order])
      @ordering_param = params[:order]
    end

    if params[:ratings]
      @ratings_to_show = params[:ratings].keys

      @movies = Movie.where(Rating: @ratings_to_show )
    end
    if params[:order] && params[:ratings]
      logger.debug("Both exist!")
      @movies = Movie.where(Rating: @ratings_to_show).order(params[:order])
    end
    logger.debug("rating")
    logger.debug(@ratings_to_show)
    logger.debug("order")
    logger.debug(params[:order])
      
#     if session[:ratings] != nil && session[:order] != nil
#       logger.debug("Both of them not null!")
#       logger.debug(@ratings_to_show)
#       @movies = Movie.order(session[:order]).where(Rating: @ratings_to_show)
#     end
      

#     #logger.debug(@all_ratings)

# #     logger.debug(params[:ratings])
# #     logger.debug(params[:order])
#     if params[:order]
#       @movies = Movie.order(params[:order])
#     end
      
#     if params[:ratings]
#       @ratings_to_show = params[:ratings].keys
#       #logger.debug(@ratings_to_show)
#       @movies = Movie.where(Rating: @ratings_to_show )
#     end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
