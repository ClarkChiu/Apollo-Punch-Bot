# Punch Clock Tool for Apollo HR System

## Features (by ChatGPT :))

- Daily Check-In/Out: The tool can automatically clock in and out for daily attendance records.

- Missed Attendance Correction: Users can use the tool to make up for missed clock-ins or clock-outs by recording attendance retroactively (or for the future 🤨).

- Automatic Holiday Detection: The tool can detect national holidays and skip over them.

- Customizable Holiday List: The tool's default list of national holidays can be customized by users to add or remove holidays. Example: [2023 Holiday Configuration](./config/holidays/2023.txt)

## Prerequisite

- Docker (or you can try `podman`, of course)

## Containerized

Use `ppodgorsek/docker-robot-framework` directly

- [GitHub](https://github.com/ppodgorsek/docker-robot-framework)
- [DockerHub](https://hub.docker.com/r/ppodgorsek/robot-framework)

## Config

- [Example config file](./config/user.config.example)

```shell
# Clone the project
git clone https://github.com/ClarkChiu/Apollo-Punch-Bot.git

# Move to project root
cd Apollo-Punch-Bot

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

## Parameters description (by ChatGPT, too :))

- `sudo`: runs the docker command with superuser privileges.
- `docker run`: starts a new container and runs a command inside it.
- `--rm`: removes the container when it exits.
- `-e "TZ=Asia/Taipei"`: sets the TZ environment variable to Asia/Taipei. This is used to set the time zone for the container to Taipei time.
- `-v /home/clark/apollo-punch-bot/:/apollo-punch-bot`: mounts the local directory /home/clark/apollo-punch-bot/ as a volume inside the container at the path /apollo-punch-bot. This is used to share files between the host and the container.
- `-w /apollo-punch-bot`: sets the working directory inside the container to /apollo-punch-bot. This is where the command will be executed.
- `ppodgorsek/robot-framework:latest`: specifies the image to use for the container, in this case ppodgorsek/robot-framework with the latest tag.

- `bash -c "robot --argumentfile config/user.config --outputdir result/date +"%Y%m%d-%H%M" src/correct-punch-clock.robot"`: runs a Bash command inside the container, which in turn runs the Robot Framework command to execute the test suite.

Here are the explanations of the parameters used in the Robot Framework command:

- `robot`: the command to run the Robot Framework.
- `--argumentfile config/user.config`: specifies the argument file to use for the test suite. This is a file containing variable definitions and command line options that can be passed to the test suite.
- `--outputdir result/date +"%Y%m%d-%H%M"`: specifies the directory to save the test results. The directory name is based on the current date and time.
- `src/correct-punch-clock.robot`: specifies the path to the test suite file to execute. This is a Robot Framework test case file containing the test cases to run.

[^1]: If the working time is greater than 8.5 hours, the new selection box will pop out to ask what causes the check out to be delayed.
