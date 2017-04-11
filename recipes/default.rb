#
# Cookbook Name:: nsenter
# Recipe:: default
#
# Copyright 2017, Scalingo
#
# BSD License
#

version     = node['nsenter']['version']
destination = node['nsenter']['destination']

package 'build-essential'

package_name       = "util-linux-#{version}"
package_build_path = File.join(Chef::Config[:file_cache_path], package_name)
package_url        = "https://www.kernel.org/pub/linux/utils/util-linux/v#{version}/#{package_name}.tar.xz"

tar_extract package_url do
  prefix Chef::Config[:file_cache_path]
  creates package_build_path
end

execute "compile & install #{package_name}" do
  command "./configure --without-ncurses && make LDFLAGS=-all-static nsenter && cp nsenter #{destination}"
  cwd package_build_path
  creates File.join(destination, "nsenter")
end
