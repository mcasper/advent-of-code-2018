class Node
  def initialize(metadata:, nodes:)
    @metadata = metadata
    @nodes = nodes
  end

  def metadata_sum
    metadata.sum + nodes.map(&:metadata_sum).sum
  end

  attr_reader :metadata, :nodes
end

def parse_node(children_count, metadata_count, lazy)
  children = 0.upto(children_count-1).map { parse_node(lazy.next, lazy.next, lazy) }
  metadata = 0.upto(metadata_count-1).map { lazy.next.to_i }
  Node.new(metadata: metadata, nodes: children)
end

numbers = File.read("input.txt").strip.split(" ").map(&:to_i)

lazy = numbers.lazy
puts parse_node(lazy.next, lazy.next, lazy).metadata_sum
