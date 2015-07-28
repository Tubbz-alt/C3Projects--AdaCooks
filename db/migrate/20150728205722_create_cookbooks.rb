class CreateCookbooks < ActiveRecord::Migration
  def change
    create_table :cookbooks do |t|
      t.string :name, null: false
      t.string :description
      t.string :user_id
      t.timestamps null: false
    end
  end
end
