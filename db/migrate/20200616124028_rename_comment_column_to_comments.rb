class RenameCommentColumnToComments < ActiveRecord::Migration[5.2]
  def change
    rename_column :comments, :comment, :comment_text
  end
end
