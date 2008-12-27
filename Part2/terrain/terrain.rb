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
end