class BooksController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :show, :index]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @book = Book.new
  end

  def create
    @new_book = Book.new(book_params)
    @new_book.user_id = current_user.id
    if @new_book.save
      flash[:notice] = "successfully posted."
      redirect_to book_path(@new_book.id)
    else
      @books = Book.includes(:user).all
      @user = current_user
      render :index
    end
  end

  def index
    @books = Book.all
    @new_book = Book.new
    @user = current_user
    @books = Book.includes(:user).all
  end

  def show
    @book = Book.find(params[:id])
    @new_book = Book.new
    @user = @book.user
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "successfully updated the post."
       redirect_to book_path(@book.id)
    else
      render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end


  private

  def book_params
    params.require(:book).permit(:title, :body, :profile_image)
  end

  def ensure_correct_user
    book = Book.find(params[:id])
    unless book.user == current_user
      redirect_to books_path
    end
  end

end
