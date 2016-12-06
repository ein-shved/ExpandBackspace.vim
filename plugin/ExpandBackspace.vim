" ExpandBackspace.vim  -  Make backspace eat white space to last tabstop.
"
" Copyright October 2005 by Christian J. Robinson <infynity@onewest.net>
" Copyright 2013-2016 by Yury Shvedov <shved@lvk.cs.msu.su>
"
" Distributed under the terms of the Vim license.  See ":help license".
"
" You can do ":let g:greedybackspacenl = 1" to make this script eat newlines
" as well (be sure you do include "eol" in your 'backspace' option).
" -----------------------------------------------------------------------------

function! s:ExpandDelete()
    let dl = ''
    let edge = s:ByteEdge()
    let offset = s:ByteOffset()
    let c = s:GetChar(offset)
    let count_chars = 0
    let ts = &tabstop
    if ( ts <= 0)
        let ts = 4
    endif
    if ! (c =~ '\s' || exists('g:greedybackspacenl') && g:greedybackspacenl != 0 && c == "\0")
		return "\<Del>"
	endif
	while c =~ '\s' || exists('g:greedybackspacenl') && g:greedybackspacenl != 0 && c == "\0"
        if c == "\0" && &fileformat == 'dos'
            let offset = offset - 1
        endif
        let dl = dl . "\<Del>"
        let offset = offset + 1
        let count_chars = count_chars + 1
        if (offset >= edge)
            break
        endif
        if (count_chars >= ts)
            break
        endif
        let c = s:GetChar(offset)
    endwhile

    return dl
endfunction

function! s:ExpandBackspace()
	let bs = 0
	let offset = s:ByteOffset() - 1
	let c = s:GetChar(offset)
    let ts = &tabstop
    if ( ts <= 0)
        let ts = 4
    endif
    let linelen = (col(".")-1) % ts
    if &ft =="python"
        return "\<BS>"
    endif
	if ! (c =~ '\s' || exists('g:greedybackspacenl') && g:greedybackspacenl != 0 && c == "\0")
		return "\<BS>"
	endif

	while c =~ '\s' || exists('g:greedybackspacenl') && g:greedybackspacenl != 0 && c == "\0"
		if c == "\0" && &fileformat == 'dos'
			let offset = offset - 1
		endif

        let bs = bs + 1

		let offset = offset - 1
		if (offset <= 0)
			break
		endif
		let c = s:GetChar(offset)
	endwhile

    let result = ''
    if ( bs > ts)
        if linelen == 0
            let bs = ts
        else
            let bs = linelen
        endif
    endif

    while bs > 0
        let result = result . "\<BS>"
        let bs = bs - 1
    endwhile


"    let bs = bs . "\<BS>"
	return result
endfunction

function! s:ByteEdge()
    let res = line2byte(line("$")) + col("$")
    return res
endfunction

function! s:ByteOffset()
        return line2byte(line(".")) + col(".") - 1
endfunction

function! s:GetChar(offset)
	let line = byte2line(a:offset)
	let char = a:offset - line2byte(line)
	let c = getline(line)[char]
	return c
endfunction

" Some options can cause problems, so reset them and use the 'paste' option
" temporarily:
function! s:TO(t)
  if a:t == 0
    let s:savesta=&sta | let &l:sta=0
	let s:savepaste=&paste | let &paste=0
	"let s:savebs=&bs | let &bs='indent,eol,start'
  else
    let &l:sta=s:savesta | unlet s:savesta
	let &paste=s:savepaste | unlet s:savepaste
	"let &bs=s:savebs | unlet s:savebs
  endif
  return ''
endfunction

function! s:PrepareMap()
    inoremap <silent> <BS> <C-R>=<SID>TO(0)<CR><C-R>=<SID>ExpandBackspace()<CR><C-R>=<SID>TO(1)<CR>
    inoremap <silent> <Del> <C-R>=<SID>TO(0)<CR><C-R>=<SID>ExpandDelete()<CR><C-R>=<SID>TO(1)<CR>
endfunction
function! s:ResetMap()
    silent! iunmap <BS>
    silent! iunmap <Del>
endfunction
function! s:CheckExpandTab()
    let l:x=&expandtab
    if ( l:x )
        exec s:PrepareMap()
    else
        exec s:ResetMap()
    endif
endfunction

augroup expand_bs_autocmds
    autocmd BufEnter * exec s:CheckExpandTab()
augroup END
