class BooksController < ApplicationController
	before_action :authenticate_user!

  def show
		@book = Book.find(params[:id])
		@user = current_user
		@book_new = Book.new
		@comment = BookComment.new
  end

  def index
		@books = Book.all #一覧表示するためにBookモデルの情報を全てくださいのall
		@book = Book.new
  end

  def create
		@book = Book.new(book_params) #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
		@book.user_id = current_user.id
  	if @book.save #入力されたデータをdbに保存する。
  		redirect_to @book, notice: "successfully created book!"#保存された場合の移動先を指定。
  	else
  		@books = Book.all
  		render 'index'
  	end
  end

  def edit
		@book = Book.find(params[:id])
		screen_user(@book)
  end

  def update
  	@book = Book.find(params[:id])
  	if @book.update(book_params)
  		redirect_to @book, notice: "successfully updated book!"
  	else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
  		render "edit"
  	end
  end

  def destroy
  	@book = Book.find(params[:id])
  	@book.destroy
  	redirect_to books_path, notice: "successfully delete book!"
  end

  private

  def book_params
  	params.require(:book).permit(:title, :body)
	end

	def screen_user(book)
		if book.user.id != current_user.id
			redirect_to books_path
		end
	end
	
end
