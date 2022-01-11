class NodesController < ApplicationController
  def common_ancestor
    a = params[:a]

    b = params[:b]

    lowest, depth = Node.lowest_common_ancestor_and_depth(a, b)

    root = lowest.blank? ? nil : Node.root(a, b)

    render json: { lowest: lowest, root: root, depth: depth }.to_json
  end
end