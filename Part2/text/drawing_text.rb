require 'rubygems'
require 'opengl'
require 'sdl'
begin
	require 'text3d'
rescue LoadError
	puts 'The load of text3d failed (See README for help)'
	exit
end
include Text3d

def computeScale(strs)
	maxWidth = 0
	4.times do |x|
		width = t3dDrawWidth(strs[x])
		if width > maxWidth
			maxWidth = width
		end
	end
	
	return 2.6 / maxWidth
end

@angle = -30.0
@scale = 1
STRS = ["Video", "Tutorials", "Rock", ".com"]

def cleanup
	t3dCleanup
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
	t3dInit
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
	glTranslatef(0.0, 0.0, -8.0)
	
	ambientColor = [0.4, 0.4, 0.4, 1.0]
	glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambientColor)
	
	lightColor0 = [0.6, 0.6, 0.6, -1.0]
	lightPos0 = [-0.5,  0.5, 1.0, 0.0]
	glLightfv(GL_LIGHT0, GL_DIFFUSE, lightColor0)
	glLightfv(GL_LIGHT0, GL_POSITION, lightPos0)
	
	glRotatef(20.0, 1.0, 0.0, 0.0)
	glRotatef(-@angle, 0.0, 1.0, 0.0)
	
	# draw the strings along the sides of a square
	glScalef(@scale, @scale, @scale)
	glColor3f(0.3, 1.0, 0.3)
	4.times do |x|
		glPushMatrix
		glRotatef(90 * x, 0, 1, 0)
		glTranslatef(0, 0, 1.5 / @scale)
		t3dDraw3D STRS[x], 0, 0, 0.2
		glPopMatrix
	end
	
	glutSwapBuffers
end

def update value
	@angle += 1.5
	if @angle > 360
		@angle -= 360
	end
	
	glutPostRedisplay
	glutTimerFunc(25, method(:update).to_proc, 0)
end

if __FILE__ == $0
	glutInit
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH)
	glutInitWindowSize(400, 400)

	glutCreateWindow("Drawing Text")
	initRendering

	@scale = computeScale STRS

	glutDisplayFunc(method(:drawScene).to_proc)
	glutKeyboardFunc(method(:handleKeypress).to_proc)
	glutReshapeFunc(method(:handleResize).to_proc)
	glutTimerFunc(0, method(:update).to_proc, 25)

	glutMainLoop()
end

