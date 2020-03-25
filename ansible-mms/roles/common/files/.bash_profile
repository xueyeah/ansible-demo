# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH

export JAVA_HOME=/opt/java
export PATH=/opt/java/bin:$PATH
export INSTALL_DIR=/opt/proxy
export CATALINA_HOME=/opt/proxy/tomcat
# Keep these lines together and at the end of the file
[ -f $HOME/.nxprofile ] && . $HOME/.nxprofile

