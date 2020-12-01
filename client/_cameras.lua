-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.cameras = {}
c.cameras.store = {}

--[[
NOTES.
    - The purpose of this is simple. Everyone who scripts a camera makes the name CAM. I think that fucking stupid.
    - What happens when others all use the name CAM? It means that when they DONT DESTROY the CAM...
    - You have overlapping issues when ending cameras from different angles rather than snapping to the ped
    - Even if you don't destroy the camera, if its a different name, it should resolve the issues of weird cam shit happening.
]]--
math.randomseed(c.seed)
-- ====================================================================================--

function c.cameras.NewName(t)
    local val
    local find = false
    repeat
        val = c.rng.chars(15)
        if c.cameras.store[val] then
            find = true
        else
            table.insert(c.cameras.store, val)
            c.cameras.store[val] = t
            find = false
        end
    until find == false
    return val
end

-- ====================================================================================--

function c.cameras.MakeBasic(px, py, pz, rx, ry, rz, fov)
    local t = {['px'] = px, ['py'] = py, ['pz'] = pz, ['rx'] = x, ['ry'] = y, ['rz'] = z, ['fov'] = fov}
    local name = c.cameras.NewName(t)
    name = CreateCamWithParams(name, px, py, pz, rx, ry, rz, fov, false, 0)
    return name
end

function c.cameras.MakeAdvanced(px, py, pz, rx, ry, rz, fov)
    local t = {['px'] = px, ['py'] = py, ['pz'] = pz, ['rx'] = x, ['ry'] = y, ['rz'] = z, ['fov'] = fov}
    local name = c.cameras.NewName(t)
    name = CreateCamWithParams(name, px, py, pz, rx, ry, rz, fov, false, 0)
    return name
end