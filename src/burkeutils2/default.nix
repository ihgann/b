{ stdenv      ? (import <nixpkgs> { }).stdenv
, ruby        ? (import <nixpkgs> { }).ruby
, lib         ? (import <nixpkgs> { }).lib
, bash        ? (import <nixpkgs> { }).bash
, runCommand  ? (import <nixpkgs> { }).runCommand
, writeScript ? (import <nixpkgs> { }).writeScript
}:

with builtins;
with lib;
let
  isPath = x: typeOf x == "path" || (isString x && hasPrefix "/" x);

  toPaths = prefix: val: if isPath val || isDerivation val
                         then [{ name  = prefix;
                                 value = val; }]
                         else concatMap (n: toPaths (if prefix == ""
                                                        then n
                                                        else prefix + "/" + n)
                                                    (getAttr n val))
                                        (attrNames val);

  toCmds = attrs: map (entry: with {
                                n = escapeShellArg entry.name;
                                v = escapeShellArg entry.value;
                              };
                              ''
                                mkdir -p "$(dirname "$out"/${n})"
                                ln -s ${v} "$out"/${n}
                              '')
                      (toPaths "" attrs);

  # http://chriswarbo.net/projects/nixos/useful_hacks.html
  attrsToDirs = attrs: runCommand "merged" {}
    (''mkdir -p "$out"'' + concatStringsSep "\n" (toCmds attrs));

  scripts = import ./scripts.nix;
  scriptFiles = builtins.mapAttrs (name: body: writeScript name "#!${bash.out}/bin/bash\n${body}\n") scripts;
  structure = { bin = scriptFiles; };

in attrsToDirs structure
