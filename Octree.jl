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

function create_octree(region_center::Vector{Float64}, region_size::Float64)
    # TODO: Create and return a new Octree with a root node
    
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
    # Update the total mass
    new_total_mass = node.total_mass + particle.mass
    if node.total_mass == 0
        # If the node had no mass, the new center of mass is the particle's position
        node.center_of_mass = particle.position
    else
        # Update the center of mass
        node.center_of_mass = (node.center_of_mass .* node.total_mass .+ particle.position .* particle.mass) ./ new_total_mass
    end
    node.total_mass = new_total_mass
end

function subdivide_node!(node::OctreeNode)
    # Calculate the limits for subdivision
    half_size = node.region_size / 2
    quarter_size = node.region_size / 4

    new_centers = [
        node.region_center + [-quarter_size, -quarter_size, -quarter_size],
        node.region_center + [quarter_size, -quarter_size, -quarter_size],
        node.region_center + [-quarter_size, quarter_size, -quarter_size],
        node.region_center + [quarter_size, quarter_size, -quarter_size],
        node.region_center + [-quarter_size, -quarter_size, quarter_size],
        node.region_center + [quarter_size, -quarter_size, quarter_size],
        node.region_center + [-quarter_size, quarter_size, quarter_size],
        node.region_center + [quarter_size, quarter_size, quarter_size]
    ]

    # Initialize children with new centers and half the size
    node.children = [OctreeNode(center, half_size, zeros(3), 0.0, Particle[], OctreeNode[]) for center in new_centers]
end

function traverse_octree(node::OctreeNode)
    # TODO: Implement a function to traverse the tree (e.g., for calculations or debugging)
end

function update_octree!(tree::Octree)
    # TODO: Implement logic to check if particles have moved out of their node's region
    # and need to be reinserted

    # Recursively update mass properties starting from the root
    update_mass_properties!(tree.root)
end


function remove_particle!(node::OctreeNode, particle::Particle)
    if isempty(node.children)
        filter!(p -> p != particle, node.particles)
    else
        idx = find_child_index(node, particle.position)
        remove_particle!(node.children[idx], particle)
    end
    #! Note: We're not calling update_mass_properties! be sure
    #!       to call it any time you call remove_particle!
end
