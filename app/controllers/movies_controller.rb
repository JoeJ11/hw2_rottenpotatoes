class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = []
    @rating_flag = {}
	@all_ratings = Movie.get_all_ratings
    redirect_flag = false
    
    if !session
      list = Hash.new
      @all_ratings.each do |x|
        @rating_flag[x] = true
        list[x] = true
      end
      @movies = Movie.all
      session[:ratings] = list
      #session[:sort_by] = ""
    end

    if params.has_key?(:data_package)
      list = params[:data_package]
      params[:ratings] = list[:ratings] if list.has_key?(:ratings)
      params[:sort_by] = list[:sort_by] if list.has_key?(:sort_by)
    end

    if params.has_key?(:ratings)
      session[:ratings] = params[:ratings]

      selected_ratings = params[:ratings]
      selected_ratings.each do |key, content|
        @rating_flag[key] = true
        @movies += Movie.find_all_by_rating(key)
      end
    elsif session.has_key?(:ratings)
      redirect_flag = true
    #else
    #  @all_ratings.each do |x|
    #    @rating_flag[x] = true
    #  end
    #  @movies = Movie.all
    end

    if params.has_key?(:sort_by)
      if params[:sort_by] == 'title'
        session[:sort_by] = params[:sort_by]
        @movies = @movies.sort_by do |x|
          x.title
        end
        @flag = 'title'
      elsif params[:sort_by] == 'date'
        session[:sort_by] = params[:sort_by]
        @movies = @movies.sort_by do |x|
          x.release_date
        end
        @flag = 'date'
      end
    elsif session.has_key?(:sort_by)
      redirect_flag = true
    end
    
    if redirect_flag
      redirect_to movies_path(:data_package => session)
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
