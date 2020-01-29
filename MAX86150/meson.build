includes = include_directories(
  './',
)

lib = static_library(
  'max86150',
  'max86150.c',
  dependencies: periphdriver,
  c_args: '-w',
)

max86150 = declare_dependency(
  include_directories: includes,
  link_with: lib,
)
