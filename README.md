# RunnerTests - AnyRobot Runner testing suite

## Setup

### Windows

```
TBA
```

### macOS

```shell
mkdir ~/Code
cd ~/Code && git clone git@gitlab.unitedideas.co:anyrobot/runnertests.git
cd runnertests && bundle install
```

## How to

1. Install `AnyRobot Runner` on your machine and grant rights if needed
2. Add bot to your Portal
3. Add workflows to portal using files from `scripts/` folder (they invoke right script from `tasks/` folder, ie: `scripts/run_live_logging.rb` will invoke `tasks/live_logging.rb`)