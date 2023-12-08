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