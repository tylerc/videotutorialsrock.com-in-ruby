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
	
	glMatrixMode(GL_MODELVIEW) # Switch to the drawing perspective
	glLoadIdentity() # reset the drawing perspective
	
	glBegin(GL_QUADS) # Begin quadrilateral coordinates
	
	# Trapezoid
	glVertex3f(-0.7, -1.5, -5.0)
	glVertex3f(0.7, -1.5, -5.0)
	glVertex3f(0.4, -0.5, -5.0)
	glVertex3f(-0.4, -0.5, -5.0)
	
	glEnd() # End quadrilateral coordinates
	
	glBegin(GL_TRIANGLES) # Begin triangle coordinates
	
	# Pentagon
	glVertex3f(0.5, 0.5, -5.0)
	glVertex3f(1.5, 0.5, -5.0)
	glVertex3f(0.5, 1.0, -5.0)
	
	glVertex3f(0.5, 1.0, -5.0)
	glVertex3f(1.5, 0.5, -5.0)
	glVertex3f(1.5, 1.0, -5.0)
	
	glVertex3f(0.5, 1.0, -5.0)
	glVertex3f(1.5, 1.0, -5.0)
	glVertex3f(1.0, 1.5, -5.0)
	
	# triangle
	glVertex3f(-0.5, 0.5, -5.0)
	glVertex3f(-1.0, 1.5, -5.0)
	glVertex3f(-1.5, 0.5, -5.0)
	
	glEnd() # End triangle coordinates
	
	glutSwapBuffers() # Send the 3D scene to the screen
end

# Initialize GLUT
glutInit
glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH)
glutInitWindowSize(400, 400) # Set the window size

# create the window
glutCreateWindow("Basic Shapes")
initRendering() # Initialize rendering

# set handler functions for drawing, keypresses, and window resizes
glutDisplayFunc(method(:drawScene).to_proc)
glutKeyboardFunc(method(:handleKeypress).to_proc)
glutReshapeFunc(method(:handleResize).to_proc)

glutMainLoop() # Start the main loop