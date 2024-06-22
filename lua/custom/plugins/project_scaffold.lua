-- Small plugin that allows us to generate a template project structure

local createFileIfDoesntExist = function(filepath, snippet)
  local file = io.open(filepath, 'w')
  if file ~= nil then
    file:write(snippet)
    io.close(file)
  else
    print('File' .. filepath .. 'already existed')
  end
end

local function init_project()
  -- Create source and include dirs if they don't already exist
  os.execute('mkdir ' .. 'src')
  os.execute('mkdir ' .. 'include')
  os.execute('mkdir ' .. 'bin')
  os.execute('mkdir ' .. 'build')

  -- CMAKE
  createFileIfDoesntExist(
    'CMakeLists.txt',
    [[
CMAKE_MINIMUM_REQUIRED(VERSION 3.6)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin)
include_directories(include)
project(main)
set(EXE_NAME out)
add_executable(${EXE_NAME} src/main.cpp)
set(BUILD_TARGETS ${EXE_NAME})
if(MSVC)
  set_target_properties(${BUILD_TARGETS} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/../lib)
  set_target_properties(${BUILD_TARGETS} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/../bin)
  set_target_properties(${BUILD_TARGETS} PROPERTIES LIBRARY_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/../lib)
  set_target_properties(${BUILD_TARGETS} PROPERTIES PDB_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/../bin/pdb)
endif(MSVC)
    ]]
  )

  createFileIfDoesntExist(
    '.clang-format',
    [[
BasedOnStyle: Microsoft
IndentWidth: 4
ColumnLimit: 110
PointerAlignment: Left
SortIncludes: Never
ReferenceAlignment: Left
AlignConsecutiveAssignments: true
BreakBeforeBraces: Custom
BraceWrapping:
  AfterClass: true
  AfterStruct: true
  AfterCaseLabel: true
  AfterFunction: false
  BeforeElse: true
  BeforeWhile: true
  AfterControlStatement: false
  ]]
  )

  createFileIfDoesntExist(
    '.compile_flags.txt',
    [[
-std=c++20
-Isrc
-Iinclude
  ]]
  )

  print 'Done.'
end

return {
  createFileIfDoesntExist = createFileIfDoesntExist,
  init_project = init_project,
}
