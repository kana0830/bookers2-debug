class BookCommentsController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    @book_comment = BookComment.new(book_comment_params)
    @book_comment.book_id = @book.id
    @book_comment.user_id = current_user.id
    @comments = @book.book_comments
    if @book_comment.save
      render :create
    else
      flash[:notice] = "コメントを入力してください"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @book_comment = BookComment.find(params[:id])
    @book_comment.destroy
		render :destroy
  end

  private
    def book_comment_params
      params.require(:book_comment).permit(:comment)
    end
end
