class RenameCommentTextColumnToBookComments < ActiveRecord::Migration[5.2]
  def change
    rename_column :book_comments, :comment_text, :comment
  end
end
