struct Particle
    position::Vector{Float64}  # [x, y, z]
    velocity::Vector{Float64}  # [vx, vy, vz]
    mass::Float64
    color::String  # Optional, for visualization
    size::Float64  # Optional, for visualization
end