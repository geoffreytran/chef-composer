include_attribute "apache"

default[:composer][:user]  = node[:apache][:user]
default[:composer][:group] = node[:apache][:group]