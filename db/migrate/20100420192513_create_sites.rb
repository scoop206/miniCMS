class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :name
      t.string :official_name
      t.string :url
      t.string :layout
      t.string :asset_folder, :default => ""
      t.timestamps
    end
  end

  def self.down
    drop_table :sites
  end
end
