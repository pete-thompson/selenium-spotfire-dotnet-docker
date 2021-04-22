# Development

Some reminders on how to develop since I don't tend to touch this project for months/years at a time :)

Command to build:

```
docker build . --tag petethompson1968/selenium-spotfire-dotnet:latest --tag petethompson1968/selenium-spotfire-dotnet:<DOTNETVERSION>
```

Command to push:

```
docker push petethompson1968/selenium-spotfire-dotnet --all-tags
```