" Tests for tagjump (tags and special searches)

" SEGV occurs in older versions.  (At least 7.4.1748 or older)
func Test_ptag_with_notagstack()
  set notagstack
  call assert_fails('ptag does_not_exist_tag_name', 'E426')
  set tagstack&vim
endfunc

func Test_cancel_ptjump()
  set tags=Xtags
  call writefile(["!_TAG_FILE_ENCODING\tutf-8\t//",
        \ "word\tfile1\tcmd1",
        \ "word\tfile2\tcmd2"],
        \ 'Xtags')

  only!
  call feedkeys(":ptjump word\<CR>\<CR>", "xt")
  help
  call assert_equal(2, winnr('$'))

  call delete('Xtags')
  quit
endfunc

" Tests for [ CTRL-I and CTRL-W CTRL-I commands
function Test_keyword_jump()
  call writefile(["#include Xinclude", "",
	      \ "",
	      \ "/* test text test tex start here",
	      \ "		some text",
	      \ "		test text",
	      \ "		start OK if found this line",
	      \ "	start found wrong line",
	      \ "test text"], 'Xtestfile')
  call writefile(["/* test text test tex start here",
	      \ "		some text",
	      \ "		test text",
	      \ "		start OK if found this line",
	      \ "	start found wrong line",
	      \ "test text"], 'Xinclude')
  new Xtestfile
  call cursor(1,1)
  call search("start")
  exe "normal! 5[\<C-I>"
  call assert_equal("		start OK if found this line", getline('.'))
  call cursor(1,1)
  call search("start")
  exe "normal! 5\<C-W>\<C-I>"
  call assert_equal("		start OK if found this line", getline('.'))
  enew! | only
  call delete('Xtestfile')
  call delete('Xinclude')
endfunction

" vim: shiftwidth=2 sts=2 expandtab
