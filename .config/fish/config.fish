if status is-interactive
    function take
        if string match -qr '^([A-Za-z0-9]+@|https?|git|ssh|ftps?|rsync).*\.git/?$' $argv[1]
            git clone $argv[1]; and cd (basename (string replace -r '\.git$' '' $argv[1]))
        else
            mkdir -p $argv[1]; and cd $argv[1]
        end
    end

    function repeat
        for i in (seq $argv[1])
            $argv[2..-1]
        end
    end

    # faster command not found
    function fish_command_not_found
        __fish_default_command_not_found_handler $argv[1]
    end

    if command -q fasd
        # fasd
        function __fasd_init -e fish_postexec -d "fasd takes record of the directories changed into"
            set -lx RETVAL $status
            if test $RETVAL -eq 0 # if there was no error
                command fasd --proc (command fasd --sanitize "$argv" | tr -s " " \n) >/dev/null 2>&1 &
                disown
            end
        end

        function __fasd_print_completion
            set cmd (commandline -po)
            test (count $cmd) -ge 2; and fasd $argv $cmd[2..-1] -l
        end

        function fasd_cd -d "fasd builtin cd"
            if test (count $argv) -le 1
                command fasd "$argv"
            else
                fasd -e 'printf %s' $argv | read -l ret
                test -z "$ret"; and return
                test -d "$ret"; and cd "$ret"; or printf "%s\n" $ret
            end
        end

        function __fasd_print_completion
            set cmd (commandline -po)
            test (count $cmd) -ge 2; and fasd $argv $cmd[2..-1] -l
        end

        function z
            fasd_cd -d $argv
        end
        complete -c z -a "(__fasd_print_completion -d)" -f

        function fasd_inline
            set -l opts (fasd -lR (string replace -r '^,' '' $argv[1]))
            if test (count $opts) -gt 1
                printf '%s\n' $opts | fzf --height 10
            else
                echo $opts[1]
            end
            commandline -f repaint
        end
        abbr --add fasd_inline --position anywhere --regex ',[^ ]+' --function fasd_inline
    end

    function kc_abbr
        echo 'kubectl --context '(kubectl config get-contexts -o name | fzf --height 10); and commandline -f repaint
    end
    abbr --add kc --function kc_abbr

    # get zsh like up/down

    # from: type up-or-search
    function up-or-prefix-search --description 'Search back or move cursor up 1 line'
        # If we are already in search mode, continue
        if commandline --search-mode
            commandline -f history-prefix-search-backward
            return
        end

        # If we are navigating the pager, then up always navigates
        if commandline --paging-mode
            commandline -f up-line
            return
        end

        # We are not already in search mode.
        # If we are on the top line, start search mode,
        # otherwise move up
        set -l lineno (commandline -L)

        switch $lineno
            case 1
                commandline -f history-prefix-search-backward

            case '*'
                commandline -f up-line
        end
    end
    bind --preset \e\[A up-or-prefix-search

    # from: type down-or-search
    function down-or-prefix-search --description 'search forward or move down 1 line'
        # If we are already in search mode, continue
        if commandline --search-mode
            commandline -f history-prefix-search-forward
            return
        end

        # If we are navigating the pager, then up always navigates
        if commandline --paging-mode
            commandline -f down-line
            return
        end

        # We are not already in search mode.
        # If we are on the bottom line, start search mode,
        # otherwise move down
        set -l lineno (commandline -L)
        set -l line_count (count (commandline))

        switch $lineno
            case $line_count
                commandline -f history-prefix-search-forward

            case '*'
                commandline -f down-line
        end
    end
    bind --preset \e\[B down-or-prefix-search

    set puser (whoami)
    set phost (prompt_hostname)

    function fish_prompt
        set -l last_status $status
        set -l stat
        if test $last_status -ne 0
            set stat (set_color -o red)"$last_status "(set_color normal)
        end

        set -l git_root $PWD
        while test $git_root != / -a ! -e "$git_root/.git"
            set git_root (dirname $git_root)
        end
        set -l prompt
        if test $git_root = /
            set prompt (prompt_pwd)
        else
            set parent (dirname $git_root)
            set prompt (string replace -r "^$parent/" "" $PWD)
        end

        set -l git_branch (git branch 2>/dev/null | sed -n '/\* /s///p')
        if test -n "$git_branch"
            set git_branch (set_color -o cyan)" "$git_branch
        end

        string join '' -- [ $stat (set_color -o green) $puser@$phost (set_color -o normal) ' ' $prompt (set_color normal) $git_branch (set_color normal) ] ' '
    end

    set -g fish_greeting
    set -g fish_autosuggestion_enabled 0

    if command -q nvim
        set -gx EDITOR nvim
        abbr --add vim nvim
    else if command -q vim
        set -gx EDITOR vim
    else if command -q vi
        set -gx EDITOR vi
    end

    set -gx PAGER less

    abbr --add g git
    abbr --add xc xclip -sel clip
    alias c="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

    if command -q eza
        function ll
            eza -la
        end
    end

    if functions -q fzf_key_bindings
        fzf_key_bindings
    end

    set -gx NODE_OPTIONS --use-openssl-ca

    set -U fish_color_normal normal
    set -U fish_color_command 586e75
    set -U fish_color_keyword 586e75
    set -U fish_color_quote 839496
    set -U fish_color_redirection 6c71c4
    set -U fish_color_end 268bd2
    set -U fish_color_error dc322f
    set -U fish_color_param 657b83
    set -U fish_color_comment 93a1a1
    set -U fish_color_match --background=brblue
    set -U fish_color_selection white --bold --background=brblack
    set -U fish_color_search_match bryellow --background=white
    set -U fish_color_history_current --bold
    set -U fish_color_operator 00a6b2
    set -U fish_color_escape 00a6b2
    set -U fish_color_cwd green
    set -U fish_color_cwd_root red
    set -U fish_color_option 657b83
    set -U fish_color_valid_path --underline
    set -U fish_color_autosuggestion 93a1a1
    set -U fish_color_user brgreen
    set -U fish_color_host normal
    set -U fish_color_host_remote yellow
    set -U fish_color_history_current --bold
    set -U fish_color_status red
    set -U fish_color_cancel --reverse
    set -U fish_pager_color_prefix cyan --underline
    set -U fish_pager_color_progress brwhite --background=cyan
    set -U fish_pager_color_completion green
    set -U fish_pager_color_description B3A06D
    set -U fish_pager_color_selected_background --background=white
    set -U fish_pager_color_secondary_description
    set -U fish_pager_color_secondary_prefix
    set -U fish_pager_color_selected_completion
    set -U fish_pager_color_selected_description
    set -U fish_pager_color_secondary_completion
    set -U fish_pager_color_secondary_background
    set -U fish_pager_color_selected_prefix
    set -U fish_pager_color_background

    bind \cc 'if test (commandline -b) = ""; echo ""; and commandline -f repaint; else; commandline -f cancel-commandline; end'

    function fish_hybrid_key_bindings --description \
    "Vi-style bindings that inherit emacs-style bindings in all modes"
        for mode in default insert visual
            fish_default_key_bindings -M $mode
        end
        fish_vi_key_bindings --no-erase
    end
set -g fish_key_bindings fish_hybrid_key_bindings
end
