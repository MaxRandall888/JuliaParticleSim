include("Particle.jl")

mutable struct OctreeNode
    region_center::Vector{Float64}  # Center of the region [x, y, z]
    region_size::Float64  # Length of the region's sides
    center_of_mass::Vector{Float64}  # [x, y, z]
    total_mass::Float64
    particles::Vector{Particle}  # Particles in this node
    children::Vector{Union{OctreeNode, Nothing}}  # Child nodes
end

struct Octree
    root::OctreeNode
end

function insert_particle!(node::OctreeNode, particle::Particle)
    # If the node is a leaf (no children), insert the particle here
    if isempty(node.children)
        push!(node.particles, particle)
        # Subdivide the node if there's more than one particle
        if length(node.particles) > 1
            subdivide_node!(node)
        end
    else
        # Find the correct child node for the particle and insert recursively
        idx = find_child_index(node, particle.position)
        insert_particle!(node.children[idx], particle)
    end
    # Update the center of mass and total mass
    update_mass_properties!(node, particle)
end

function find_child_index(node::OctreeNode, position::Vector{Float64})
    # Determine the index of the child node based on the position
    # (This function should return an integer between 1 and 8, representing the octant)
    # TODO: Implement the logic to calculate the correct child index
end

function update_mass_properties!(node::OctreeNode, particle::Particle)
    # Update the node's total mass and center of mass based on the new particle
    # TODO: Implement the logic to update mass properties
end

function subdivide_node!(node::OctreeNode)
    # Create eight children for the node, each representing an octant
    # TODO: Implement the logic to create and initialize child nodes
end
