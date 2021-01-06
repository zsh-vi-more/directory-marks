*This plugin may get renamed to `vi-directory-jump`
and add implementations for
`Ctrl-o`, `Ctrl-i`, and `:ju[mps]`.*

# Directory Marks

[![Gitter](https://badges.gitter.im/zsh-vi-more/community.svg)](https://gitter.im/zsh-vi-more/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![Matrix](https://img.shields.io/matrix/zsh-vi-more_community:gitter.im)](https://matrix.to/#/#zsh-vi-more_community:gitter.im)

Save directories and jump between them
with vi-like marks.

## Bindings added:

| Map | Keybinding | Action |
| --- | --- | --- |
| `vicmd` | `'<char>` ``` `<char>``` | Jump to mark |
| `vicmd` | `m<char>` | create mark at current working directory |
| *(none)* | widget name: "marks" | list marks|

I recommend `bindkey -M vicmd : execute-named-cmd`,
so that `:marks` works like vi(m).

## Functions added

- `vi-dir-marks::sync`: Read in any missing global marks,
write out global marks to a cache file
(prioritizes global marks present in local session)
- `vi-dir-marks::list`: Lists all marks.
- `vi-dir-marks::{mark,jump}`: These are primarily widget functions,
but they work outside of ZLE.

## Differences with Vim

There are no special marks at this time.
`''`, `'<`, `'(`, etc. are all normal local marks.

If you have ideas for implementing these,
please open an issue.

