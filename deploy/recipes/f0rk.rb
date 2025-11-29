# Deployment recipe for f0rk (f0)

include_recipe "cookbooks/openbsd_server/default.rb"
include_recipe "cookbooks/pf/default.rb"
include_recipe "cookbooks/openbsd_admin/default.rb"
include_recipe "cookbooks/httpd/default.rb"
include_recipe "cookbooks/knot/default.rb"
include_recipe "cookbooks/lego_fqdn/default.rb"
include_recipe "cookbooks/dickd/default.rb"
include_recipe "cookbooks/smtpd/default.rb"
# include_recipe "cookbooks/dovecot/default.rb"
# include_recipe "cookbooks/rspamd/default.rb"
