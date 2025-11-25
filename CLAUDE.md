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
- **Plugin system**: Custom resources live in `plugins/` and follow the naming  pattern `{,m}itamae-plugin-resource-*/mrblib/**/*.rb`.

### Directory Structure

```
/
├── hocho.yml                      # Hocho configuration
├── Rakefile                       # SOPS encryption/decryption tasks
├── .sops.yaml                     # SOPS encryption configuration
├── data/                          # Host definitions and variables
│   ├── hosts/                     # Per-host configs (directories)
│   │   ├── airstrip1/
│   │   │   ├── default.yml        # Host properties and run_list
│   │   │   └── secrets.sops.yml   # SOPS-encrypted host secrets
│   │   ├── b0rsch/
│   │   │   ├── default.yml
│   │   │   └── secrets.sops.yml
│   │   └── f0rk/
│   │       ├── default.yml
│   │       └── secrets.sops.yml
│   └── vars/
│       ├── default.yml            # Global variables
│       └── secrets.sops.yml       # Encrypted global secrets
├── cookbooks/                     # Mitamae recipes
│   ├── openbsd_server/            # Main server config (vim, network, etc)
│   ├── openbsd_admin/             # Admin tools (git, zsh, doas, tmux)
│   ├── openbsd_com0/              # Serial console configuration
│   ├── pf/                        # Packet filter (firewall) configuration
│   ├── knot/                      # Knot DNS server
│   └── dickd/                     # Custom dickd service
├── plugins/                       # Custom mitamae plugins
│   ├── mitamae-plugin-resource-openbsd_package/
│   └── mitamae-plugin-resource-cron/  # Git submodule
├── lib/                           # Custom extensions
│   ├── mitamae_ext.rb             # Removes sudo/doas (running as root)
│   ├── mitamae_defines.rb         # Custom resource definitions
│   ├── hocho_ext.rb               # OpenBSD compatibility (sh, doas)
│   └── hocho/inventory_providers/
│       └── yaml_dir.rb            # YAML directory inventory provider
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
- `data/hosts/*/default.yml`: Host properties and run_list
- `data/hosts/*/secrets.sops.yml`: SOPS-encrypted host-specific secrets (SSH credentials, network config)
- `data/vars/default.yml`: Global variables (domain, DNS, mail config)
- `data/vars/secrets.sops.yml`: Encrypted global secrets

Custom extensions in `lib/`:
- **`mitamae_ext.rb`**: Removes sudo/doas command wrapping (since we connect as root directly)
  - Overrides `build_command` to skip user switching
  - Connects node object to backend for custom resource access
- **`mitamae_defines.rb`**: Custom resource definitions (block_in_file, line_in_file, notify!)
- **`hocho_ext.rb`**: Patches hocho for OpenBSD compatibility
  - Uses `sh` instead of `bash`
  - Implements password-based privilege escalation via openssl/askpass (currently unused as `sudo_required: false`)
- **`yaml_dir.rb`**: Custom inventory provider that loads hosts from YAML directory structure

Configuration flow:
1. Hocho reads `hocho.yml` configuration
2. Loads host inventory via `yaml_dir` provider from `data/hosts/*/`
3. Applies property providers to set defaults (`sudo_required: false`, `ssh_options.user: root`)
4. Executes mitamae driver, connecting as root directly (no sudo/doas needed)

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

## Common Issues and Solutions

### Resource Actions and Subscriptions

When using `subscribes` with resources, you must specify the action that the **subscribing resource** should take, not the action of the watched resource.

**Incorrect:**
```ruby
template "/path/to/file" do
  subscribes :run, 'local_ruby_block[trigger]'  # ❌ templates don't have :run action
end
```

**Correct:**
```ruby
template "/path/to/file" do
  subscribes :create, 'local_ruby_block[trigger]'  # ✅ use the template's action
end
```

### SSH Configuration

In host secrets files, use `host_name` (with underscore) for net-ssh compatibility:

**Incorrect:**
```yaml
ssh_options:
  hostname: 192.0.2.1  # ❌ invalid net-ssh option
```

**Correct:**
```yaml
properties:
  addr: 192.0.2.1      # ✅ use addr in properties
ssh_options:
  host_name: 192.0.2.1 # ✅ or use host_name in ssh_options
  port: 22
```

### Running as Root

This configuration connects as root directly (`ssh_options.user: root`) and has `sudo_required: false`. The `mitamae_ext.rb` monkey patch removes all sudo/doas wrapping since it's unnecessary when already running as root.
