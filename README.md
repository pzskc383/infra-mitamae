# Mitamae OpenBSD Infrastructure

Event-driven infrastructure management for OpenBSD servers, migrated from Ansible to mitamae (mruby-based mini-Chef).

## Overview

This project manages three OpenBSD VPS instances serving DNS, mail, and web services for the pzskc383.net and pzskc383.dp.ua domains.

### Architecture

- **airstrip1**: Primary server (DNS, mail, certificates, web)
- **b0rsch**: Secondary server (DNS, mail relay, web)
- **f0rk**: Minimal secondary (DNS only)

### Services Managed

- **DNS**: Knot resolver with DNSSEC and zone transfers
- **Mail**: OpenSMTPD + Dovecot + Rspamd
- **Certificates**: Let's Encrypt via lego with RFC2136 DNS challenge
- **Web**: OpenBSD httpd with CGit repository browser
- **Firewall**: PF rules with dynamic service detection
- **SSH**: Hardened SSH with dickd protection

## Key Features

### Event-Driven Architecture

Replaces Ansible's complex multi-phase orchestration with a simple event-driven system:

- Services emit configuration events
- Cross-host coordination via shared manifests
- Dynamic firewall rule generation
- Automated DNS zone and certificate management

### Bug Fixes Included

This migration includes fixes for the known Ansible issues:

- ✅ **Lego TLS certs loop**: Fixed to support multiple wildcard certificates
- ✅ **changed_when syntax**: Corrected quote handling
- ✅ **Service fact publishing**: Replaced with manifest-based coordination

## Quick Start

### Prerequisites

```bash
# Install mitamae
gem install mitamae

# Or use bundler
bundle install

# Install SOPS for secrets management
pkg install sops

# Install required gems
bundle install
```

### Configuration

1. **Decrypt secrets**:
   ```bash
   rake secrets:decrypt
   ```

2. **Edit inventory**: Modify `inventory/hosts.yaml` with your host configurations

3. **Test connectivity**:
   ```bash
   rake test:connectivity
   ```

4. **Deploy to specific host**:
   ```bash
   rake deploy:host[airstrip1]
   ```

5. **Dry run**:
   ```bash
   rake deploy:dry_run[airstrip1]
   ```

6. **Deploy to all hosts**:
   ```bash
   rake deploy:all
   ```

## Project Structure

```
mitamae-obsd/
├── recipes/                   # Main recipes
│   ├── base.rb               # Base system setup
│   ├── orchestrator.rb       # Event-driven coordinator
│   ├── services/             # Service-specific recipes
│   │   ├── mail.rb          # Mail stack (smtpd + dovecot + rspamd)
│   │   ├── dns.rb           # DNS service (knot)
│   │   ├── certificate.rb   # Certificate management (lego)
│   │   ├── httpd.rb         # Web server
│   │   ├── cgit.rb          # Git web interface
│   │   ├── firewall.rb      # PF firewall
│   │   └── dickd.rb         # SSH hardening
│   └── coordination/         # Cross-host coordination
│       ├── dns_zones.rb     # DNS zone generation
│       └── certificate_sync.rb # Certificate distribution
├── lib/                      # Core libraries
│   ├── event_bus.rb         # Event-driven coordination
│   └── service_manifest.rb  # Service manifest management
├── templates/               # ERB templates (converted from Jinja2)
│   ├── lego/               # Certificate templates
│   ├── knot/               # DNS templates
│   ├── mail/               # Mail templates
│   └── httpd/              # Web templates
├── files/                  # Static configuration files
├── inventory/              # Host configurations
│   └── hosts.yaml         # All host definitions
├── Rakefile              # Deployment automation
└── Gemfile               # Ruby dependencies
```

## Migration from Ansible

### What Changed

| Ansible Concept | Mitamae Equivalent | Implementation |
|----------------|-------------------|----------------|
| Multi-phase playbook | Single event-driven recipe | `orchestrator.rb` dispatches events |
| `set_fact` variables | JSON manifest files | `lib/service_manifest.rb` |
| `include_role` | `require` Ruby files | `recipes/services/*.rb` |
| `delegate_to localhost` | File-based coordination | Shared `/tmp/mitamae-manifests/` |
| Hostvars aggregation | Primary reads manifests | `coordination/*.rb` |
| Jinja2 templates | ERB templates | Same syntax, `.erb` extension |

