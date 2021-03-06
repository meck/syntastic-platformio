let s:pio_ini = findfile("platformio.ini", ".;")
" Finish if we're not in a platformio cwd (or subdir)
if empty(s:pio_ini)
  finish
endif


let s:pio_cwd        = fnamemodify(s:pio_ini, ':h')
let s:pio_flags_file = s:pio_cwd  . '/.gcc-flags.json'
" Finish if we can't find the gcc flags file.
if empty(glob(s:pio_flags_file))
  echoerr 'Can not find ' . s:pio_flags_file . ' in ' . s:pio_cwd
  finish
endif
" Finish if we can't parse.
let s:pio_gcc_flags  = json_decode(system('cat ' . s:pio_flags_file))
if empty(s:pio_gcc_flags)
  echoerr 'Failed to parse ' . s:pio_flags_file
  finish
endif

let g:ale_c_gcc_options = join(map(split(s:pio_gcc_flags["gccIncludePaths"], ","), '"-I" . v:val')) . ' ' . s:pio_gcc_flags["gccDefaultCFlags"]

let g:ale_cpp_gcc_options = join(map(split(s:pio_gcc_flags["gccIncludePaths"], ","), '"-I" . v:val')) . ' ' . s:pio_gcc_flags["gccDefaultCppFlags"]
let g:ale_cpp_gcc_executable = s:pio_gcc_flags["execPath"]

let g:ale_linters = { 'cpp': ['clangcheck', 'clangtidy', 'cppcheck', 'cpplint', 'g++'],}
