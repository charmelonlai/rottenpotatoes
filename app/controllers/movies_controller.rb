class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	param_sort = params[:sort]
	param_rating = params[:ratings]
    	@all_ratings = ['G','PG','PG-13','R']
	@sort = param_sort
	if !param_sort && session[:sort]
		param_sort = session[:sort]
		@sort = param_sort
	else
		session[:sort] = @sort
	end
	if param_rating
		session[:ratings] = param_rating.keys
	else
		redirect_to movies_path(:sort => @sort, :ratings => Hash[session[:ratings].map{|i| [i, 'checked']}])
	end

	@movies = Movie.find(:all, :order=>@sort, :conditions=> {:rating=>session[:ratings]})
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
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
    redirect_to movies_path
  end

end
