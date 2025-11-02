# frozen_string_literal: true

openbsd_package 'vim' do
  action :install
  flavor 'no_x11'
end
