class Node < ApplicationRecord
  # This method extracts the root from the node path.
  def root
    # Use the node_id if the path contains a '.' otherwise use the number in
    # front of the first '.' Alternatively this could check to see if parent_id
    # is blank instead of seeing if the path contains a '.'
    path.index('.') ? path[0, path.index('.')] : node_id
  end
end