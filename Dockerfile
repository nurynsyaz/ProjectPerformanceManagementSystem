# First stage: Build the WAR file
FROM maven:3.8-openjdk-17 AS build

# Set the working directory for the build process
WORKDIR /app

# Copy all necessary files (including pom.xml, source code, etc.)
COPY . .

# Verify that Maven is installed and check version
RUN mvn -v

# Run Maven to clean, package, and skip tests (use `clean package` to build the WAR file)
RUN mvn clean package -DskipTests

# Second stage: Deploy WAR to Tomcat
FROM tomcat:9.0-jdk17

# Clean default webapps folder to remove any pre-existing applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file from the build stage to Tomcat's webapps folder as ROOT.war
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080 for Tomcat web server
EXPOSE 8080

# Start Tomcat server in foreground mode
CMD ["catalina.sh", "run"]
