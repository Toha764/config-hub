# Linux CLI Tools

_A curated set of modern terminal utilities that improve the shell experience._

---

# Modern CLI Tools (Recommended)

## Core Command Replacements

| Tool        | Replaces | Description                                                      | Usage                           |
| ----------- | -------- | ---------------------------------------------------------------- | ------------------------------- |
| **eza**     | `ls`     | Modern directory listing with icons, git integration, tree view. | `ls`, `l`, `la`, `ll` (aliases) |
| **ripgrep** | `grep`   | Extremely fast recursive search tool.                            | `rg <pattern>`                  |
| **fd**      | `find`   | Simple, fast file search with intuitive syntax.                  | `fd <pattern>`                  |
| **bat**     | `cat`    | File viewer with syntax highlighting and git integration.        | `cat file`                      |
| **dust**    | `du`     | Intuitive disk usage viewer with better visualization.           | `du`                            |
| **procs**   | `ps`     | Modern process viewer with better formatting.                    | `ps`                            |

---

## Shell Navigation & Productivity

| Tool       | Description                                               | Usage              |
| ---------- | --------------------------------------------------------- | ------------------ |
| **fzf**    | General-purpose fuzzy finder used across shell workflows. | `Ctrl+R`, `Ctrl+T` |
| **zoxide** | Smarter `cd` that learns frequently used directories.     | `z <dir>`          |
| **tldr**   | Simplified community-driven man pages.                    | `tldr <command>`   |

---

## Nix Ecosystem Tools

| Tool          | Description                                                | Usage                                 |
| ------------- | ---------------------------------------------------------- | ------------------------------------- |
| **comma**     | Run software without installing it permanently.            | `, <command>`                         |
| **nix-tree**  | Browse dependency graphs of Nix derivations interactively. | `nix-tree`                            |
| **nix-index** | Database of files in nixpkgs; powers `command-not-found`.  | `nix-locate <file>`                   |
| **nvd**       | Compare package versions between Nix generations.          | `nvd diff /run/current-system result` |

---

## Development & Workflow

| Tool              | Description                                              | Usage                 |
| ----------------- | -------------------------------------------------------- | --------------------- |
| **neovim (nvim)** | Highly extensible modal text editor.                     | `nvim`                |
| **lazygit**       | Terminal UI for Git operations.                          | `lazygit`             |
| **direnv**        | Automatically loads environment variables per directory. | `.envrc`              |
| **nix-direnv**    | Faster Nix environment loading for direnv.               | `use nix` in `.envrc` |
| **stow**          | Manage dotfiles using symlinks.                          | `stow <package>`      |

---

## Utilities

| Tool        | Description                                               | Usage         |
| ----------- | --------------------------------------------------------- | ------------- |
| **jq**      | Command-line JSON processor.                              | `jq '.field'` |
| **btop**    | Modern system/process monitor with rich UI.               | `btop`        |
| **yazi**    | Fast terminal file manager with zoxide & fzf integration. | `yazi`        |
| **thefuck** | Suggests the correct command after a mistake.             | `fuck`        |

