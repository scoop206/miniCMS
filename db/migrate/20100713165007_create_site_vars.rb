class CreateSiteVars < ActiveRecord::Migration
  def self.up
    create_table :site_vars do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :site_vars
  end
end
