require 'rubygems'
require 'opengl'
require 'sdl'

def handleKeypress(key, x, y)
	case key
		when 27
			exit(0)
	end
end

def loadTexture(surface)
	texture = glGenTextures(1)
	textureId = texture[0] # Store the Texture ID
	glBindTexture(GL_TEXTURE_2D, textureId)
	glTexImage2D(GL_TEXTURE_2D,	# Always GL_TEXTURE_2D
							0, # 0 for now
							3,	# Format opengl uses for this image
							surface.w, surface.h,	# width and height
							0,	# the border of this image
							GL_RGB,	# GL_RGB, because pixels are stored in RGB format
							GL_UNSIGNED_BYTE,	#GL_UNSIGNED_BYTE because pixels are stored as unsigned numbers
							surface.pixels)	# The actual pixel data
	return textureId
end

@textureId

def fix(image)
	
end

# initializes 3D rendering
def initRendering
	# Makes 3D drawing work when something is in front of something else
	glEnable(GL_DEPTH_TEST)
	glEnable(GL_LIGHTING) # enable lighting
	glEnable(GL_LIGHT0) # enable light #0
	glEnable(GL_NORMALIZE) # Automatically normailize normals
	glEnable(GL_COLOR_MATERIAL)
	
	surface = SDL::Surface.load("vtr.bmp")
	@textureId = loadTexture(surface)
	surface = nil
end

# Called when the window is resized
def handleResize w, h
	# Tell OpenGL how to convert from coordinates pixel values
	glViewport(0, 0, w, h)
	
	glMatrixMode(GL_PROJECTION) # Switch to setting the camera perspective
	
	# Set the camera perspective
	glLoadIdentity() # Reset the camera
	gluPerspective(45.0, # the camera angle
					w/ h,
					1.0,
					200.0)
end

# Draws the 3D scene
def drawScene
	# clear information from last draw
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
	
	glMatrixMode(GL_MODELVIEW)
	glLoadIdentity
	
	glTranslatef(0.0, 1.0, -6.0)
	
	ambientLight = [0.2, 0.2, 0.2, 1.00]
	glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambientLight)
	
	directedLight = [0.7, 0.7, 0.7, 1.0]
	directedLightPos = [-10.0, 15.0, 20.0, 0.0]
	glLightfv(GL_LIGHT0, GL_DIFFUSE, directedLight)
	glLightfv(GL_LIGHT0, GL_POSITION, directedLightPos)
	
	glEnable(GL_TEXTURE_2D)
	glBindTexture(GL_TEXTURE_2D, @textureId)
	
	# Bottom
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
	glColor3f(1.0, 0.2, 0.2)
	glBegin(GL_QUADS)
	
	glNormal3f(0.0, 1.0, 0.0)
	glTexCoord2f(0.0, 0.0)
	glVertex3f(-2.5, -2.5, 2.5)
	glTexCoord2f(1.0, 0.0)
	glVertex3f(2.5, -2.5, 2.5)
	glTexCoord2f(21.0, 1.0)
	glVertex3f(2.5, -2.5, -2.5)
	glTexCoord2f(0.0, 1.0)
	glVertex3f(-2.5, -2.5, -2.5)
	
	glEnd
	
	# Back
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
	glColor3f(1.0, 1.0, 1.0)
	glBegin(GL_TRIANGLES)
	
	glNormal3f(0.0, 0.0, 1.0)
	glTexCoord2f(0.0, 0.0)
	glVertex3f(-2.5, -2.5, -2.5)
	glTexCoord2f(5.0, 5.0)
	glVertex3f(0.0, 2.5, -2.5)
	glTexCoord2f(10.0, 0.0)
	glVertex3f(2.5, -2.5, -2.5)
	
	glEnd
	
	# Left
	glDisable(GL_TEXTURE_2D)
	glColor3f(1.0, 0.7, 0.3)
	glBegin(GL_QUADS)
	
	glNormal3f(1.0, 0.0, 0.0)
	glVertex3f(-2.5, -2.5, 2.5)
	glVertex3f(-2.5, -2.5, -2.5)
	glVertex3f(-2.5, 2.5, -2.5)
	glVertex3f(-2.5, 2.5, 2.5)
	
	glEnd
	
	glutSwapBuffers() # Send the 3D scene to the screen
end

# Initialize GLUT
glutInit
glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH)
glutInitWindowSize(400, 400) # Set the window size

# create the window
glutCreateWindow("Textures")
initRendering() # Initialize rendering

# set handler functions for drawing, keypresses, and window resizes
glutDisplayFunc(method(:drawScene).to_proc)
glutKeyboardFunc(method(:handleKeypress).to_proc)
glutReshapeFunc(method(:handleResize).to_proc)

glutMainLoop() # Start the main loop