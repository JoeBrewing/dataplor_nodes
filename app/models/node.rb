class Node < ApplicationRecord
  # This method finds the lowest common ancestor of the two passed node ids.
  def self.lowest_common_ancestor(a, b)
    # Get the two paths.
    node_a_path, node_b_path = get_node_paths(a, b)

    # Return earlier if either of the paths are blank.
    if node_a_path.blank? || node_b_path.blank?
      return 'One of the two nodes was not found.'
    end

    # Get the paths as an array.
    outer, inner = path_as_array(node_a_path, node_b_path)

    # Find the lowest common ancestor and return it.
    outer.each do |outer_node|
      inner.each do |inner_node|
        if outer == inner
          return outer
        end
      end
    end

    # Return 'nil' if no common ancestor was found.
    return nil
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

  def self.set_node_paths(nodes)
    not_added = []

    count = nodes.count

    nodes.each do |node|
      # Skip this record. If the parent id is blank then it is a root node and
      # the path has already been added.
      if node.parent_id.blank?
        next
      end
      
      parent = Node.where(node_id: node.parent_id).first
      
      if parent.path.blank?
        not_added << node

        next
      end

      node.update(path: "#{parent.path}.#{node.node_id}")
    end

    if not_added.blank? || not_added.count == count
      return
    end

    set_node_paths(not_added)
  end
  
  # This method extracts the root from the node path.
  def root
    # Use the node_id if the path contains a '.' otherwise use the number in
    # front of the first '.' Alternatively this could check to see if parent_id
    # is blank instead of seeing if the path contains a '.'
    path.index('.') ? path[0, path.index('.')] : node_id
  end
end