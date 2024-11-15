#Usee the appropriate base image
FROM ubuntu:latest
 
# Install dependecies
RUN apt-get update && apt install git -y
 
# Set the working directory
WORKDIR /app
 
# Copy the application code
RUN git clone https://github.com/nyrahul/wisecow.git
 
# Update the working directory
WORKDIR /app/wisecow
 
# Copt the application code
RUN git checkout main
 
# Install dependencies
RUN apt-get update
RUN apt-get install fortunes fortune-mod cowsay netcat-openbsd coreutils -y
#RUN echo "export PATH=\"/usr/games:$PATH\"">> ~/.bashrc
RUN chmod +x ./wisecow.sh
 
ENV PATH=$PATH:/usr/games
 
# Command to run the application
CMD ["bash", "./wisecow.sh"]
