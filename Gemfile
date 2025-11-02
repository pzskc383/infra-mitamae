# frozen_string_literal: true

ruby '~> 3.4'

source 'https://rubygems.org'

gem 'hocho', path: 'vendor/gems/hocho'

gem 'bcrypt_pbkdf'
gem 'ed25519'
gem 'x25519'

gem 'rake'

# gem 'sorbet', group: :development
# gem 'sorbet-runtime'
# gem 'sorbet-struct-comparable', group: :development
# gem 'spoom'
# gem 'tapioca', require: false, group: %i[development test]

group :development do
  gem 'rubocop', '~> 1.81'
  gem 'rubocop-rake', '~> 0.7.1', require: false
end

# group :test do
#   source "https://rubygems.cinc.sh" do
#     gem "cinc-auditor-bin"
#   end
#   gem 'kitchen-inspec'
#   gem 'kitchen-vagrant', '~> 1.13'
#   gem 'mixlib-install', git: 'https://gitlab.com/cinc-project/mixlib-install.git', branch: 'stable/cinc'
#   gem 'test-kitchen'
#   gem "vagrant", git: "https://github.com/hashicorp/vagrant.git", tag: "v2.4.9"
#   gem "vagrant-libvirt", "~> 0.12"
# end
