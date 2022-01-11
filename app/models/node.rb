class Node < ApplicationRecord
  has_many :birds, primary_key: :node_id
  
  # I do not typically like to have a method perform two functions like this,
  # but it seemed like the most efficient way to get both values. Would spend
  # more time on this part if I had more time.
  # This method finds the lowest common ancestor of the two passed node ids.
  def self.lowest_common_ancestor_and_depth(processor)
    processor.get_lowest_common_ancestor_and_depth
  end

  # This method sets the node paths for the passed nodes.
  def self.set_node_paths(nodes)
    # Initialize an array to hold the nodes that did not have paths added.
    not_added = []

    # Get the node count before the loop.
    count = nodes.count

    # Loops through the nodes.
    nodes.each do |node|
      # Skip this record. If the parent id is blank then it is a root node and
      # the path has already been added.
      if node.parent_id.blank?
        next
      end
      
      # Get the node parent.
      parent = Node.where(node_id: node.parent_id).first
      
      # Check to see if the parent path is blank.
      if parent.path.blank?
        # Add the node to the not added array.
        not_added << node

        # Move to the next node.
        next
      end

      # Update the node path to be the parent path plus the node id.
      node.update(path: "#{parent.path}.#{node.node_id}")
    end

    # If the not added array is blank or if the not added count has not changed
    # then we return. If the count has not changed then it is more than likely
    # that there are data issues.
    if not_added.blank? || not_added.count == count
      return
    end

    # Recursively call this method passing in the nodes that still have not been
    # added.
    set_node_paths(not_added)
  end
  
  # This method extracts the root from the node path.
  def self.root(processor)
    processor.get_root
  end

  # This method gets all of the `Bird` ids of the records related to the passed
  # node ids.
  def self.related_birds(nodes)
    # Initializes this as an empty array of birds.
    birds = []

    # Loop through each node.
    nodes.each do |node_id|
      node = Node.where(node_id: node_id).first
      
      # Skip this record if the relationship is empty.
      next if node.birds.blank?

      # Add the bird ids to the related_birds array.
      birds << node.birds.pluck[:id]
    end

    # Return the array of related birds.
    birds
  end
end