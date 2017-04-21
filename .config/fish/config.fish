# vi: ft=fish foldmethod=marker:

# {{{ load generic configuration
egrep "^export " ~/.profile | while read e
  set var (echo $e | sed -E "s/^export ([A-Z_]+)=(.*)\$/\1/")
  set value (echo $e | sed -E "s/^export ([A-Z_]+)=(.*)\$/\2/")

  # remove surrounding quotes if existing
  set value (echo $value | sed -E "s/^\"(.*)\"\$/\1/")

  if test $var = "PATH"
    # replace ":" by spaces. this is how PATH looks for Fish
    set value (echo $value | sed -E "s/:/ /g")

    # use eval because we need to expand the value
    eval set -xg $var $value

    continue
  end

  # evaluate variables. we can use eval because we most likely just used "$var"
  set value (eval echo $value)

  set -gx $var $value
end

awk '
  /^[^#]/ {
    cmd=$0
    sub(/.*?:/, "", cmd)
    gsub(/&&/, "; and", cmd)
    gsub(/\|\|/, "; or", cmd)
    print "function "$1"; "cmd" $argv; end"
  }
' < ~/.sshrc.d/aliases | while read line; eval "$line"; end

eval (gdircolors -c ~/.sshrc.d/LS_COLORS | sed 's/setenv/set -gx/')
# }}}

# {{{ prompt configuration
set fish_greeting ""

function fish_mode_prompt --description "Displays the current mode"
  # Do nothing if not in vi mode
  if test "$fish_key_bindings" = "fish_vi_key_bindings"
    switch $fish_bind_mode
      case default
        set_color magenta
        echo 'N'
      case insert
        set_color cyan
        echo 'I'
      case replace-one
        set_color --bold green
        echo 'R'
      case visual
        set_color --bold red
        echo 'V'
    end
    set_color normal
    echo -n ' '
  end
end

set normal (set_color normal)
set magenta (set_color magenta)
set yellow (set_color yellow)
set green (set_color green)
set red (set_color red)
set gray (set_color -o black)

set -g fish_color_cwd blue

# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showcolorhints 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_show_informative_status 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡ '
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'

function fish_prompt
  set last_status $status

  set_color $fish_color_cwd
  printf '%s' (prompt_pwd)
  set_color normal

  printf '%s ' (__fish_git_prompt)

  set -l jobs (count (jobs))
  if test $jobs -ne 0
    set_color white
    printf '↩'
    set_color white -o
    printf '%d ' $jobs
    set_color normal
  end

  if test $last_status -ne 0
      set_color red
      printf '✗'
      set_color red -o
      printf '%d ' $last_status
      set_color normal
  end

  set_color normal
end
# }}}

# {{{ gpg-agent
gpg-agent --daemon >/dev/null 2>&1
# used by the mutt alias
function kick-gpg-agent
  set -l pid (ps xo pid,command | grep -E "^\d+ gpg-agent" | awk '{print $1}')
  set -gx GPG_AGENT_INFO /Users/burke/.gnupg/S.gpg-agent:$pid:1
end
kick-gpg-agent 
set -x GPG_TTY (tty)
# }}}

function ls
  gls --color=auto -F $argv
end

function git
  set -l toplevel (command git rev-parse --show-toplevel 2>/dev/null)
  if test "$toplevel" = "$HOME" -a "$argv[1]" = "clean"
    echo "Do NOT run git clean in this repository." >&2
  else
    command git $argv
  end
end

function gh
  cd (_gh $argv)
end

function ghs
  cd (_ghs $argv)
end

function ghb
  cd (_ghb $argv)
end

function ]gs
  cd (_]gs $argv)
end

function ]gb
  cd (_]gb $argv)
end

if test -f /opt/dev/dev.fish
  source /opt/dev/dev.fish
end
