class CreateUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :urls do |t|
      t.string :endpoint, null: false
      t.string :slug, index: true, null: false
      t.datetime :expiration
      t.belongs_to :user, index: true, foreign_key: true, null: false
      t.timestamps
    end
  end
end
