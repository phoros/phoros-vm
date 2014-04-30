#/bin/bash

echo Starting phoros servlet


GIT=`which git`
GRADLE=`which gradle`

# What we need:
# 1. phoros archive.
# 2. citemgr
# 3. citeservlet

# Phoros archive:
if [ -d "/vagrant/phoros" ]; then
    echo "Checking archive for updates"
    # Control will enter here if $DIRECTORY exists.
    cd /vagrant/phoros
    $GIT pull
else
    echo "Installing phoros archive"
    cd /vagrant
    echo  Running  $GIT clone https://github.com/phoros/phoros.git
    $GIT clone https://github.com/phoros/phoros.git
fi


# citemgr
if [ -d "/vagrant/citemgr" ]; then
    echo "Checking CITE archive manager for updates."
    cd /vagrant/citemgr
    $GIT pull
else
    echo "Installing CITE archive manager."
    cd /vagrant
    echo  Running  $GIT clone https://github.com/cite-architecture/citemgr.git
    $GIT clone https://github.com/cite-architecture/citemgr.git
fi



# citeservlet
if [ -d "/vagrant/citeservlet" ]; then
    echo "Checking CITE servlet for updates."
    cd /vagrant/citeservlet
    $GIT pull
else
    echo "Installing CITE servlet."
    cd /vagrant
    echo  Running  $GIT clone https://github.com/cite-architecture/citeservlet.git
    $GIT clone https://github.com/cite-architecture/citeservlet.git
fi

# With everything up to date, then:
# 1. build TTL
cd /vagrant/citemgr
echo Building project RDF graph.
echo This can take a couple of minutes.
echo ""
$GRADLE clean && $GRADLE -Pconf=/vagrant/sparql/citemgr-conf.gradle ttl
/bin/cp /vagrant/citemgr/build/ttl/all.ttl /vagrant/sparql

# 2. load TTL into fuseki
echo "Loading new data into RDF server."
if [ -d /vagrant/sparql/tdbs ]; then
    /bin/rm -rf /vagrant/sparql/tdbs
fi
/bin/mkdir /vagrant/sparql/tdbs
/vagrant/jena/bin/tdbloader2 -loc /vagrant/sparql/tdbs /vagrant/sparql/all.ttl

# 3. start servlet
cd /vagrant/citeservlet
echo Starting servlet.
$GRADLE clean && $GRADLE   -Pconf=/vagrant/phoros/confs/localconf.gradle   -Plinks=/vagrant/phoros/confs/locallinks.gradle   -Pcustom=/vagrant/phoros/servlet/ jettyRunWar
