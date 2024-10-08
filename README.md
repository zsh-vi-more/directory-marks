*This plugin may get renamed to `vi-directory-jump`
and add implementations for
`Ctrl-o`, `Ctrl-i`, and `:ju[mps]`.*

# Directory Marks

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

- `vi-dir-marks::list`: Lists all marks.
- `vi-dir-marks::{mark,jump}`: These are primarily widget functions,
but they work outside of ZLE.

## Differences with Vim

There are no special marks at this time.
`''`, `'<`, `'(`, etc. are all normal local marks.

If you have ideas for implementing these,
please open an issue.

