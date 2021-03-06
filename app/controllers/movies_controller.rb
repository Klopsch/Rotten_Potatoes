class MoviesController < ApplicationController
  helper_method :check_box_toggle
  before_filter :set_session_params

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    set_params_from_session
    @all_ratings = Movie.ratings_set
    @movies = sort_and_filter
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

  def sort
    sort_by = params[:sort_by]
    if(sort_by == "title")
      @title_class = "hilite"
      @release_date_class = "release_date"
    elsif(sort_by == "release_date")
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

  def set_session_params
    session[:ratings] ||= params[:ratings] if params[:ratings]
    session[:sort_by] ||= params[:sort_by] if params[:sort_by]
  end

  def set_params_from_session
    if(params[:sort_by] || params[:ratings])
      return
    elsif(session[:sort_by] && session[:ratings])
      redirect_to movies_path(sort_by: session[:sort_by], rating: params[:ratings])
    elsif(session[:sort_by])
      redirect_to movies_path(sort_by: session[:sort_by])
    elsif(session[:ratings])
      redirect_to movies_path(rating: params[:ratings])
    end
  end

end
