class CookbooksRecipes < ActiveRecord::Migration
  def change
    create_table :cookbooks_recipes, id: false do |t|
      t.belongs_to :cookbook, index: true
      t.belongs_to :recipe, index: true
    end
  end
end
