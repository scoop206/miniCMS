class CreatePageSitesJoinTable < ActiveRecord::Migration
  def self.up
    create_table :pages_sites do |t|
      t.integer :site_id
      t.integer :page_id
      t.integer :page_source_id
      t.boolean :protected, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :pages_sites
  end
end
