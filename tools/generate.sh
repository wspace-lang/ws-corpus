#!/bin/sh

# Generate assembly.md

echo '# Whitespace assembly instructions

<!-- Generated by tools/generate.sh; DO NOT EDIT. -->

These are the names used by known Whitespace assembly dialects for
instructions, ranked by popularity.
' > assembly.md

jq -r '
reduce (.[].assembly.instructions | select(. != null) | to_entries[]) as $inst
       ({}; .[$inst.key] += $inst.value)
| to_entries[].value
| map(ascii_downcase) | group_by(.) | sort_by(-length)
| map("`\(.[0])`" + if length != 1 then " (\(length | tostring))" else "" end)
| "- " + join(", ")
' projects.json >> assembly.md

# Generate building.md

echo '# Building projects

<!-- Generated by tools/generate.sh; DO NOT EDIT. -->

This is a list of projects that have building and running documented.
Build errors are included.
' > building.md

jq -r '
[
  .[] | . as $p | .commands[]? |
  "- \($p.path)/\(.bin)"
  + if .build!= null then " `\(.build//"")`" else "" end
  + if .build_errors!=null then ": \(.build_errors//"")" else "" end
] | sort[]
' projects.json >> building.md
