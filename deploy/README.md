# Deployment System

Pure mitamae-based deployment orchestration. Mitamae deploying mitamae!

## Quick Start

```bash
# Deploy all hosts (edit deploy/default.rb to uncomment hosts)
mitamae local deploy/default.rb

# Dry run
mitamae local --dry-run deploy/default.rb
```

**Note**: Secrets are decrypted on-the-fly using `sops -d`. No need to run `rake sops:decrypt` first!

## Structure

```
deploy/
├── default.rb           # Main orchestration file - edit to select hosts
├── defines.rb           # host and run_on defines
├── lib/
│   └── helpers.rb       # Helper functions (JSON merging, config loading)
└── recipes/
    ├── airstrip1.rb     # Per-host recipe (include_recipe calls)
    ├── a2mm.rb
    ├── b0rsch.rb
    └── f0rk.rb
```

## How It Works

1. **Define hosts** in `deploy/default.rb`:
   ```ruby
   host "airstrip1" do
     ssh nil  # Loaded from data/hosts/airstrip1/secrets.sops.yml
     attributes(dns_shortname: 'a1')
   end
   ```

2. **Deploy to hosts** with `run_on`:
   ```ruby
   run_on "airstrip1", file: "deploy/recipes/airstrip1.rb"
   ```

3. **Per-host recipes** contain the run list:
   ```ruby
   # deploy/recipes/airstrip1.rb
   include_recipe "cookbooks/openbsd_server/default.rb"
   include_recipe "cookbooks/knot/default.rb"
   # ...
   ```

4. **Execution flow**:
   - Creates temp deployment directory
   - Copies: cookbooks/, plugins/, lib/, mitamae binary
   - Generates node.json (global vars + host attributes)
   - SCPs to remote host `/tmp/mitamae-deploy-<hostname>`
   - SSHs and runs: `mitamae local -j node.json lib/mitamae_ext.rb lib/mitamae_defines.rb recipes/<hostname>.rb`
   - Cleans up local and remote temp directories

## Configuration Sources

- **Global vars**: `data/vars/{default,secrets.sops}.yml`
- **Host config**: `data/hosts/<hostname>/{default,secrets.sops}.yml`
- **SSH connection**: Loaded from `data/hosts/<hostname>/secrets.sops.yml` (ssh_options.host_name, port, user)
- **Attributes**: Merged from global vars → host config → host definition → run_on attributes

## Orchestration Examples

### Deploy in sequence
```ruby
run_on "airstrip1", file: "deploy/recipes/airstrip1.rb"
run_on "b0rsch", file: "deploy/recipes/b0rsch.rb"
run_on "f0rk", file: "deploy/recipes/f0rk.rb"
```

### Collect data and deploy
```ruby
# Collect SSHFP records (future enhancement)
sshfp_records = {}
collect_sshfp "airstrip1", into: sshfp_records
collect_sshfp "b0rsch", into: sshfp_records

# Deploy DNS with collected records
run_on "airstrip1",
  file: "deploy/recipes/airstrip1.rb",
  attributes: { sshfp_records: sshfp_records }
```

### Override SSH target
```ruby
host "airstrip1" do
  ssh "root@192.0.2.1:22"  # Override secrets
  attributes(dns_shortname: 'a1')
end
```

## Migration from Hocho

This replaces:
```bash
hocho apply airstrip1
```

With:
```bash
mitamae local deploy/default.rb  # (with airstrip1 uncommented)
```

The old `hocho.yml`, `lib/hocho_ext.rb`, and hocho dependencies can be removed once migration is complete.
