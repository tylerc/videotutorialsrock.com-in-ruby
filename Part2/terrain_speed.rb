require 'rubygems'
require 'opengl'
require 'sdl'
require 'vec3f'

class Terrain
	FALLOUT_RATIO = 0.5
	def initialize(w, l)
		@w = w
		@l = l
		
		@hs = []
		@l.times do |i|
			@hs[i] = [@w]
		end
		
		@normals = []
		@l.times do |i|
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
					@right = Vec3f.new(1.0, @hs[z][x + 1] - @hs[z][x], 0.0)
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
		@computedNormals = true
	end
	
	# returns the normal at (x, z)
	def getNormal(x, z)
		if (!@computedNormals)
			computeNormals
		end
		return @normals[z][x]
	end
end

def loadTerrain(filename, height)
	image = SDL::Surface.loadBMP(filename)
	t = Terrain.new(image.w, image.h)
	image.h.times do |y|
		image.w.times do |x|
			color = image.pixels[3 * (y * image.w + x)]
			h = height * ((color / 255.0) - 0.5)
			t.setHeight(x, y, h)
		end
	end
	
	image = nil
	t.computeNormals
	return t
end

@angle = 60.0

def cleanup
	@terrain = nil
end

def handleKeypress(key, x, y)
	case key
		when 27:
			cleanup
			exit
	end
end

def initRendering
	glEnable(GL_DEPTH_TEST)
	glEnable(GL_COLOR_MATERIAL)
	glEnable(GL_LIGHTING)
	glEnable(GL_LIGHT0)
	glEnable(GL_NORMALIZE)
	glShadeModel(GL_SMOOTH)
end

def handleResize(w, h)
	glViewport(0, 0, w, h)
	glMatrixMode(GL_PROJECTION)
	glLoadIdentity
	gluPerspective(45.0, w / h, 1.0, 200.0)
end

def max(a, b)
	return (b>a) ? a:b
end

def drawScene
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
	
	glMatrixMode(GL_MODELVIEW)
	glLoadIdentity
	glTranslatef(0.0, 0.0, -10.0)
	glRotatef(30.0, 1.0, 0.0, 0.0)
	glRotatef(-@angle, 0.0, 1.0, 0.0)
	ambientColor = [0.4, 0.4, 0.4, 1.0]
	glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambientColor)
	
	lightColor0 = [0.6, 0.6, 0.6, 1.0]
	lightPos0 = [-0.5, 0.8, 0.1, 0.0]
	glLightfv(GL_LIGHT0, GL_DIFFUSE, lightColor0)
	glLightfv(GL_LIGHT0, GL_POSITION, lightPos0)
	
	scale = 5.0 / max(@terrain.width - 1, @terrain.length- 1)
	glScalef(scale, scale, scale)
	glTranslatef(-(@terrain.width - 1) / 2, 0.0, -(@terrain.length - 1) / 2)
	glColor3f(0.3, 0.9, 0.0)
	(@terrain.length - 1).times do |z|
		# Makes OpenGL draw a triangle at every three consecutive vertices
		glBegin(GL_TRIANGLE_STRIP)
		@terrain.width.times do |x|
			normal = @terrain.getNormal(x,z)
			glNormal3f(normal[0], normal[1], normal[2])
			glVertex3f(x, @terrain.getHeight(x, z), z)
			normal = @terrain.getNormal(x, z + 1)
			glNormal3f(normal[0], normal[1], normal[2])
			glVertex3f(x, @terrain.getHeight(x, z + 1), z + 1)
		end
		glEnd
	end
	
	glutSwapBuffers
	
	@frames = 0 if not defined? @frames
    @t0 = 0 if not defined? @t0

    @frames += 1
    t = GLUT.Get(GLUT::ELAPSED_TIME)
    #if t - @t0 >= 5000
    #  seconds = (t - @t0) / 1000.0
    #  fps = @frames / seconds
    #  printf("%d frames in %6.3f seconds = %6.3f FPS\n",
    #    @frames, seconds, fps)
    #  @t0, @frames = t, 0
    #  exit if defined? @autoexit and t >= 999.0 * @autoexit
    #end
	if t - @t0 >= 100_000
		seconds = (t - @t0) / 1000.0
		fps = @frames /seconds
		printf("%d frames n %6.3f seconds = %6.3f FPS\n",
			@frames, seconds, fps)
		exit
	end
end

def update(value)
	@angle += 1.0
	if @angle > 360
		@angle -= 360
	end
	
	glutPostRedisplay
	glutTimerFunc(0, method(:update).to_proc, 0)
end

if __FILE__ == $0
	glutInit
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH)
	glutInitWindowSize(400, 400)

	glutCreateWindow("Terrain")
	initRendering

	@terrain = loadTerrain("heightmap.bmp", 20)

	glutDisplayFunc(method(:drawScene).to_proc)
	glutKeyboardFunc(method(:handleKeypress).to_proc)
	glutReshapeFunc(method(:handleResize).to_proc)
	glutTimerFunc(25, method(:update).to_proc, 0)

	glutMainLoop()
end