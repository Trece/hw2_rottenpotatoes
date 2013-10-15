class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @range = @all_ratings 
    ratings = if params['rating'] then params['rating'] else session['rating'] end
    @flag = if params['sort_by'] then params['sort_by'] else session['sort_by'] end
    if ratings then
      @range = @all_ratings.select {|rating| rating if ratings[rating]}
    end
    @movies = Movie.where :rating => @range
    if @flag == 'title' then
      @movies = @movies.sort_by {|movie| movie.title}
    elsif @flag == 'date' then
      @movies = @movies.sort_by {|movie| movie.release_date} 
    end
    session['sort_by'] = @flag
    session['rating'] = ratings
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
