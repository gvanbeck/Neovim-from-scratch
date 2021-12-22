local cmd = vim.cmd
-- HANDY SETTINGS
--TODO: Refactor to lua
cmd [[
hi Normal guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE
autocmd InsertEnter,InsertLeave * set cul!

nnoremap <silent><leader>pcd :call PhpCsFixerFixDirectory()<CR>
nnoremap <silent><leader>pcf :call PhpCsFixerFixFile()<CR>
autocmd BufWritePost */src/Smartschool/*.php silent! call PhpCsFixerFixFile()
autocmd BufWritePost tests/Smartschool/*.php silent! call PhpCsFixerFixFile()
autocmd BufWritePost spec/Smartschool/*.php silent! call PhpCsFixerFixFile()

nmap <silent><Leader><space> :noh<CR>
]]

-- TRIM WHITESPACES
cmd [[
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

command! TrimWhitespace call TrimWhitespace()
]]

-- RUN TESTS
cmd [[
fun! RunSpectest()
    let l:iterm_scripts_path = $HOME.'/.local/bin/iterm2test.py'
    let l:iterm_python_runtime = 'python3'
    let ws = range(1, winnr('$'))
    for i in ws
        let buffnr = winbufnr(i)
        let path = expand('#'.buffnr)
        if path =~ '^spec'
            echo 'sending ' . path . ' to Vagrant'
            let debugopt = ''
            let status = 0
            if 1 == status
                let debugopt = "debug"
            endif
            execute 'silent !'.printf("%s 'bin/phpspec run %s'", l:iterm_scripts_path, path)
            return
        endif
        if path =~ '^tests'
            echo 'sending ' . path . ' to Vagrant'
            let debugopt = ''
            let status = 0
            if 1 == status
                let debugopt = "debug"
            endif
            execute 'silent !'.printf("%s 'bin/phpunit %s'", l:iterm_scripts_path, path)
            return
        endif
    endfor
    echo 'not a test!'
endfun

command! RunSpectest call RunSpectest()

nmap <silent><Leader>t :call RunSpectest()<CR>
]]

-- PHPACTOR
cmd [[
nmap <Leader>u :call phpactor#UseAdd()<CR>
nmap <Leader>uu :call phpactor#ImportMissingClasses()<CR>

" Invoke the context menu
nmap <Leader>mm :call phpactor#ContextMenu()<CR>

" Invoke the navigation menu
nmap <Leader>nn :call phpactor#Navigate()<CR>

]]

-- PHPCSFIXER
cmd [[
let g:php_cs_fixer_rules="@PSR2"
let g:php_cs_fixer_config_file=getcwd().'/.php_cs'
let g:php_cs_fixer_php_path = "php"               " Path to PHP
" let g:php_cs_fixer_enable_default_mapping = 1     " Enable the mapping by default (<leader>pcd)
let g:php_cs_fixer_dry_run = 0                    " Call command with dry-run option
let g:php_cs_fixer_verbose = 0                    " Return the output of command if 1, else an inline information.
]]
