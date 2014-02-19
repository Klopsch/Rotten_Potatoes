class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
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

  def sort
    if(params[:sort_by])
      # If sort by has a value, call sorter
      Movie.order(sorter)
    else
      # Else return normal list of movies
      Movie.all
    end
  end

  def sorter
    sort_by = params[:sort_by]
    if(sort_by == "title")
      # Sorts by title and hilites Movie Title
      @title_class = "hilite"
      @release_date_class = "release_date"
    elsif sorter == "release_date"
      # Sorts by release date and hilites Release Date
      @title_class = "title"
      @release_date_class = "hilite"
    end
    # Return string for sorting
    "#{sort_by} ASC"
  end

end
