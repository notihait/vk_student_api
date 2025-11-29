class AddLetterToSchoolClasses < ActiveRecord::Migration[8.0]
  def change
    add_column :school_classes, :letter, :string
  end
end
