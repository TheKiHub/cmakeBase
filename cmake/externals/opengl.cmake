set(OpenGL_GL_PREFERENCE GLVND)
find_package(OpenGL REQUIRED)
set(OPENGL_LIBRARIES ${OPENGL_LIBRARIES} PARENT_SCOPE)
add_library(opengl ALIAS OpenGL::GL)
