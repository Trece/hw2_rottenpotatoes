class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @range = @all_ratings 
    if params['commit'] then
      @range = @all_ratings.select {|rating| rating if params['rating'][rating.to_sym]}
    end
    if params['c_rating'] then
      @range = params['c_rating']
    end
    @movies = Movie.where :rating => @range
    @flag = params[:sort_by]
    if @flag == 'title' then
      @movies = @movies.sort_by {|movie| movie.title}
    elsif @flag == 'date' then
      @movies = @movies.sort_by {|movie| movie.release_date} 
    end
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
