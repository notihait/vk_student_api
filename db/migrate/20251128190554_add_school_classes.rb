class AddSchoolClasses < ActiveRecord::Migration[8.0]
  def change
    create_table :school_classes do |t|
      t.references :school, null: false, foreign_key: true
      t.integer :number

      t.timestamps
    end
  end
end
