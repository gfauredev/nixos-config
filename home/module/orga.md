# Data Organization Conventions

- **author**: Deliberately created or modified, potentially indirectly
  - Gathering: Reason of the creation, pursued goal that led to it
    - Non-authored can be referenced in a references register (e.g. `bib.md`)
  - In filesystem, **author** is the only directory with `exec` permission
- **collect**: Obtained from other people or systems, unmodified
  - Gathering: Origin, entity considered author/creator or containing it, entity
    type or group, or if unknown, channel or entity from which it was obtained
    - Sub-gathering: Eventual second layer of more precise origin, if needed
  - **collect** (sub)gatherings should be synced between browser bookmarks,
    filesystem directories, email (or messaging app) directories…
- **shelve**: Deliberately created or modified, won’t be modified/used anymore
  - Gathering: Reason of the creation, pursued goal that led to it
    - Non-authored can be referenced in a references register (e.g. `bib.md`)

## Naming Conventions

- Gathering names are concise, camelCase, preferrably only `[a-zA-Z0-9_-]`
  - Eventual _project_ or area of _responsibility_ name after a `+` (NO SPACES)
  - Eventual alternate names, acronyms or abreviations after `+`s (NO SPACES)
- For filesystems, eventual tag(s) before filetype, beginning with `.`s
  - `.git`: It’s a Git repository, should not be synced otherwise
  - `.large`: Should not be synced with lower capacity devices
  - `.local`: Should not be synced at all, specific to this device
