module NodeProcessing
  class Processor
    # This is a class to help with some of the node processing logic.
    
    def initialize(a, b)
      # Get node a.
      @node_a = Node.where(node_id: a).first

      # Get node b.
      @node_b = Node.where(node_id: b).first
    end

    # This method gets the lowest common ancestor and depth.
    def get_lowest_common_ancestor_and_depth
      # Get the two paths.
      node_a_path, node_b_path = get_node_paths()

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
    def get_node_paths()
      return @node_a&.path, @node_b&.path
    end

    # This method splits both paths into an array. It then returns `outer` and
    # `inner` with `outer` being the larger of the two arrays.
    def path_as_array(path_a, path_b)
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
    def split_path(path)
      return nil if path.blank?

      path.split('.')
    end

    # This method gets the root of the two nodes.
    def get_root()
      # Get the path for node a as an array.
      path_a = split_path(@node_a&.path)

      # Get the path for node b as an array.
      path_b = split_path(@node_b&.path)

      # Return early if either of our paths are empty.
      return nil if path_a.blank? || path_b.blank?

      # Return the first element in the array if the root element in both arrays
      # match.
      if path_a[0] == path_b[0]
        return path_a[0]
      end

      # Return nil to indicate that no root was found.
      nil
    end
  end
end