class Node < ApplicationRecord
  # I do not typically like to have a method perform two functions like this,
  # but it seemed like the most efficient way to get both values. Would spend
  # more time on this part if I had more time.
  # This method finds the lowest common ancestor of the two passed node ids.
  def self.lowest_common_ancestor_and_depth(a, b)
    # Get the two paths.
    node_a_path, node_b_path = get_node_paths(a, b)

    # Return earlier if either of the paths are blank.
    if node_a_path.blank? || node_b_path.blank?
      return nil
    end

    # Get the paths as an array.
    outer, inner = path_as_array(node_a_path, node_b_path)

    # Find the lowest common ancestor, the depth, and return them
    outer.each_with_index do |outer_node, i|
      inner.each do |inner_node|
        if outer_node == inner_node
          return outer_node, i + 1
        end
      end
    end

    # Return 'nil' if no common ancestor was found.
    return nil, nil
  end

  # This method gets the path to both nodes.
  def self.get_node_paths(a,b)
    # Get the path to node a.
    node_a = Node.where(node_id: a).first&.path

    # Get the path to node b.
    node_b = Node.where(node_id: b).first&.path

    return node_a, node_b
  end
  
  # This method splits both paths into an array. It then returns `outer` and
  # `inner` with `outer` being the larger of the two arrays.
  def self.path_as_array(path_a, path_b)
    # Get path a as an array.
    path_a_split = split_path(path_a)

    # Get path b as an array.
    path_b_split = split_path(path_b)

    # Get outer and inner based on which is larger.
    if path_a_split.count > path_b_split.count
      outer = path_a_split
      inner = path_b_split
    else
      outer = path_b_split
      inner = path_a_split
    end

    # Return outer and inner.
    return outer, inner
  end

  # This method splits the path into an array of ancestors.
  def self.split_path(path)
    path.split('.')
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
  def self.root(a,b)
    # Get node a.
    node_a = Node.where(node_id: a).first

    # Get node b.
    node_b = Node.where(node_id: b).first

    # Get the path for node a as an array.
    path_a = split_path(node_a.path)

    # Get the path for node b as an array.
    path_b = split_path(node_b.path)

    # Return the first element in the array if the root element in both arrays
    # match.
    if path_a[0] == path_b[0]
      return path_a[0]
    end

    # Return nil to indicate that no root was found.
    nil
  end
end