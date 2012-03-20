#
# Cookbook Name:: autoconf
# Recipe:: default
#
# Copyright 2010, atmos.org
#

SMEAGOL_ROOT_DIR = ENV['SMEAGOL_ROOT_DIR'] || "#{ENV['HOME']}/Developer"

script "installing autoconf" do
  interpreter "bash"
  code <<-EOS
    source #{SMEAGOL_ROOT_DIR}/cinderella.profile
    if [ ! -f #{SMEAGOL_ROOT_DIR}/bin/autoconf ]; then
      brew install autoconf
    fi
  EOS
end
