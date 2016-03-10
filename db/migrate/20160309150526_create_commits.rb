class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :date
      t.references :user, index: true, foreign_key: true
      t.string :sha
      t.string :message
      t.string :email

      t.timestamps null: false
    end
  end
end
