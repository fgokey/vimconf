"设置编码
set encoding=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set fileencodings=utf-8,ucs-bom,chinese

"语言设置
set langmenu=zh_CN.UTF-8

"设置行号
set nu

"设置语法高亮
syntax enable
syntax on

"设置配色方案
set background=dark
colorscheme solarizeddark 

"搜索相关
set showmatch " 高亮显示匹配的括号
set matchtime=5 " 匹配括号高亮的时间（单位是十分之一秒）
set hlsearch " 高亮搜索

"可以在buffer的任何地方使用鼠标
set mouse=a
set selection=exclusive
set selectmode=mouse,key

"高亮显示匹配的括号
set showmatch

"去掉vi一致性
set nocompatible
set shortmess=a
set cmdheight=2

"设置退格健可用
set backspace=2

"设置缩进
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent

"C++缩进风格
set cindent
set cinoptions={0,1s,t0,n-2,p2s,(03s,=.5s,>1s,=1s,:1s

"折叠相关
set foldmethod=syntax	"用语法高亮来定义折叠
set foldlevel=100		"启动vim时不要自动折叠代码
set foldcolumn=5		"设置折叠栏宽度


if &term=="xterm"
	set t_Co=8
	set t_Sb=^[[4%dm
	set t_Sf=^[[3%dm
endif

"打开文件类型自动检测功能
filetype on
filetype plugin on

"设置taglist
let Tlist_Auto_Open=0 	   "默认打开Taglist 
let Tlist_Show_One_File=1   "显示多个文件的tags
let Tlist_File_Fold_Auto_Close=1 "非当前文件，函数列表折叠隐藏
let Tlist_Exit_OnlyWindow=1 "在taglist是最后一个窗口时退出vim
let Tlist_Use_SingleClick=1 "单击时跳转
let Tlist_GainFocus_On_ToggleOpen=1 "打开taglist时获得输入焦点
let Tlist_Process_File_Always=1 "不管taglist窗口是否打开，始终解析文件中的tag

"设置WinManager插件
"let g:winManagerWindowLayout='FileExplorer|TagList'
"nmap wm :WMToggle<cr>
"map <silent> <F9> :WMToggle<cr> "将F9绑定至WinManager,即打开WimManager

"设置CSCOPE
set cscopequickfix=s-,c-,d-,i-,t-,e- "设定是否使用quickfix窗口显示cscope结果

"设置Grep插件
nnoremap <silent> <F3> :Grep<CR>

"设置自动补全
filetype plugin indent on   "打开文件类型检测
set completeopt=longest,menu "关掉智能补全时的预览窗口

"启动vim时如果存在tags则自动加载
if exists("tags")
	set tags=./tags
endif

"生成Cscope数据库文件
nmap <F4>:!cscope -Rbq<CR>:cs add ./cscope.out .<CR><CR><CR> :cs reset<CR>
"查找符号
nmap <leader>css :cs find s <C-R>=expand("<cword>")<CR><CR> :copen<CR><CR>
"查找定义
nmap <leader>csg :cs find g <C-R>=expand("<cword>")<CR><CR>
"查找被这个函数调用的函数
nmap <leader>csd :cs find d <C-R>=expand("<cword>")<CR><CR> :copen<CR><CR>
"查找调用这个函数的函数
nmap <leader>csc :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR><CR>
"查找这个字符串
nmap <leader>cst :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR><CR>
"查找这个egrep匹配模式
nmap <leader>cse :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR><CR>
"查找这个文件
nmap <leader>csf :cs find f <C-R>=expand("<cfile>")<CR><CR>
"查找include这个文件的文件
nmap <leader>csi :cs find i <C-R>=expand("<cfile>")<CR><CR> :copen<CR><CR>
 
"设置按F12就更新tags的方法
nmap <C-F12> :silent call Do_CsTag()<CR>
function Do_CsTag()
	    let dir = getcwd()
	    if filereadable("tags")
		    if(g:iswindows==1)
	            let tagsdeleted=delete(dir."\\"."tags")
			else
				let tagsdeleted=delete("./"."tags")
			endif
		    if(tagsdeleted!=0)
	            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
				return
			endif
		endif
		
		if(executable('ctags'))
			silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."|redraw!
		endif

		if has("cscope")
			" use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    		set cscopetag
			" check cscope for definition of a symbol before checking ctags: set to 1
			" if you want the reverse search order.
			set csto=0
			" show msg when any other cscope db added
			set cscopeverbose  
			" add any cscope database in current directory
			if filereadable("cscope.out")
				cs add cscope.out  
			" else add the database pointed to by environment variable 
			elseif $CSCOPE_DB != ""
				cs add $CSCOPE_DB
			endif
		endif
endfunction

"C，C++ 按F5编译运行
func! CompileGcc()
	exec "w"
	let compilecmd="!gcc "
	let compileflag="-o %< "
	if search("mpi\.h") != 0
		let compilecmd = "!mpicc "
	endif
	if search("glut\.h") != 0
		let compileflag .= " -lglut -lGLU -lGL "
	endif
	if search("cv\.h") != 0
		let compileflag .= " -lcv -lhighgui -lcvaux "
	endif
	if search("omp\.h") != 0
		let compileflag .= " -fopenmp "
	endif
	if search("math\.h") != 0
		let compileflag .= " -lm "
	endif
	exec compilecmd." % ".compileflag
endfunc

func! CompileGpp()
	exec "w"
	let compilecmd="!g++ "
	let compileflag="-o %< "
	if search("mpi\.h") != 0
		let compilecmd = "!mpic++ "
    endif
    if search("glut\.h") != 0
	    let compileflag .= " -lglut -lGLU -lGL "
	endif
    if search("cv\.h") != 0
	    let compileflag .= " -lcv -lhighgui -lcvaux "
    endif
    if search("omp\.h") != 0
	    let compileflag .= " -fopenmp "
	endif
    if search("math\.h") != 0
	    let compileflag .= " -lm "
    endif
    exec compilecmd." % ".compileflag
endfunc

func! CompileCode()
	exec "w"
	if &filetype == "cpp"
		exec "call CompileGpp()"
    elseif &filetype == "c"
	    exec "call CompileGcc()"
	endif
endfunc

map <F5> :call CompileCode()<CR>
imap <F5> <ESC>:call CompileCode()<CR>
vmap <F5> <ESC>:call CompileCode()<CR>

"C,C++的调试
map <F8> :call Rungdb()<CR>
 func! Rungdb()
     exec "w"
     exec "!g++ % -g -o %<"
     exec "!gdb ./%<"
 endfunc


"设置VIM记录的历史数
set history=400

"设置当文件被外部改变的时侯自动读入文件
if exists("&autoread")
	set autoread
endif

"设置ambiwidth
set ambiwidth=double

"设置文件类型
set ffs=unix,dos,mac

"设置增量搜索模式
set incsearch

"设置静音模式
set noerrorbells
set novisualbell
set t_vb=

"不要备份文件
set nobackup
set nowritebackup

"OmniCppComplete
set nocp

"SuperTab
let g:SuperTabDefaultCompletionType="context"

"MiniBufExplorer
let g:miniBufExplMapWindowNavVim = 1   
let g:miniBufExplMapWindowNavArrows = 1   
let g:miniBufExplMapCTabSwitchBufs = 1   
let g:miniBufExplModSelTarget = 1  
let g:miniBufExplMoreThanOne=0 
let g:miniBufExplorerMoreThanOne=0
let g:bufExplorerMaxHeight=30

"WinManager
let g:NERDTree_title="[NERDTree]"  
let g:winManagerWindowLayout="NERDTree|TagList"
function! NERDTree_Start()  
	exec 'NERDTree'  
endfunction  
function! NERDTree_IsValid()  
    return 1  
endfunction  
nmap wm :WMToggle<CR>  

"STL自动补全
set tags+=~/.vim/systags
let g:SuperTabRetainCompletionType=2
let g:SuperTabDefaultCompletionType="<C-X><C-O>"
"生成系统路径下的tags
"ctags -I __THROW --file-scope=yes --langmap=c:+.h --languages=c,c++ --links=yes --c-kinds=+p --fields=+iaS --extra=+q -R -f ~/.vim/systags /usr/include /usr/local/include
