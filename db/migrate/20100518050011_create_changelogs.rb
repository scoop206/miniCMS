class CreateChangelogs < ActiveRecord::Migration
  def self.up
    create_table :changelogs do |t|
      t.string :user
      t.string :text
      t.datetime :date

      t.timestamps
    end
  end

  def self.down
    drop_table :changelogs
  end
end
