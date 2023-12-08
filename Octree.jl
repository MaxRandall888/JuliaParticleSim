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
    x_index = position[1] > node.region_center[1] ? 1 : 0
    y_index = position[2] > node.region_center[2] ? 1 : 0
    z_index = position[3] > node.region_center[3] ? 1 : 0

    # Combine the indices to get the octant number (1-8)
    return 1 + x_index + 2*y_index + 4*z_index
end

function update_mass_properties!(node::OctreeNode, particle::Particle)
    # Update the node's total mass and center of mass based on the new particle
    # TODO: Implement the logic to update mass properties
end

function subdivide_node!(node::OctreeNode)
    # Create eight children for the node, each representing an octant
    # TODO: Implement the logic to create and initialize child nodes
    x_lim = node.region_center[1] + node.region_size / 2
    y_lim = node.region_center[2] + node.region_size / 2
    z_lim = node.region_center[3] + node.region_size / 2
    
end
