FROM ubuntu

LABEL name="Docker build demo Robot Framework" maintainer="Bela jar"

ENV TZ=Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#update the image
RUN apt-get update 

#install python
RUN apt install -y python3.8
RUN apt install -y python3-pip

#install robotframework and seleniumlibrary
RUN pip3 install robotframework
RUN pip3 install robotframework-seleniumlibrary
RUN pip3 install robotframework-selenium2library
RUN pip3 install robotframework-datadriver

# install chrome and chromedriver in one run command to clear build caches for new versions (both version need to match)
RUN apt-get install -y xvfb 
RUN apt-get install -y zip 
RUN apt-get install -y wget 
RUN apt-get install ca-certificates 
RUN apt-get install -y libnss3-dev libasound2 libxss1 libappindicator3-1 libindicator7 gconf-service libgconf-2-4 libpango1.0-0 xdg-utils fonts-liberation

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb 
RUN dpkg -i google-chrome*.deb; apt-get install -y -f
RUN rm google-chrome*.deb
RUN wget -N http://chromedriver.storage.googleapis.com/93.0.4577.63/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN chmod +x chromedriver
RUN cp /chromedriver /usr/local/bin
RUN rm chromedriver_linux64.zip

RUN pip3 install robotframework-datadriver[XLS]

CMD ["/Scripts/run_suite.sh"]