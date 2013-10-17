#user_account 'deployer' do
#  # keys for file ~/.ssh/authorized keys
#  ssh_keys  ['paste your public ssh key here']
#end

# openssl passwd -1 "macaco"
# $1$kcDoiX0e$dgWr6qT3WFEXqt1rFk2Hl1
user "vinicius" do
    comment "Vinícius is a User"
    home "/home/ana"
    shell "/bin/bash"
    supports  :manage_home => true
    password "$1$kcDoiX0e$dgWr6qT3WFEXqt1rFk2Hl1"
end

# openssl passwd -1 "gato"
# $1$Wwgw0JlI$bKUy.6uhcoT6.CTTU6FOi1
user "ana" do
    comment "Ana is a User"
    home "/home/ana"
    shell "/bin/bash"
    supports  :manage_home => true
    password "$1$Wwgw0JlI$bKUy.6uhcoT6.CTTU6FOi1"
end

# openssl passwd -1 "cachorro"
# $1$PIJ/VG4S$CfsD5hRSbG.rc4/dvW6Lt.
user "ivan" do
    comment "Ivan is a User"
    home "/home/ivan"
    shell "/bin/bash"
    supports :manage_home => true
    password "$1$PIJ/VG4S$CfsD5hRSbG.rc4/dvW6Lt."
end

group "admin" do
  members ['ivan', 'ana']
  action :create
end

group "sudo" do
  members ['ivan', 'ana']
  action :create
end

group "petrobras" do
  members ['ivan', 'vinicius']
  action :create
end

#####
template "#{ENV['HOME']}/commands.txt" do
  source 'commands.txt.erb'
  mode '0664'
end

#
# Create a user.
# manage_home is set to true so that his home directory will be created.
#
user "silva" do
    comment "Silva is a User"
    home "/home/silva"
    shell "/bin/bash"
    supports  :manage_home => true
end
 
#
# When executing a script, it should create a file specified by 
# "creates" upon completion. This ensures that the command will 
# only run once throughout the life of the system.
#
execute "a sample command" do
    command "touch /home/silva/sample.txt"
    creates "/home/silva/sample.txt"
end
 
#
# Create a directory with specified ownership and permissions.
#
directory "/home/silva/silva-app" do
    owner "silva"
    group "silva"
    mode 0755
    #
    # This weird syntax looks scary, but it's quite harmless. :-)
    # In Ruby, if you have a string preceeded by a colon, it is 
    # similar to having a string with single quotes around it.  
    # There is a slight additional difference, but that is beyond 
    # the scope of this blog post about Chef.
    #
    action :create
end
 
 
#
# Create a configuration file based on a template.
# This will ONLY run if the date of the template file is newer than the date 
# of the deployed file. Chef is fairly efficient about things like that.  
# It never does more work than is necessary.
#
template "/home/silva/silva-app/config.json" do
    source "config.json.erb"
    variables(
        :home_dir => "/home/silva/silva-app"
    )
    user "silva"
    group "silva"
    mode 0600
end
 
#
# Install the "toilet" package. Because every system needs a toilet.
#
package "toilet" do
    action :install
end

