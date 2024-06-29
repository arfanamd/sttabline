vim9script
# --------------------------------------------------------------
# Author:  arfanamd
# Plugin:  sttabline
# License: Distributed under the same license as Vim itself.
# See ":help license" in Vim. Stoicism
# --------------------------------------------------------------

if exists("g:sttabline_loaded")
	finish
endif

g:sttabline_loaded = true

# Tabline highlight properties for sttabline
hi clear TabLine
hi clear TabLineSel
hi clear TabLineFill
hi TabLine     ctermbg=none  ctermfg=015   cterm=none
hi TabLineSel  ctermbg=none  ctermfg=078   cterm=none
hi TabLineFill ctermbg=none  ctermfg=none  cterm=none

# This function returns the string of the index number and the
# buffer name. If there is a splitted window, then it will return
# the buffer name of the last active window.
def GetAttributeFromTab(index: number): string
	var content = ""
	var currbuf = {}
	
	currbuf['buflst'] = tabpagebuflist(index)
	currbuf['winidx'] = tabpagewinnr(index)
	currbuf['bufidx'] = currbuf['buflst'][currbuf['winidx'] - 1]
	currbuf['buffer'] = fnamemodify(bufname(currbuf['bufidx']), ':t')
	currbuf['buftyp'] = getbufvar(currbuf['bufidx'], '&buftype')
	
	# Vim has different types of built-in special buffers
	# Although, we only covers 4 of them; unnamed, quickfix,
	# terminal and help.
	if currbuf['buffer'] == ""
		currbuf['buffer'] = ". no_name"
	else
		if currbuf['buftyp'] == "quickfix"
			currbuf['buffer'] = ". quickfix"
		elseif currbuf['buftyp'] == "help"
			currbuf['buffer'] = ". help"
		elseif currbuf['buftyp'] == "terminal"
			currbuf['buffer'] = ". console"
		else
			currbuf['buffer'] = ". " .. currbuf['buffer']
		endif
	endif
	
	content ..= index
	content ..= currbuf['buffer']
	
	return content
enddef

def g:Sttabline(): string
	var content: string = ""
	var curridx: number = tabpagenr()
	
	content ..= "%#TabLineFill#%=%#TabLine#:"
	
	for tab in range(1, tabpagenr('$'))
		if tab == curridx
			content ..= "%#TabLineSel#[" .. tab .. "]%#TabLine#"
		else
			content ..= "[" .. GetAttributeFromTab(tab) .. "]"
		endif
	endfor
	
	content ..= ":"
	
	return content
enddef

# vim:ft=vim:sw=2:ts=2
