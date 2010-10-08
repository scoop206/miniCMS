class CreateSiteSiteVars < ActiveRecord::Migration
  def self.up
    create_table :site_site_vars do |t|
      t.integer :site_id
      t.integer :site_var_id
      t.text :value

      t.timestamps
    end
  end

  def self.down
    drop_table :site_site_vars
  end
end
