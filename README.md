This plugin is based on GreedyBackspace plugin
'https://github.com/vim-scripts/GreedyBackspace.vim'

This plugin will cause your backspace key to delete all the white spaces to the
previous tabstop.
For example, if you typed 'printf("Hello World!");     ' and then hit
backspace, you'd only have 'printf("Hello World!"); '.
Its behaviour is similar to softtabstop, but it doesn't care of how do you put
white spaces - with tab key or spacebar.

This plugin will cause your delete key to delete &tabstop or less white spaces
after character.
For example, if you typed 'printf("Hello World!");     ' and then twice hit hit
left and then delete, you'd only have 'printf("Hello World!");   '.

This plugin works only when expandtab is enabled. You are free to set or unset
this opthion.
Plugin will switch on or off accordingly.
