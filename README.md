# Punch Clock Tool for Apollo HR System

## Containerized

Use `ppodgorsek/docker-robot-framework` directly

- [GitHub](https://github.com/ppodgorsek/docker-robot-framework)
- [DockerHub](https://hub.docker.com/r/ppodgorsek/robot-framework)

## Prerequisite

- Docker (or you can try `podman`, of course)

## Config

- [Example config file](./config/user.config.example)

```shell
# Clone the project
git clone https://github.com/ClarkChiu/Apollo-Punch-Bot.git

# Copy the example config file
cp config/user.config.example config/user.config

# Update your user config in user.config file
vim config/user.config
```

## Note

- Update your project path for volume mounting
- Update the `--outputdir` argument for output the result to other path you want, for example: `--outputdir /apollo-punch-bot/result/$(date +"%Y%m%d-%H%M")`

## Setup cronjob for working day

- Make sure your timezone is correct
- Add cronjob (Using Perl for random sleep) [^1] for root user (sudo crontab -e)
- Escaping characters is used in below crontab example for getting the date

```shell
# Punch Check In
45 08 * * 1-5 perl -e 'sleep(rand(900))'; sudo docker run --rm -e "TZ=Asia/Taipei" -v /home/clark/apollo-punch-bot/:/apollo-punch-bot -w /apollo-punch-bot ppodgorsek/robot-framework:latest bash -c "robot --argumentfile config/user.config --variable CHECK_ACTION:IN --outputdir result/`date +"\%Y\%m\%d-\%H\%M"` src/punch-clock.robot"

# Punch Check Out
00 18 * * 1-5 perl -e 'sleep(rand(900))'; sudo docker run --rm -e "TZ=Asia/Taipei" -v /home/clark/apollo-punch-bot/:/apollo-punch-bot -w /apollo-punch-bot ppodgorsek/robot-framework:latest bash -c "robot --argumentfile config/user.config --variable CHECK_ACTION:OUT --outputdir result/`date +"\%Y\%m\%d-\%H\%M"` src/punch-clock.robot"
```

## Usage Example for correct punch clock

- Change the date range in user.config

```shell
sudo docker run --rm -e "TZ=Asia/Taipei" -v /home/clark/apollo-punch-bot/:/apollo-punch-bot -w /apollo-punch-bot ppodgorsek/robot-framework:latest bash -c "robot --argumentfile config/user.config --outputdir result/`date +"%Y%m%d-%H%M"` src/correct-punch-clock.robot"
```

## Run some tests

```shell
sudo docker run --rm  -e "TZ=Asia/Taipei" -v /home/clark/apollo-punch-bot/:/apollo-punch-bot -w /apollo-punch-bot ppodgorsek/robot-framework:latest bash -c "robot --argumentfile config/user.config --outputdir result/`date +"%Y%m%d-%H%M"` test"
```

[^1]: If the working time is greater than 8.5 hours, the new selection box will pop out to ask what causes the check out to be delayed.
