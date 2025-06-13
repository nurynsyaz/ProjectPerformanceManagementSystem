FROM tomcat:9.0-jdk17

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR and rename to ROOT.war
COPY ProjectPerformanceSystemVer1.war /usr/local/tomcat/webapps/ROOT.war

# Railway expects this environment variable
ENV PORT=8080

EXPOSE 8080

CMD ["catalina.sh", "run"]
