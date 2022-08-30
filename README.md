# RunnerTests - AnyRobot Runner testing suite

## Setup

### Windows

Prepare Windows machine [according to the wiki](https://unitedideas.atlassian.net/wiki/spaces/ANY/pages/1767079989/New+Bot+-+Windows), then:

```
windows> md Code # In your home directory
windows> cd Code
windows> git clone git@gitlab.unitedideas.co:anyrobot/runnertests.git
windows> cd runnertests
windows> bundle install
```

### macOS

Prepare macOS machine [according to the wiki](https://unitedideas.atlassian.net/wiki/spaces/ANY/pages/1765507155/New+Bot+-+macOS), then:


```shell
macos> mkdir ~/Code
macos> cd ~/Code
macos> git clone git@gitlab.unitedideas.co:anyrobot/runnertests.git
macos> cd runnertests && bundle install
```

## How to test?

1. Install `AnyRobot Runner` on your machine and grant rights if needed
2. Add bot to your Portal
3. Add workflows to portal using files from `scripts/` folder (they invoke right script from `tasks/` folder, ie: `scripts/run_live_logging.rb` will invoke `tasks/live_logging.rb`)
