class AddAuthTokenToStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :auth_token, :string
    add_index :students, :auth_token, unique: true
  end
end
