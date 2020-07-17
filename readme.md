# Selenium.Spotfire

This docker image is intended to support use of the [Selenium.Spotfire for DotNet framework](https://github.com/pete-thompson/selenium-spotfire-dotnet).
The image contains everything needed to build and run DotNet applications that automate Spotfire
through Selenium's ChromeDriver and Chrome itself.

# Running without a user interface

The container image includes the Xvfb tool, which allows us to run Chrome in it's normal mode without
a visible user interface. To make use of this, execute these commands to start Xvfb prior to running your Spotfire automation.

```
export DISPLAY=:20
Xvfb :20 -screen 0 1920x1080x16 &
```

# Viewing Chrome's user interface

If you wish to view the Chrome user interface while executing your Spotfire automation, you'll need a suitable X Windows server.
If you're running Docker under Linux you should be able to use your host X Windows server by sharing the display - various instructions can be found on the Internet.
For Windows users, make use of a tool such as [Xming](https://sourceforge.net/projects/xming/) and execute the ```export DISPLAY=host.docker.internal:0.0``` command within the Docker container prior to 
running your Spotfire automation.

# Automated builds (CI/CD)

Most automated build platforms can execute within Docker containers. This container provides the tooling to both
build and test DotNet based applications. Generally, the CI/CD tool will automatically download all 
appropriate source code and set the current folder to the root of the source. This means that a simple 
```dotnet build``` command will build the project and a ```dotnet test``` command will test.
Often, additional steps are required for testing (e.g. starting Xvfb), plus maybe settings files are required for the test contexts.

## Gitlab
The  following example shows a build file for a GitLab project, which has a build stage followed by a test phase, which includes an 'artifact' to upload the test results:

```
image: petethompson1968/selenium-spotfire-dotnet:2.1

stages:
  - build
  - test

build:
  stage: build
  script:
    - |
      export DISPLAY=:20
      Xvfb :20 -screen 0 1920x1080x16 &
      dotnet test "--settings:$runSettings" --results-directory ./test-results

test:
  stage: test
  allow_failure: true
  script:
    - dotnet test "--settings:$runSettings" --results-directory ./test-results
  artifacts:
    when: always
    paths: 
    - test-results
```