{
  _ghb = ''_gh burke "$@"'';

  myip = ''ifconfig en0 | grep inet | awk '{print $2}' | tail -n1'';
  cpip = ''myip | tee >(pbcopy)'';

  cpref = ''git rev-parse HEAD | tee >(pbcopy)'';

  fdg = ''find . | grep "$@"'';

  h = ''
    if [[ $# -gt 0 && -z "$${1//[0-9]/}" ]]; then
      n=$1; shift
      head "-$n" "$@"
    else
      head "$@"
    fi
  '';

  t = ''
    if [[ $# -gt 0 && -z "$${1//[0-9]/}" ]]; then
      n=$1; shift
      tail "-$${n}" "$@"
    else
      tail  "$@"
    fi
  '';

  tnp = ''n=$1; shift; tail "-n+$${n}" "$@"'';

  up = ''while [[ ! -d .git ]] && [[ "$(pwd)" != "/" ]]; do cd ".."; done'';

  psag = ''ps aux | grep "$@" | grep -v grep'';

  pyserv = ''
    echo "http://$(myip):8000" | pbcopy
    python -m SimpleHTTPServer
  '';

  gac = ''
    if [[ $# -eq 0 ]] ; then
      git commit -av
    else
      git commit -a -m "$*"
    fi
  '';

  gb    = ''git branch $"$@"'';
  gbsc  = ''gb --show-current'';
  gbt   = ''gb --track "$1" "origin/$1"'';

  gc    = ''git commit'';
  gcm   = ''gc -m "$*"'';

  gfr   = ''git fetch -q "$@" && git reset -q --hard FETCH_HEAD'';
  gfro  = ''gfr origin "$@"'';
  gfrog = ''gfro "$(gbsc)"'';
  gfrom = ''gfro master'';

  ghg   = ''open "https://github.com/$1"'';
  ghgb  = ''ghg "burke/$1"'';
  ghgs  = ''ghg "Shopify/$1"'';

  gufo  = ''git push --force-with-lease origin "$@"'';
  gufg  = ''gufo "$(gbsc)" "$@"'';

  guo   = ''git push origin "$@"'';
  gug   = ''guo "$(gbsc)"'';

  git-abort = ''
    set -euo pipefail
    gitdir="$(git rev-parse --git-dir)"

    if [[ -f "$gitdir/CHERRY_PICK_HEAD" ]]; then git cherry-pick --abort; fi
    if [[ -f "$gitdir/MERGE_HEAD" ]];       then git merge --abort;       fi
    if [[ -d "$gitdir/rebase-merge" ]];     then git rebase --abort;      fi
  '';

  kc    = ''kubectl "$@"'';
  kca   = ''kc apply "$@"'';
  kcl   = ''kc logs "$@"'';
  kclf  = ''kcl -f "$@"'';

  kc6   = ''kc delete "$@"'';
  kc6i  = ''kc6 instance "$@"'';
  kc6p  = ''kc6 pod "$@"'';

  kcd   = ''kc describe "$@"'';
  kcdi  = ''kcd instance "$@"'';
  kcdp  = ''kcd pod "$@"'';

  kcg   = ''kc get "$@"'';
  kcgi  = ''kcg instance "$@"'';
  kcgp  = ''kcg pod "$@"'';

  kcx = ''
    if [[ -p /dev/stdin ]]; then
      set -- "$(cat)" "$@"
    fi
    kc exec "$@"
  '';

  s3putpublic = ''s3cmd put --acl-public "$1" "s3://burkelibbey/$1"'';
}
