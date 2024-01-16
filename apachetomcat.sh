#para actualizar el sistema
sudo apt update
#esto creara el usaurio donde guardaremos tomcat
sudo useradd -m -d /opt/tomcat -U -s /bin/false tomcat
#Instalacion de java
sudo apt install default-jdk
#apertura de la carpeta donde tenemos el tomcat
cd /tmp
#descargar el comprimido de tomcat
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.18/bin/apache-tomcat-10.1.18.tar.gz
#descomprimir tomcat
sudo tar xzvf apache-tomcat-10*tar.gz -C /opt/tomcat --strip-components=1
#permisos
sudo chown -R tomcat:tomcat /opt/tomcat/
sudo chmod -R u+x /opt/tomcat/bin
#modificacion de tomcat-users.xml
sudo bash -c 'cat <<EOL >> /opt/tomcat/conf/tomcat-users.xml

    <role rolename="manager-gui" />
    <user username="manager" password="manager_password" roles="manager-gui" />

    <role rolename="admin-gui" />
    <user username="admin" password="admin_password" roles="manager-gui,admin-gui" />
EOL'

#modificacion del archivo context.xml de manager
sudo bash -c 'echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > /opt/tomcat/webapps/manager/META-INF/context.xml'
sudo bash -c 'echo "<Context antiResourceLocking=\"false\" privileged=\"true\" >" >> /opt/tomcat/webapps/manager/META-INF/context.xml'
sudo bash -c 'echo "  <CookieProcessor className=\"org.apache.tomcat.util.http.Rfc6265CookieProcessor\"" >> /opt/tomcat/webapps/manager/META-INF/context.xml'
sudo bash -c 'echo "                   sameSiteCookies=\"strict\" />" >> /opt/tomcat/webapps/manager/META-INF/context.xml'
sudo bash -c 'echo "<!--  <Valve className=\"org.apache.catalina.valves.RemoteAddrValve\"" >> /opt/tomcat/webapps/manager/META-INF/context.xml'
sudo bash -c 'echo "         allow=\"127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1\" /> -->" >> /opt/tomcat/webapps/manager/META-INF/context.xml'
sudo bash -c 'echo "  <Manager sessionAttributeValueClassNameFilter=\"java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$HttpsOnly|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$HttpsPortFilter\"/>" >> /opt/tomcat/webapps/manager/META-INF/context.xml'
sudo bash -c 'echo "</Context>" >> /opt/tomcat/webapps/manager/META-INF/context.xml'

#modificacion del archivo context.xml de host manager
sudo bash -c 'echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > /opt/tomcat/webapps/host-manager/META-INF/context.xml'
sudo bash -c 'echo "<Context antiResourceLocking=\"false\" privileged=\"true\" >" >> /opt/tomcat/webapps/host-manager/META-INF/context.xml'
sudo bash -c 'echo "  <CookieProcessor className=\"org.apache.tomcat.util.http.Rfc6265CookieProcessor\"" >> /opt/tomcat/webapps/host-manager/META-INF/context.xml'
sudo bash -c 'echo "                   sameSiteCookies=\"strict\" />" >> /opt/tomcat/webapps/host-manager/META-INF/context.xml'
sudo bash -c 'echo "<!--  <Valve className=\"org.apache.catalina.valves.RemoteAddrValve\"" >> /opt/tomcat/webapps/host-manager/META-INF/context.xml'
sudo bash -c 'echo "         allow=\"127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1\" /> -->" >> /opt/tomcat/webapps/host-manager/META-INF/context.xml'
sudo bash -c 'echo "  <Manager sessionAttributeValueClassNameFilter=\"java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$HttpsOnly|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$HttpsPortFilter\"/>" >> /opt/tomcat/webapps/host-manager/META-INF/context.xml'
sudo bash -c 'echo "</Context>" >> /opt/tomcat/webapps/host-manager/META-INF/context.xml'

#creacion y escrito del archivo tomcat.service
sudo bash -c 'cat <<EOL > /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOL'

sudo systemctl daemon-reload

sudo systemctl start tomcat

sudo systemctl enable tomcat

sudo ufw allow 8080