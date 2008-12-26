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
	glClearColor(0.7, 0.9, 1.0, 1.0)
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
@cameraAngle = 0.0

# Draws the 3D scene
def drawScene
	# clear information from last draw
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
	
	glMatrixMode(GL_MODELVIEW) # Switch to the drawing perspective
	glLoadIdentity() # reset the drawing perspective
	glRotatef(-@cameraAngle, 0.0, 1.0, 0.0)
	glTranslatef(0.0, 0.0, -5.0)
	
	glPushMatrix()
	glTranslatef(0.0, -1.0, 0.0)
	glRotatef(@angle, 0.0, 0.0, 1.0)
	
	glBegin(GL_QUADS) # Begin quadrilateral coordinates
	
	# Trapezoid
	glColor3f(0.5, 0.0, 0.8)
	glVertex3f(-0.7, -0.5, 0.0)
	glColor3f(0.0, 0.9, 0.0)
	glVertex3f(0.7, -0.5, 0.0)
	glColor3f(1.0, 0.0, 0.0)
	glVertex3f(0.4, 0.5, 0.0)
	glColor3f(0.0, 0.65, 0.65)
	glVertex3f(-0.4, 0.5, 0.0)
	
	glEnd() # End quadrilateral coordinates
	glPopMatrix()
	
	glPushMatrix()
	glTranslatef(1.0, 1.0, 0.0)
	glRotatef(@angle, 0.0, 1.0, 0.0)
	glScalef(0.7, 0.7, 0.7)
	
	glBegin(GL_TRIANGLES) # Begin triangle coordinates
	glColor3f(0.0, 0.75, 0.0)
	
	# Pentagon
	glVertex3f(-0.5, -0.5, 0.0)
	glVertex3f(0.5, -0.5, 0.0)
	glVertex3f(-0.5, 0.0, 0.0)
	
	glVertex3f(-0.5, 0.0, 0.0)
	glVertex3f(0.5, -0.5, 0.0)
	glVertex3f(0.5, 0.0, 0.0)
	
	glVertex3f(-0.5, 0.0, 0.0)
	glVertex3f(0.5, 0.0, 0.0)
	glVertex3f(0.0, 0.5, 0.0)
	
	glEnd()
	glPopMatrix()
	
	glTranslatef(-1.0, 1.0, 0.0)
	glRotate(@angle, 1.0, 2.0, 3.0)
	glBegin(GL_TRIANGLES)
	
	# triangle
	glColor3f(1.0, 0.7, 0.0)
	glVertex3f(0.5, -0.5, 0.0)
	glColor3f(1.0, 1.0, 1.0)
	glVertex3f(0.0, 0.5, 0.0)
	glColor3f(0.0, 1.0, 1.0)
	glVertex3f(-0.5, -0.5, 0.0)
	
	glEnd() # End triangle coordinates
	
	glutSwapBuffers() # Send the 3D scene to the screen
end

def update(value)
	@angle += 2.0
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
glutCreateWindow("Color")
initRendering() # Initialize rendering

# set handler functions for drawing, keypresses, and window resizes
glutDisplayFunc(method(:drawScene).to_proc)
glutKeyboardFunc(method(:handleKeypress).to_proc)
glutReshapeFunc(method(:handleResize).to_proc)

glutTimerFunc(25, method(:update).to_proc, 0)
glutMainLoop() # Start the main loop