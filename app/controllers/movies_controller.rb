class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	@all_ratings = Movie.ratings
	session[:sort_by] = params[:sort_by] ? params[:sort_by] : session[:sort_by]
	session[:ratings] = (params[:commit] or params[:ratings]) ? params[:ratings] : session[:ratings]
  
  if (session[:sort_by] != params[:sort_by] or session[:ratings] != params[:ratings])
          redirect_to movies_path(:sort_by => session[:sort_by], :ratings => session[:ratings])
  end

	@ratings = session[:ratings] ? session[:ratings].keys : []

	if @ratings.empty?
		@movies = Movie.order("#{session[:sort_by]}").all
	else
		@movies = Movie.order("#{session[:sort_by]}").find_all_by_rating(@ratings)
	end
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path(:sort_by => session[:sort_by], :ratings => session[:ratings])
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path(:sort_by => session[:sort_by], :ratings => session[:ratings])
  end

end 
