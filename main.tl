local radius: number = 10
local dz: number = 1
local a: number = 0

local record Vector2
   x: number
   y: number
end

local record Vector3
   x: number
   y: number
   z: number
end

local vertices: {Vector3} = {
     {x = -0.25, y = 0.00, z = -0.25},
      {x =  0.25, y = 0.00, z = -0.25},
      {x =  0.25, y = 0.00, z =  0.25},
      {x = -0.25, y = 0.00, z =  0.25},
      {x = -0.25, y = 0.45, z = -0.25},
      {x =  0.25, y = 0.45, z = -0.25},
      {x =  0.25, y = 0.45, z =  0.25},
      {x = -0.25, y = 0.45, z =  0.25},
      {x = -0.25, y = 0.95, z = -0.25},
      {x =  0.25, y = 0.95, z = -0.25}
}

local fs: {{number}} = {
   {1, 2, 4, 3},
   {5, 6, 8, 7},
   {1, 2, 6, 5},
   {3, 4, 8, 7},
   {1, 3, 7, 5},
   {2, 4, 8, 6}
   
}

local function project(v: Vector3): Vector2
   return { x = v.x / v.z, y = v.y / v.z }
end

local function screen(v: Vector2): Vector2
   return {
      x = (v.x + 1) / 2 * love.graphics.getWidth(),
      y = (v.y + 1) / 2 * love.graphics.getHeight(),
   }
end

local function translate_z(v: Vector3): Vector3
   return {
      x = v.x, y = v.y, z = v.z + dz
   }
end

local function rotate_xz(v: Vector3, angle: number): Vector3
   local c: number = math.cos(angle)
   local s: number = math.sin(angle)

   return {
      x = v.x * c - v.z * s,
      y = v.y,
      z = v.x * s + v.z * c
   }
end

local function nor(v: Vector3): Vector3
   return {
      x =  v.x / 255,
      y =  v.y / 255,
      z =  v.z / 255
   }
end

local function line(v1: Vector3, v2: Vector3)
   love.graphics.line(v1.x, v1.y, v2.x, v2.y)
end


local function drawPoint(p: Vector2)
   love.graphics.circle("fill", p.x, p.y, radius)
end

function love.load(_args: {string}, _unfiltered: {string})
   local w, h = love.graphics.getDimensions()
   print("w: " .. w .. "\nh: " .. h)
end

function love.update(dt: number)
   --dz = dz + 1 * dt
   a = a  + math.pi * dt
end


function love.draw()
   love.graphics.clear(0.95, 0.50, 0.66, 1, false, false)
   love.graphics.setColor(0.55, 0.33, 0.77, 1)
   for _, v in ipairs(vertices) do
      local p = screen(project(translate_z(rotate_xz(v, a))))
      drawPoint(p)
   end
      for _, f in ipairs(fs) do
      for i = 1, #f do
         local v1: Vector3 = vertices[f[i]]
         local v2: Vector3 = vertices[f[i % #f + 1]]
         local p1: Vector3 = screen(project(translate_z(rotate_xz(v1, a))))
	 local p2: Vector3 = screen(project(translate_z(rotate_xz(v2, a))))
         love.graphics.line(p1.x, p1.y, p2.x, p2.y)
      end
   end
end
