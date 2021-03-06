### 
## Create users
#

#user_account 'deployer' do
#  # keys for file ~/.ssh/authorized keys
#  ssh_keys  ['paste your public ssh key here']
#end

# ============================================================================
# = Vinícius =================================================================
# openssl passwd -1 "macaco"
# $1$kcDoiX0e$dgWr6qT3WFEXqt1rFk2Hl1
# ============================================================================
 
#user "vinicius" do
#    comment "Vinícius is a User"
#    home "/home/ana"
#    shell "/bin/bash"
#    supports  :manage_home => true
#    password "$1$kcDoiX0e$dgWr6qT3WFEXqt1rFk2Hl1"
#end

# ============================================================================
# = Ana =====================================================================
# openssl passwd -1 "gato"
# $1$Wwgw0JlI$bKUy.6uhcoT6.CTTU6FOi1
# ============================================================================

#user "ana" do
#    comment "Ana is a User"
#    home "/home/ana"
#    shell "/bin/bash"
#    supports  :manage_home => true
#    password "$1$Wwgw0JlI$bKUy.6uhcoT6.CTTU6FOi1"
#end

# ============================================================================
# = Ivan =====================================================================
# openssl passwd -1 "cachorro"
# $1$PIJ/VG4S$CfsD5hRSbG.rc4/dvW6Lt.
# ============================================================================
 
#user "ivan" do
#    comment "Ivan is a User"
#    home "/home/ivan"
#    shell "/bin/bash"
#    supports :manage_home => true
#    password "$1$PIJ/VG4S$CfsD5hRSbG.rc4/dvW6Lt."
#end

# ============================================================================
# Relacinando usuários com grupos.
# ============================================================================

#group "admin" do
#  members ['ivan', 'ana']
#  action :create
#end

#group "sudo" do
#  members ['ivan', 'ana']
#  action :create
#end

#group "petrobras" do
#  members ['ivan', 'vinicius']
#  action :create
#end

################################# %%%%%%%% ###################################
################################# %%%%%%%% ###################################
################################# %%%%%%%% ###################################

###
## Create files and directory
#

#template "#{ENV['HOME']}/commands.txt" do
#  source 'commands.txt.erb'
#  mode '0664'
#end


# ============================================================================
# Create a user.
# manage_home is set to true so that his home directory will be created.
# ============================================================================

#user "silva" do
#    comment "Silva is a User"
#    home "/home/silva"
#    shell "/bin/bash"
#    supports  :manage_home => true
#end
 
# ============================================================================
# When executing a script, it should create a file specified by 
# "creates" upon completion. This ensures that the command will 
# only run once throughout the life of the system.
# ============================================================================

#execute "a sample command" do
#    command "touch /home/silva/sample.txt"
#    creates "/home/silva/sample.txt"
#end
 
#
# ============================================================================
# Create a directory with specified ownership and permissions.
# ============================================================================

#directory "/home/silva/silva-app" do
#    owner "silva"
#    group "silva"
#    mode 0755
#    #
#    # This weird syntax looks scary, but it's quite harmless. :-)
#    # In Ruby, if you have a string preceeded by a colon, it is 
#    # similar to having a string with single quotes around it.  
#    # There is a slight additional difference, but that is beyond 
#    # the scope of this blog post about Chef.
#    #
#    action :create
#end
 
 
# ============================================================================
# Create a configuration file based on a template.
# This will ONLY run if the date of the template file is newer than the date 
# of the deployed file. Chef is fairly efficient about things like that.  
# It never does more work than is necessary.
# ============================================================================

#template "/home/silva/silva-app/config.json" do
#    source "config.json.erb"
#    variables(
#        :home_dir => "/home/silva/silva-app"
#    )
#    user "silva"
#    group "silva"
#    mode 0600
#end

################################# %%%%%%%% ###################################
################################# %%%%%%%% ###################################
################################# %%%%%%%% ###################################

###
## APT-GET
#

# ============================================================================
# apt-get install toilet
# ============================================================================
#package "toilet" do
#    action :install
#end

# ============================================================================
# apt-get install curl bc
# ============================================================================
#%w(curl bc build-essential libboost1.48-all-dev).each do |pkg|
#  package pkg
#end

# ============================================================================
# apt-get install update
# ============================================================================
#execute "apt-get-update" do
#  command "apt-get update"
#  ignore_failure true
#  action :nothing
#end
#
#package "update-notifier-common" do
#  notifies :run, resources(:execute => "apt-get-update"), :immediately
#end
#
#execute "apt-get-update-periodic" do
#  command "apt-get update"
#  ignore_failure true
#  only_if do
#   File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
#   File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
#  end
#end

################################# %%%%%%%% ###################################
################################# %%%%%%%% ###################################
################################# %%%%%%%% ###################################

###
## NODEJS
#
bash "update-apt-repository" do
  user "root"
  code <<-EOH
  apt-get update
  EOH
end

nodejs_version = "0.10.20"
src_filename = "node-v#{nodejs_version}.tar.gz"
src_filepath = "#{Chef::Config['file_cache_path']}/#{src_filename}"
extract_path = "#{Chef::Config['file_cache_path']}/nodejs}"

bash "install_ruby_build" do
   cwd "#{Chef::Config[:file_cache_path]}/"
   user "rbenv"
   group "rbenv"
   code <<-EOH
     wget http://nodejs.org/dist/v0.10.20/node-v0.10.20.tar.gz
     tar xvzf node-v0.10.20.tar.gz
     EOH
   environment 'PREFIX' => "/usr/local"
end
