class AddPathIndexToNodes < ActiveRecord::Migration[6.0]
  def change
    add_index(:nodes, :path, using: 'gist', opclass: {title: :gist_trgm_ops})
  end
end
