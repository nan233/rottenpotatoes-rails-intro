class MoviesController < ApplicationController

  after_action  :store_uri_in_session
  
  def store_uri_in_session
    session[:previous] = (request.fullpath).to_yaml
  end
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:ratings]==nil
      redirect_to YAML.load(session[:previous])
    else
      @all_ratings = Movie.myratings
      @selected = @all_ratings
      if params[:ratings]!=nil
        @selected = (params[:ratings].keys)
      elsif session[:ratings]!=nil
        @selected = YAML.load(session[:ratings])
      end
    # if YAML.load(session[:title])
    #   session[:ratings] = @selected.to_yaml
    #   redirect_to title_header_path
    # elsif YAML.load(session[:release_date])
    #   session[:ratings] = @selected.to_yaml
    #   redirect_to release_date_header_path
    # else
    #   @movies = Movie.where({rating: @selected})
    #   session[:ratings] = @selected.to_yaml
    # end
      @movies = Movie.where({rating: @selected})
      session[:ratings] = @selected.to_yaml
    end
  end

  def title
    @all_ratings = Movie.myratings
    if session[:ratings].blank?
      @selected = @all_ratings
      @movies = Movie.order(:title)
    else
      @selected = YAML.load(session[:ratings])
      @movies = Movie.where({rating: @selected}).order(:title)
    end
    session[:title] = true.to_yaml
    session[:release_date] = false.to_yaml
  end
  
  def release
    @all_ratings = Movie.myratings
    if session[:ratings].blank?
      @selected = @all_ratings
      @movies = Movie.order(:release_date)
    else
      @selected = YAML.load(session[:ratings])
      @movies = Movie.where({rating: @selected}).order(:release_date)
    end
    session[:title] = false.to_yaml
    session[:release_date] = true.to_yaml
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

end