### Key Benefits

1. **Simpler Architecture**: No complex phase orchestration
2. **Better Error Handling**: Ruby exceptions vs Ansible failed_when
3. **Extensible**: Easy to add new services
4. **Debuggable**: Event log shows execution flow
5. **Testable**: Can test individual service recipes

## Configuration Reference

### Host Configuration

Each host in `inventory/hosts.yaml` defines:

```yaml
hostname: airstrip1
dns_role: primary          # or secondary
mail_role: primary         # or secondary
dns_shortname: a1          # short hostname for DNS records
enabled_roles:
  - dickd
  - dns
  - mail
  - certificate
  - httpd
  - cgit
  - firewall
mail_domains:
  - pzskc383.net
  - pzskc383.dp.ua
tls_certs:
  - name: main_net
    domains: [pzskc383.net, "*.pzskc383.net"]
    cert_path: /etc/ssl/pzskc383.net.crt
    key_path: /etc/ssl/pzskc383.net.key
```

### Environment Variables

Recipes use environment variables for configuration:

- `DNS_ROLE`: primary or secondary
- `MAIL_ROLE`: primary or secondary
- `DNS_SHORTNAME`: short hostname for DNS records
- `MAIL_DOMAINS`: comma-separated list of mail domains
- `TLS_CERTS_CONFIG`: YAML array of certificate configurations
- `TSIG_SECRET`: DNS TSIG key for lego
- `LEGO_EMAIL`: Email for Let's Encrypt registration

### Secrets Management

Uses SOPS with age encryption:

```bash
# Decrypt secrets before deployment
rake secrets:decrypt

# Deploy
rake deploy:host[airstrip1]

# Clean up decrypted files
rake secrets:clean
```

## Testing

### Connectivity Testing
```bash
rake test:connectivity
```

### Service Testing
```bash
rake test:service[airstrip1,mail]
rake test:service[airstrip1,dns]
```

### Dry Runs
```bash
rake deploy:dry_run[airstrip1]
```

## Troubleshooting

### Event Log
Check the event log for execution flow:
```bash
grep "\[EventBus\]" /var/log/mitamae.log
```

### Service Manifests
View generated service manifests:
```bash
ls -la /tmp/mitamae-manifests/
cat /tmp/mitamae-manifests/airstrip1.json
```

### Manual Service Testing
Test individual services:
```bash
mitamae ssh --host airstrip1 recipes/services/mail.rb --dry-run
```

## Development

### Adding New Services

1. Create `recipes/services/new_service.rb`:
   ```ruby
   class NewService
     def initialize(event_bus, manifest)
       @event_bus = event_bus
       @manifest = manifest
     end

     def configure
       # Service configuration
       emit_service_configured
     end

     private

     def emit_service_configured
       @event_bus.emit(:service_configured, {
         service_name: 'new_service',
         data: { configured: true }
       })
     end
   end
   ```

2. Add service to host's `enabled_roles` list

3. Service will be automatically discovered and configured

### Extending Event System

Add new events in the orchestrator:
```ruby
@event_bus.on(:custom_event) do |event|
  log "Custom event: #{event[:data]}"
end

# Emit event:
@event_bus.emit(:custom_event, { data: 'value' })
```

## Migration Benefits

1. **Fixed Known Bugs**: Lego role now properly handles multiple certificates
2. **Simplified Architecture**: Event-driven vs complex multi-phase orchestration
3. **Better Maintainability**: Ruby code is easier to extend than YAML Ansible
4. **Improved Testing**: Can test individual services independently
5. **Enhanced Debugging**: Event log provides clear execution flow

## Next Steps

1. **Test individual services** on a development host
2. **Validate certificate generation** with lego
3. **Test DNS zone generation** and synchronization
4. **Verify mail stack functionality**
5. **Gradual rollout** starting with secondary hosts
6. **Monitor and refine** based on production usage

## License

Same as original Ansible project.
