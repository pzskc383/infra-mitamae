# frozen_string_literal: true

# cron 'echo hi'

openbsd_package 'vim' do
  action :install
  flavor 'no_x11'
end
