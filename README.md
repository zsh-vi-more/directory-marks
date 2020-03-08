# Directory Marks

Save directories and jump between them
with vi-like marks.

## Bindings added:


| Map | Keybinding | Action |
| --- | --- | --- |
| `vicmd` | `'<char>` ``` `<char>``` | Jump to mark |
| `vicmd` | `m<key>` | create mark at current working directory |
| *(none)_ | widget name: "marks" | list marks|

I recommend `bindkey -M vicmd : execute-named-cmd`,
so that `:marks` works like vi(m).

## Functions added

- `vi-dir-marks::sync`: Read in any missing global marks,
write out global marks to a cache file
(prioritizes global marks present in local session)
- `vi-dir-marks::list`: Lists all marks.
- `vi-dir-marks::{mark,jump}`: These are primarily widget functions,
but they work outside of ZLE.

