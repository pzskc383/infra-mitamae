# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a work-in-progress mitamae configuration for managing OpenBSD servers. Mitamae is an mruby-based configuration management tool (mini-Chef) that manages three OpenBSD VPS instances for DNS, mail, and web services.

**Key servers:**
- **airstrip1** (a1): Primary server (DNS, mail, certificates, web)
- **b0rsch** (b0): Secondary server (DNS, mail relay, web)
- **f0rk** (f0): Minimal secondary (DNS only)

## Common Commands

### Secrets Management
```bash
# Decrypt secrets before working
rake secrets:decrypt

# Re-encrypt secrets after editing
rake secrets:encrypt
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
├── site.rb                        # Entry point, loads hack/mitamae_fix.rb
├── hocho.yml                      # Hocho configuration
├── hosts/                         # Per-host YAML configs
│   ├── a1.yml                     # airstrip1 config
│   ├── b0.yml                     # b0rsch config
│   ├── f0.yml                     # f0rk config
│   └── vars/default.yml           # Global variables
├── cookbooks/                     # Mitamae recipes
│   └── openbsd_server/default.rb  # Main server recipe
├── plugins/                       # Custom mitamae plugins
│   └── mitamae-plugin-resource-openbsd_package/
│       └── mrblib/                # Plugin implementation
├── hack/                          # Monkey patches and vendored code
│   ├── mitamae_fix.rb             # Patches mitamae core classes
│   └── gems/hocho/                # Vendored hocho gem
└── misc/                          # Reference materials
    └── mitamae/mrblib/mitamae/    # Mitamae source code for reference
```

### Hocho Integration

**Hocho** is a mitamae wrapper for multi-host orchestration. Vendored at `hack/gems/hocho/`.

Key files:
- `hocho.yml`: Defines inventory providers, property providers, and driver options
- `hosts/*.yml`: Host-specific configurations with attributes and run_list
- `hosts/vars/default.yml`: Global variables injected via `property_providers.ruby_script`

Configuration flow:
1. Hocho reads `hocho.yml` configuration
2. Loads host inventory from `hosts/` directory (file inventory provider)
3. Applies property providers (`add_default` and `ruby_script`)
4. Executes mitamae driver with specified options

### Custom OpenBSD Package Plugin

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
- Mitamae source: `misc/mitamae/mrblib/mitamae/`
- Hocho source: `hack/gems/hocho/lib/hocho/`
- Example repository: `misc/sorah-cnw/itamae/`
