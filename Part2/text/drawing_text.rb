require 'rubygems'
require 'opengl'
require 'sdl'

PI_TIMES_2_OVER_65536 = 2 * 3.1415926535 / 65536.0

class T3DLoadException < Exception
end

class T3DFont
	def initialize(input)
		buffer = input.read(8)
		header = "VTR\0FNT\0"
		8.times do |i|
			if buffer[i] != header[i]
				throw T3DLoadException("Invalid Font File")
			end
		end
		
		buffer = input.read(5)
		spaceWidth = buffer.to_f
		
		displayListId2d = glGenLists(94)
		displayListId3d = glGenLists(94)
		94.times do |i|
			buffer = input.read(5)
			scale = buffer.to_f / 65536
			buffer = input.read(2)
			width = scale * buffer.to_i
			buffer = input.read(2)
			height = scale * buffer.to_i
			scale /= height
			widths[i] = width / height
			buffer = input.read(2)
			numVerts = buffer.to_i
		end
	end
end

b = File.new("charset", "r")
a = T3DFont.new(b)