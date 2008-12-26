require 'sdl'
require 'opengl'

def handleKeypress(key, x, y)
	case key
		when 27:
			exit
	end
end

def loadTexture(image)
	texture = glGenTextures(1)
	textureId = texture[0]
	glBindTexture(GL_TEXTURE_2D, textureId)
	glTexImage2D(GL_TEXTURE_2D,
							0,
							GL_RGB,
							image.w,
							image.h,
							0,
							GL_BGR,
							GL_UNSIGNED_BYTE,
							image.pixels)
	return textureId
end

def initRendering
	glEnable(GL_DEPTH_TEST)
	glEnable(GL_LIGHTING)
	glEnable(GL_LIGHT0)
	glEnable(GL_NORMALIZE)
	glEnable(GL_COLOR_MATERIAL)
	
	image = SDL::Surface.loadBMP("vtr.bmp")
	@textureId = loadTexture(image)
	image = nil
end

def handleResize(w, h)
	glViewport(0, 0, w, h)
	glMatrixMode(GL_PROJECTION)
	glLoadIdentity
	gluPerspective(45.0, w / h, 1.0, 200.0)
end

def drawScene
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
	
	glMatrixMode(GL_MODELVIEW)
	glLoadIdentity
	
	glTranslatef(0.0, 1.0, -6.0)
	
	ambientLight = [0.2, 0.2, 0.2, 1.0]
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
	#glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
	#glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
	glColor3f(1.0, 0.2, 0.2)
	glBegin(GL_QUADS)
	
	glNormal3f(0.0, 1.0, 0.0)
	glTexCoord2f(0.0, 1.0)
	glVertex3f(-2.5, -2.5, 2.5)
	glTexCoord2f(1.0, 1.0)
	glVertex3f(2.5, -2.5, 2.5)
	glTexCoord2f(1.0, 0.0)
	glVertex3f(2.5, -2.5, -2.5)
	glTexCoord2f(0.0, 0.0)
	glVertex3f(-2.5, -2.5, -2.5)
	
	glEnd
	
	# Back
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
	glColor3f(1.0, 1.0, 1.0)
	glBegin(GL_TRIANGLES)
	
	glNormal3f(0.0, 0.0, 1.0)
	glTexCoord2f(0.0, 5.0)
	glVertex3f(-2.5, -2.5, -2.5)
	glTexCoord2f(0.0, 0.0)
	glVertex3f(0.0, 2.5, -2.5)
	glTexCoord2f(5.0, 5.0)
	glVertex3f(2.5, -2.5, -2.5)
	
	glEnd
	
	# Left
	glDisable(GL_TEXTURE_2D)
	glColor3f(1.0, 0.7, 0.3)
	glBegin(GL_QUADS)
	
	glNormal(1.0, 0.0, 0.0)
	glVertex3f(-2.5, -2.5, 2.5)
	glVertex3f(-2.5, -2.5, -2.5)
	glVertex3f(-2.5, 2.5, -2.5)
	glVertex3f(-2.5, 2.5, 2.5)
	
	glEnd
	
	glutSwapBuffers
end

glutInit
glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH)
glutInitWindowSize(400, 400)

glutCreateWindow("Textures")
initRendering

glutDisplayFunc(method(:drawScene).to_proc)
glutKeyboardFunc(method(:handleKeypress).to_proc)
glutReshapeFunc(method(:handleResize).to_proc)

glutMainLoop() # Start the main loop