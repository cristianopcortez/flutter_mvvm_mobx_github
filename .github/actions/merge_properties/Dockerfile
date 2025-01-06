# Use an official Ubuntu as a parent image
FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && apt-get install -y dos2unix

# Copy the main script into the Docker image
COPY main.sh /main.sh

# Convert script line endings to Unix format and make it executable
RUN dos2unix /main.sh && chmod +x /main.sh

# Define the command to run your script
CMD ["/main.sh"]
