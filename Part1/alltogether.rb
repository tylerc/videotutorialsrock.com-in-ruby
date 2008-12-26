require 'opengl'
require 'sdl'

BOX_SIZE = 7.0
@angle = 0
@textureId

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
							GL_RGB,	# Format opengl uses for this image
							surface.w, surface.h,	# width and height
							0,	# the border of this image
							GL_BGR,	# GL_RGB, because pixels are stored in RGB format
							GL_UNSIGNED_BYTE,	#GL_UNSIGNED_BYTE because pixels are stored as unsigned numbers
							surface.pixels)	# The actual pixel data
	return textureId
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
	
	glTranslatef(0.0, 0.0, -20.0)
	
	ambientLight = [0.3, 0.3, 0.3, 1.0]
	glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambientLight)
	
	lightColor = [0.7, 0.7, 0.7, 1.0]
	lightPos = [-2 * BOX_SIZE, BOX_SIZE, 4*BOX_SIZE, 1.0]
	glLightfv(GL_LIGHT0, GL_DIFFUSE, lightColor)
	glLightfv(GL_LIGHT0, GL_POSITION, lightPos)
	
	glRotatef(-@angle, 1.0, 1.0, 0.0)
	
	glBegin(GL_QUADS)
	
	# Top face
	glColor3f(1.0, 1.0, 0.0)
	glNormal3f(0.0, 1.0, 0.0)
	glVertex3f(-BOX_SIZE / 2, BOX_SIZE / 2, -BOX_SIZE / 2)
	glVertex3f(-BOX_SIZE / 2, BOX_SIZE / 2, BOX_SIZE / 2)
	glVertex3f(BOX_SIZE / 2, BOX_SIZE / 2, BOX_SIZE / 2)
	glVertex3f(BOX_SIZE / 2, BOX_SIZE / 2, -BOX_SIZE / 2)
	
	# Bottom face
	glColor3f(1.0, 0.0, 1.0)
	glNormal3f(0.0, -1.0, 0.0)
	glVertex3f(-BOX_SIZE / 2, -BOX_SIZE / 2, -BOX_SIZE / 2)
	glVertex3f(BOX_SIZE / 2, -BOX_SIZE / 2, -BOX_SIZE / 2)
	glVertex3f(BOX_SIZE / 2, -BOX_SIZE / 2, BOX_SIZE / 2)
	glVertex3f(-BOX_SIZE / 2, -BOX_SIZE / 2, BOX_SIZE / 2)
	
	# Left face
	glNormal3f(-1.0, 0.0, 0.0)
	glColor3f(0.0, 1.0, 1.0)
	glVertex3f(-BOX_SIZE / 2, -BOX_SIZE / 2, -BOX_SIZE / 2)
	glVertex3f(-BOX_SIZE / 2, -BOX_SIZE / 2, BOX_SIZE / 2)
	glColor3f(0.0, 0.0, 1.0)
	glVertex3f(-BOX_SIZE / 2, BOX_SIZE / 2, BOX_SIZE / 2)
	glVertex3f(-BOX_SIZE / 2, BOX_SIZE / 2, -BOX_SIZE / 2)
	
	# Right face
	glNormal3f(1.0, 0.0, 0.0)
	glColor3f(1.0, 0.0, 0.0)
	glVertex3f(BOX_SIZE / 2, -BOX_SIZE / 2, -BOX_SIZE / 2)
	glVertex3f(BOX_SIZE / 2, BOX_SIZE / 2, -BOX_SIZE / 2)
	glColor3f(0.0, 1.0, 0.0)
	glVertex3f(BOX_SIZE / 2, BOX_SIZE / 2, BOX_SIZE / 2)
	glVertex3f(BOX_SIZE / 2, -BOX_SIZE / 2, BOX_SIZE / 2)
	
	glEnd
	
	glEnable(GL_TEXTURE_2D)
	glBindTexture(GL_TEXTURE_2D, @textureId)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
	glColor3f(1.0, 1.0, 1.0)
	glBegin(GL_QUADS)
	
	# Front face
	glNormal3f(0.0, 0.0, 1.0)
	glTexCoord2f(0.0, 0.0)
	glVertex3f(-BOX_SIZE / 2, -BOX_SIZE / 2, BOX_SIZE / 2)
	glTexCoord2f(1.0, 0.0)
	glVertex3f(BOX_SIZE / 2, -BOX_SIZE / 2, BOX_SIZE / 2)
	glTexCoord2f(1.0, 1.0)
	glVertex3f(BOX_SIZE / 2, BOX_SIZE / 2, BOX_SIZE / 2)
	glTexCoord2f(0.0, 1.0)
	glVertex3f(-BOX_SIZE / 2, BOX_SIZE / 2, BOX_SIZE / 2)
	
	#Back face
	glNormal3f(0.0, 0.0, -1.0)
	glTexCoord2f(0.0, 0.0)
	glVertex3f(-BOX_SIZE / 2, -BOX_SIZE / 2, -BOX_SIZE / 2)
	glTexCoord2f(1.0, 0.0)
	glVertex3f(-BOX_SIZE / 2, BOX_SIZE / 2, -BOX_SIZE / 2)
	glTexCoord2f(1.0, 1.0)
	glVertex3f(BOX_SIZE / 2, BOX_SIZE / 2, -BOX_SIZE / 2)
	glTexCoord2f(0.0, 1.0)
	glVertex3f(BOX_SIZE / 2, -BOX_SIZE / 2, -BOX_SIZE / 2)
	
	glEnd
	glDisable(GL_TEXTURE_2D)

	glutSwapBuffers() # Send the 3D scene to the screen
end

def update(value)
	@angle += 1.0
	if (@angle > 360)
		@angle -= 360
	end
	glutPostRedisplay
	glutTimerFunc(25, method(:update).to_proc, 0)
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
glutTimerFunc(25, method(:update).to_proc, 0)

glutMainLoop() # Start the main loop