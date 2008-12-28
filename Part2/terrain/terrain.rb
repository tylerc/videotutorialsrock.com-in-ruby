require 'rubygems'
require 'opengl'

class Terrain
	def initialize(w, l)
		@w = w
		@l = l
		
		@hs = []
		l.times do |i|
			@hs[i] = [@w]
		end
		
		@normals = []
		l.times do |i|
			@normals[i] = [@w]
		end
	end
	
	def width
		return @w
	end
	
	def length
		return @l
	end
	
	# Sets the height at (x, z) to y
	def setHeight(x, z, y)
		@hs[z][x] = y
		@computedNormals = false
	end
	
	# Returns the height at (x, z)
	def getHeight(x, z)
		return @hs[z][x]
	end
end

class Vec3f
	def initialize(x, y, z)
		@v = []
		@v[0] = x
		@v[1] = y
		@v[2] = z
	end
	
	def [](index)
		return @v[index]
	end
	
	def *(scale)
		return Vec3f.new(@v[0] * scale, @v[1] * scale, @v[2] * scale)
	end
	
	def /(scale)
		return Vec3f.new(@v[0] / scale, @v[1] / scale, @v[2] / scale)
	end
	
	def +(other)
		return Vec3f.new(@v[0] + other[0], @v[1] + other[1], @v[2] + other[2])
	end
	
	def -(other)
		return Vec3f.new(@v[0] - other[0], @v[1] - other[1], @v[2] - other[2])
	end
	
	def -@
		return Vec3f.new(-@v[0], -@v[1], -@v[2])
	end
	
	def magnitude
		return Math.sqrt((@v[0] ** 2) + (@v[1] ** 2) + (@v[2] ** 2))
	end
	
	def magnitudeSquared
		return ((@v[0] ** 2) + (@v[1] ** 2) + (@v[2] ** 2))
	end
	
	def normalize
		m = magnitude
		return Vec3f.new(@v[0] / m, @v[1] / m, @v[2] / m)
	end
	
	def dot(other)
		return ((@v[0] * other[0]) + (@v[1] * other[1]) + (@v[2] * other[2]))
	end
	
	def cross(other)
		return Vec3f.new((@v[1] * other[2]) - (@v[2] * other[1]),
		(@v[2] * other[0]) - (@v[0] * other[2]),
		(@v[0] * other[1]) - (@v[1] * other[0]))
	end
	
	def to_s
		return '(' + @v[0].to_s + ',' + @v[1].to_s + ',' + @v[2].to_s + ')'
	end
end