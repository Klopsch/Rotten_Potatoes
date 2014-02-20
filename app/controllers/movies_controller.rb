class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = sort
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

  def sort_and_filter
    if(params[:ratings] && params[:sort_by])
      Movie.where(rating: get_ratings).order(sort)
    elsif(params[:ratings])
      Movie.where(rating: get_ratings)
    elsif(params[:sort_by])
      Movie.order(sort)
    else
      # Else return normal list of movies
      Movie.all
    end
  end

  def sort_column
    sort_by = params[:sort_by]
    if(sort_by == "title")
      @title_class = "hilite"
      @release_date_class = "release_date"
    elsif sorter == "release_date"
      @title_class = "title"
      @release_date_class = "hilite"
    end
    "#{sort_by} ASC"
  end

  def get_ratings
    if(params[:ratings])
      params[:ratings].keys
    elsif(session[:ratings])
      session[:ratings].keys
    end
  end

  def check_box_toggle(rating)
    if(params[:ratings])
      get_ratings.include?(rating)
    else
      true
    end
  end

end
