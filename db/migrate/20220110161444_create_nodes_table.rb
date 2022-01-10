class CreateNodesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :nodes do |t|
      t.integer :node_id
      t.integer :parent_id
      t.ltree :path

      t.index :parent_id
      t.index :node_id
    end
  end
end
