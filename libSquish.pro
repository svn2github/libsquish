TARGET = squish
TEMPLATE = lib

include(sources.pro)

QT -= gui

CONFIG += staticlib thread
CONFIG += debug_and_release

CONFIG(debug, debug|release) {
   unix:TARGET = $$join(TARGET,,,_debug)
   win32:TARGET = $$join(TARGET,,d)
}

MOC_DIR = mocs
OBJECTS_DIR = objs
UI_DIR = uics
