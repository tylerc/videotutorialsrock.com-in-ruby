require 'rubygems'
require 'opengl'

class Terrain
	FALLOUT_RATIO = 0.5
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
	
	# Computes the normals, if they haven't been computed yet
	def computeNormals
		if @computedNormals
			return
		end
		
		@normals2 = []
		@l.times do |i|
			@normals2[i] = [@w]
		end
		
		@l.times do |z|
			@w.times do |x|
				@sum = Vec3f.new(0.0, 0.0, 0.0)
				
				if z > 0
					@out = Vec3f.new(0.0, @hs[z - 1][x] - @hs[z][x], -1.0)
				end
				
				if z < (@l - 1)
					@in = Vec3f.new(0.0, @hs[z + 1][x] - @hs[z][x], 1.0)
				end
				
				if x > 0
					@left = Vec3f.new(-1.0, @hs[z][x - 1] - @hs[z][x], 0.0)
				end
				
				if x < (@w - 1)
					@right = Vec3f.new(1.0, hs[z][x + 1] - hs[z][x], 0.0)
				end
				
				if x > 0 and z > 0
					@sum += @out.cross(@left).normalize
				end
				if x > 0 and z < (@l - 1)
					@sum += @left.cross(@in).normalize
				end
				if x < (@w - 1) and z < (@l - 1)
					@sum += @in.cross(@right).normalize
				end
				if x < (@w - 1) and z > 0
					@sum += @right.cross(@out).normalize
				end
				
				@normals2[z][x] = @sum
			end
		end
		
		# smooth out the normals
		#FALLOUT_RATIO = 0.5
		@l.times do |z|
			@w.times do |x|
				sum = @normals2[z][x]
				
				if x > 0
					sum += @normals2[z][x - 1] * FALLOUT_RATIO
				end
				if x < (@w - 1)
					sum += @normals2[z][x + 1] * FALLOUT_RATIO
				end
				if z > 0
					sum += @normals2[z - 1][x] * FALLOUT_RATIO
				end
				if z < (@l - 1)
					sum += @normals2[z + 1][x] * FALLOUT_RATIO
				end
				
				if (sum.magnitude == 0)
					sum = Vec3f.new(0.0, 1.0, 0.0)
				end
				@normals[z][x] = sum
			end
		end
		
		@normals2 = nil
		computedNormals = true
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