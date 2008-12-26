require 'opengl'

def handleKeypress(key, x, y)
	case key
		when 27
			exit(0)
	end
end

# initializes 3D rendering
def initRendering
	# Makes 3D drawing work when something is in front of something else
	glEnable(GL_DEPTH_TEST)
	glEnable(GL_COLOR_MATERIAL)
	glEnable(GL_LIGHTING) # enable lighting
	glEnable(GL_LIGHT0) # enable light #0
	glEnable(GL_LIGHT1) # enable light #1
	glEnable(GL_NORMALIZE) # Automatically normailize normals
	#glShadeModel(GL_SMOOTH) # Enable smooth shading
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

@angle = 30.0

# Draws the 3D scene
def drawScene
	# clear information from last draw
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
	
	glMatrixMode(GL_MODELVIEW)
	glLoadIdentity()
	
	glTranslatef(0.0, 0.0, -8.0)
	
	# Add ambient light
	ambientColor = [0.2, 0.2, 0.2, 1.0] #Color (0.2, 0.2, 0.2)
	glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambientColor)
	
	# Add positioned light
	lightColor0 = [0.5, 0.5, 0.5, 1.0] #Color (0.5, 0.5, 0.5)
	lightPos0 = [4.0, 0.0, 8.0, 1.0] # positioned at (4, 0, 8)
	glLightfv(GL_LIGHT0, GL_DIFFUSE, lightColor0)
	glLightfv(GL_LIGHT0, GL_POSITION, lightPos0)
	
	# Add directed light
	lightColor1 = [0.5, 0.2, 0.2, 1.0] # Color (0.5, 0.2, 0.2)
	# Coming from the direction (-1, 0.5, 0.5)
	lightPos1 = [-1.0, 0.5, 0.5, 0.0]
	glLightfv(GL_LIGHT1, GL_DIFFUSE, lightColor1)
	glLightfv(GL_LIGHT1, GL_POSITION, lightPos1)
	
	glRotatef(@angle, 0.0, 1.0, 0.0)
	glColor3f(1.0, 1.0, 0.0)
	glBegin(GL_QUADS)
	
	#Front
	#glNormal3f(0.0, 0.0, 1.0)
	glNormal3f(-1.0, 0.0, 1.0)
	glVertex3f(-1.5, -1.0, 1.5)
	glNormal3f(1.0, 0.0, 1.0)
	glVertex3f(1.5, -1.0, 1.5)
	glNormal3f(1.0, 0.0, 1.0)
	glVertex3f(1.5, 1.0, 1.5)
	glNormal3f(-1.0, 0.0, 1.0)
	glVertex3f(-1.5, 1.0, 1.5)
	
	#Right
	#glNormal3f(1.0, 0.0, 0.0)
	glNormal3f(1.0, 0.0, -1.0)
	glVertex3f(1.5, -1.0, -1.5)
	glNormal3f(1.0, 0.0, -1.0)
	glVertex3f(1.5, 1.0, -1.5)
	glNormal3f(1.0, 0.0, 1.0)
	glVertex3f(1.5, 1.0, 1.5)
	glNormal3f(1.0, 0.0, 1.0)
	glVertex3f(1.5, -1.0, 1.5)
	
	#Back
	#glNormal3f(0.0, 0.0, -1.0)
	glNormal3f(-1.0, 0.0, -1.0)
	glVertex3f(-1.5, -1.0, -1.5)
	glNormal3f(-1.0, 0.0, -1.0)
	glVertex3f(-1.5, 1.0, -1.5)
	glNormal3f(1.0, 0.0, -1.0)
	glVertex3f(1.5, 1.0, -1.5)
	glNormal3f(1.0, 0.0, -1.0)
	glVertex3f(1.5, -1.0, -1.5)
	
	#Left
	#glNormal3f(-1.0, 0.0, 0.0)
	glNormal3f(-1.0, 0.0, -1.0)
	glVertex3f(-1.5, -1.0, -1.5)
	glNormal3f(-1.0, 0.0, 1.0)
	glVertex3f(-1.5, -1.0, 1.5)
	glNormal3f(-1.0, 0.0, 1.0)
	glVertex3f(-1.5, 1.0, 1.5)
	glNormal3f(-1.0, 0.0, -1.0)
	glVertex3f(-1.5, 1.0, -1.5)
	
	glEnd()
	
	glutSwapBuffers() # Send the 3D scene to the screen
end

def update(value)
	@angle += 1.5
	if (@angle > 360)
		@angle -= 360
	end
	
	glutPostRedisplay()
	glutTimerFunc(25, method(:update).to_proc, 0)
end

# Initialize GLUT
glutInit
glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH)
glutInitWindowSize(400, 400) # Set the window size

# create the window
glutCreateWindow("Lighting")
initRendering() # Initialize rendering

# set handler functions for drawing, keypresses, and window resizes
glutDisplayFunc(method(:drawScene).to_proc)
glutKeyboardFunc(method(:handleKeypress).to_proc)
glutReshapeFunc(method(:handleResize).to_proc)

glutTimerFunc(25, method(:update).to_proc, 0)
glutMainLoop() # Start the main loop