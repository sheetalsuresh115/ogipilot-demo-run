class AddCommentsToFunctionalLocation < ActiveRecord::Migration[7.1]
  def change
    add_column :functional_locations, :comments, :string
  end
end
