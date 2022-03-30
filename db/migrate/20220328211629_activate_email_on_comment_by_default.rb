class ActivateEmailOnCommentByDefault < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :email_on_comment, :boolean, default: true
    change_column :users, :email_on_comment_reply, :boolean, default: true
  end
end
