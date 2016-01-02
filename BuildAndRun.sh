docker build -t crewshin/perfectly-swift .
docker run -i -t --name perfectly-swift crewshin/perfectly-swift:latest bash
docker run -it -p 80:80 -p 443:443 -p 8181:8181 --name perfectly-swift crewshin/perfectly-swift:latest bash


docker build -t crewshin/perfectly-swift . && docker run -i -t --name perfectly-swift crewshin/perfectly-swift:latest bash
