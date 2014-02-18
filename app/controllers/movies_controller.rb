# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController

  def index
    set_session_params
    @all_ratings = Movie.all_ratings
    @movies = sort_and_ratings
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # Look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
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

  def sort_and_ratings
    if(params[:sort])
      Movie.order(sorter)
    end
  end

  def sorter
    sort_by = params[:sort]
    if(sort_by == 'title')
      @title_class = "hilite"
      @release_date_class = "release_date"
    elsif(sort_by == 'release_date')
      @title_class = "title"
      @release_date_class = "hilite"
    end

    return "#{sort_by} ASC"
  end

  def set_session_params
    if(params[:sort] || params[:ratings])
      return
    elsif(session[:sort] && session[:ratings])
      redirect_to movies_path(sort: session[:sort], rating: params[:ratings])
    elsif(session[:sort])
      redirect_to movies_path(sort: session[:sort])
    elsif(session[:ratings])
      redirect_to movies_path(ratings: params[:ratings])
    end
  end

end
