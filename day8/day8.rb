class Node
  def initialize(metadata:, nodes:)
    @metadata = metadata
    @nodes = nodes
  end

  def metadata_sum
    metadata.sum + nodes.map(&:metadata_sum).sum
  end

  def value
    if nodes.empty?
      metadata.sum
    else
      metadata.map { |m| nodes[m-1]&.value }.compact.sum
    end
  end

  attr_reader :metadata, :nodes
end

def parse_node(children_count, metadata_count, lazy)
  children = children_count.times.map { parse_node(lazy.next, lazy.next, lazy) }
  metadata = metadata_count.times.map { lazy.next.to_i }
  Node.new(metadata: metadata, nodes: children)
end

numbers = File.read("input.txt").strip.split(" ").map(&:to_i)

lazy = numbers.lazy
tree = parse_node(lazy.next, lazy.next, lazy)
puts tree.metadata_sum
puts tree.value
