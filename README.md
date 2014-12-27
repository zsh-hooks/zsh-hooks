Install
-------

Use [antigen](https://github.com/zsh-users/antigen) or [antigen-hs](https://github.com/Tarrasch/antigen-hs).  Here is how to do it with antigen:

    antigen bundle willghatch/zsh-hooks

Usage
-----

    hooks-define-hook <hook_variable_name> # defines a new hook that can be added to
    hooks-run-hook <hook_variable_name> # runs all functions added to the hook
    hooks-add-hook [ops] <hook_variable_name> <function> # adds function to hook
        # options: -d to remove from hook, -D to remove with pattern
        # everything else accepted by add-zsh-hook works... because it's the same

What??
------

That's right.  hooks-add-hook is shamelessly taken from add-zsh-hook, and modified
to be able to run on user defined hooks.  Why is this important??  Because zsh has
defined certain magic functions such as zle-line-init and zle-keymap-select that
if defined are run, but which can only have one definition.  The answer: define it
to be a function that simply runs a hook.  So this plugin provides:

- zle_line_init_hook - these functions run on line init!
- zle_keymap_select_hook - these functions run when you switch your keymap!
- similar to the previous two, all of the other special functions documented [here](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Special-Widgets)
- $ZSH_CUR_KEYMAP - this variable is set on line init/keymap change!

Why?
----

Plugin authors might want to use this functionality, but if they do it will conflict
with what end-users do.  This can solve that problem.  Basically this is made to
be a dependency for other plugins.
