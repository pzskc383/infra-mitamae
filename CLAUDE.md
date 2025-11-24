# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a mitamae configuration for managing OpenBSD servers. Mitamae is an mruby-based configuration management tool (mini-Chef) that manages three OpenBSD VPS instances for DNS, mail, and web services.

**Key servers:**
- **airstrip1** (a1): Primary server (DNS, mail, certificates, web)
- **b0rsch** (b0): Secondary server (DNS, mail relay, web)
- **f0rk** (f0): Minimal secondary (DNS only)

## Common Commands

### Secrets Management
```bash
# Decrypt secrets before working
rake sops:decrypt

# Re-encrypt secrets after editing
rake sops:encrypt
```

### Deployment
```bash
# List all hosts
hocho list

# Deploy to specific host (dry-run)
hocho apply --dry-run airstrip1

# Deploy to specific host
hocho apply airstrip1
```

### Development
```bash
# Lint Ruby code
bundle exec standardrb

# Fix linting issues automatically
bundle exec standardrb --fix
```

## Architecture

### Mitamae vs Chef

While mitamae looks like Chef, **it is NOT Chef**. Refer to `misc/mitamae/mrblib/mitamae/` for the actual mitamae implementation. Key differences:

- **mruby-based**: Compiled, not Ruby. Limited stdlib.
- **Resource model**: Similar to Chef but simplified. See `misc/mitamae/mrblib/mitamae/resource/base.rb` for the base resource implementation.
- **Plugin system**: Custom resources live in `plugins/` and follow the naming pattern `{,m}itamae-plugin-resource-*/mrblib/**/*.rb`.

### Directory Structure

```
/
├── hocho.yml                      # Hocho configuration
├── Rakefile                       # SOPS encryption/decryption tasks
├── .sops.yaml                     # SOPS encryption configuration
├── data/                          # Host definitions and variables
│   ├── hosts/                     # Per-host SOPS-encrypted configs
│   │   ├── a1.sops.yml            # airstrip1 config
│   │   ├── b0.sops.yml            # b0rsch config
│   │   └── f0.sops.yml            # f0rk config
│   └── vars/
│       ├── default.yml            # Global variables
│       └── secrets.sops.yml       # Encrypted secrets
├── cookbooks/                     # Mitamae recipes
│   ├── openbsd_server/            # Main server config (vim, network, DNS)
│   ├── openbsd_admin/             # Admin tools (git, zsh, doas, tmux)
│   └── openbsd_com0/              # Serial console configuration
├── plugins/                       # Custom mitamae plugins
│   ├── mitamae-plugin-resource-openbsd_package/
│   └── mitamae-plugin-resource-cron/  # Git submodule
├── lib/                           # Custom extensions
│   ├── mitamae_ext.rb             # Adds --sudo-command to mitamae
│   ├── hocho_ext.rb               # OpenBSD compatibility (doas, sh)
│   ├── property_script.rb         # Variable/secrets loading
│   └── hocho/inventory_providers/
│       └── sops_file.rb           # SOPS-encrypted inventory provider
├── dist/                          # Pre-compiled mitamae binaries
│   ├── mitamae-arm64-openbsd
│   └── mitamae-x86_64-openbsd
└── misc/                          # Reference materials (git submodules)
    ├── mitamae/                   # Mitamae source
    ├── sorah-cnw/                 # Example configs
    └── example-ruby-*/            # Ruby infra examples
```

### Hocho Integration

**Hocho** is a mitamae wrapper for multi-host orchestration.

Key files:
- `hocho.yml`: Defines inventory providers, property providers, and driver options
- `data/hosts/*.sops.yml`: SOPS-encrypted host configurations with run_list
- `data/vars/default.yml`: Global variables (domain, DNS, mail config)
- `data/vars/secrets.sops.yml`: Encrypted secrets

Custom extensions in `lib/`:
- **`mitamae_ext.rb`**: Adds `--sudo-command` CLI option to mitamae for configurable privilege escalation
- **`hocho_ext.rb`**: Patches hocho for OpenBSD compatibility
  - Uses `sh` instead of `bash`
  - Passes `sudo_command` from host properties to mitamae
  - Password-based privilege escalation via openssl/askpass
- **`property_script.rb`**: Loads `default.yml` and decrypts `secrets.sops.yml` into host attributes
- **`sops_file.rb`**: Custom inventory provider that decrypts SOPS host files

Configuration flow:
1. Hocho reads `hocho.yml` configuration
2. Loads host inventory via `sops_file` provider (decrypts SOPS YAML)
3. Applies property providers to inject variables and secrets
4. Executes mitamae driver with doas support

### Custom Plugins

#### openbsd_package

`plugins/mitamae-plugin-resource-openbsd_package/` provides `openbsd_package` resource:

**Resource definition** (`mrblib/resource/openbsd_package.rb`):
- Attributes: `name`, `version`, `flavor`, `branch`
- Actions: `:install`, `:remove`

**Executor** (`mrblib/resource_executor/openbsd_package.rb`):
- Parses OpenBSD package names with regex (VERSION_RE, FUZZY_RE)
- Uses `pkg_info`, `pkg_add`, `pkg_delete` commands
- Handles package versions, flavors (e.g., `no_x11`), and branches

Usage example:
```ruby
openbsd_package "vim" do
  action :install
  flavor "no_x11"
end
```

#### cron

`plugins/mitamae-plugin-resource-cron/` (git submodule from itamae-plugins):

**Attributes**: `minute`, `hour`, `day`, `month`, `weekday`, `command`, `user`, `mailto`, `path`, `shell`, `home`, `time`, `environment`

**Actions**: `:create`, `:delete`

Usage example:
```ruby
cron "backup_job" do
  hour "2"
  minute "0"
  command "/usr/local/bin/backup.sh"
end
```

### Reference Materials
- Mitamae source: `misc/mitamae/mrblib/mitamae/`
- Example configs: `misc/sorah-cnw/`
