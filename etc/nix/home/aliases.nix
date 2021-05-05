{
  "do,s" = "dev open shipit";
  "do,pr" = "dev open pr";

  git-fuck-everything =
    "git-abort ; git reset . ; git checkout . ; git clean -f -d";

  ls = "ls --color=auto -F";

  jc = "journalctl";
  sc = "systemctl";

  x1 = "xargs -n1";
  th = "tail -n+2";

  # u/uu/uuu/... {{{
  u = "cd ..";
  uu = "cd ../..";
  uuu = "cd ../../..";
  uuuu = "cd ../../../..";
  uuuuu = "cd ../../../../..";
  uuuuuu = "cd ../../../../../..";
  # }}}
  # c$n[h]/... {{{
  c1 = "cn 1";
  c2 = "cn 2";
  c3 = "cn 3";
  c4 = "cn 4";
  c5 = "cn 5";
  c6 = "cn 6";
  c7 = "cn 7";
  c8 = "cn 8";
  c9 = "cn 9";

  c1h = "cn -h 1";
  c2h = "cn -h 2";
  c3h = "cn -h 3";
  c4h = "cn -h 4";
  c5h = "cn -h 5";
  c6h = "cn -h 6";
  c7h = "cn -h 7";
  c8h = "cn -h 8";
  c9h = "cn -h 9";
  # }}}
  # }}}
  # Ruby / Bundler {{{
  bi = "bundle install";
  bo = "bundle open";
  bu = "bundle update";
  bs = "bundle show";
  bx = "bundle exec";
  mu = "gem uninstall";
  mi = "gem install";

  # }}}
  # Projects {{{
  shop = "dev cd shopify";
  note = "ghb notes";
  sruby = "gh ruby ruby";
  # }}}
  # Git {{{

  grbom =
    "gcom && gfrom && git reset --hard FETCH_HEAD && gco - && git rebase master";
  grbog = "grbom && gufg";

  gb = "git branch";

  gzb = "git branch -l | fzf | xargs git checkout";
  gzt = "git tag -l | fzf | xargs git checkout";
  gzd = "git branch -l | fzf | xargs git branch -d";
  gzD = "git branch -l | fzf | xargs git branch -D";
  gzri =
    "git log -30 --format=oneline | fzf | cut -d ' ' -f 1 | xargs git rebase -i";

  gtl = "git tag -l";
  ga = "git add";
  gap = "git add -p";
  gaac = "git add -A .; gac";
  gav = "git commit -av";
  gbl = "git branch -l";
  gbd = "git branch -D";
  gu = "git push";
  gut = "git push --tags";
  gutf = "git push --tags -f";
  gcaar = "git add -A .; git commit -a --reuse-message=HEAD --amend";
  gcar = "git commit -a --reuse-message=HEAD --amend";
  gco = "git checkout";
  gcob = "git checkout -b";
  gcom = "gco master";
  gcp = "git cherry-pick";
  gd = "git pull";
  gf = "git diff";
  gfc = "git diff --cached";
  gl = "git log";
  glr = "git log --reverse";
  glp = "git log -p";
  glpr = "git log -p --reverse";
  gm = "git merge";
  gn = "git clone";
  gri = "git rebase -i";
  grc = "git rebase --continue";
  gra = "git rebase --abort";
  gcpa = "git cherry-pick --abort";
  gma = "git merge --abort";
  gs = "git stash";
  gsa = "git stash apply";
  gsd = "git stash drop";
  gsl = "git stash list";
  gsp = "git stash pop";
  gt = "git status -sb";
  gwc = "git whatchanged";
  gr = "git reset HEAD";
  gr1 = "git reset 'HEAD^'";
  gr2 = "git reset 'HEAD^^'";
  gro = "git reset";
  grh = "git reset --hard HEAD";
  grh1 = "git reset --hard 'HEAD^'";
  grh2 = "git reset --hard 'HEAD^^'";
  grho = "git reset --hard";
  # }}}
  # Head / Tail {{{
  h1 = "h 1";
  h2 = "h 2";
  h3 = "h 3";
  h4 = "h 4";
  h5 = "h 5";
  h6 = "h 6";
  h7 = "h 7";
  h8 = "h 8";
  h9 = "h 9";
  h10 = "h 10";
  h15 = "h 15";
  h20 = "h 20";
  h30 = "h 30";
  h40 = "h 40";
  h50 = "h 50";
  h60 = "h 60";

  t1 = "t 1";
  t2 = "t 2";
  t3 = "t 3";
  t4 = "t 4";
  t5 = "t 5";
  t6 = "t 6";
  t7 = "t 7";
  t8 = "t 8";
  t9 = "t 9";
  t10 = "t 10";
  t15 = "t 15";
  t20 = "t 20";
  t30 = "t 30";
  t40 = "t 40";
  t50 = "t 50";
  t60 = "t 60";
  # }}}
  # {{{ dev
  dld = "dev load-dev --no-backend";
  dls = "dev load-system --no-backend";
  # }}}

  mutt = "kick-gpg-agent && command mutt";
  less = "/usr/bin/less -FXRS";
  tmux = "/usr/bin/env TERM=screen-256color-bce tmux";
  tree = "command tree -I 'Godep*' -I 'node_modules*'";

  xk9 = "xargs kill -9";
  ka9 = "killall -9";
  k9 = "kill -9";

  m = "hostname-fix ; mutt";
  a = "ag";
  ai = "ag -i";
  aa = "ag -a";
  aai = "ag -ai";
  g = "grep";
  chx = "chmod +x";

  ctr = "ctags -R .";
  gtr = "gotags -R . > tags";

  l1 = "tree --dirsfirst -ChFL 1";
  l2 = "tree --dirsfirst -ChFL 2";
  l3 = "tree --dirsfirst -ChFL 3";
  ll1 = "tree --dirsfirst -ChFupDaL 1";
  ll2 = "tree --dirsfirst -ChFupDaL 2";
  ll3 = "tree --dirsfirst -ChFupDaL 3";
  l = "l1";
  ll = "ll1";
}
