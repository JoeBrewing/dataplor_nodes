require 'node_processing/processor'

class NodesController < ApplicationController
  def common_ancestor
    # Get a.
    a = params[:a]

    # Get b.
    b = params[:b]

    # Get the node processor.
    processor = NodeProcessing::Processor.new(a, b)

    # Get lowest and depth.
    lowest, depth = Node.lowest_common_ancestor_and_depth(processor)

    # Get root.
    root = lowest.blank? ? nil : Node.root(processor)

    # Render lowest, root, and depth as json.
    render json: { lowest: lowest, root: root, depth: depth }.to_json
  end
end