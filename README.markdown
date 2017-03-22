# bitbar-concourse

Presents the status of a [Concourse](https://concourse.ci/release-notes.html) pipeline in [bitbar](https://github.com/matryer/bitbar).

This started out as fork of Checkman's [concourse.check](https://github.com/cppforlife/checkman/blob/master/scripts/concourse.check), but has evolved since.

change

# Usage

* Install bitbar (`brew install bitbar`)
* Install this gem
* Add a script like the following to `~/.bitbar/` and make it executable:

  ```
  #!/bin/bash

  # Change this URL to point to your own Concourse instance
  # but the public one should be ok as a demo
  export CONCOURSE_URI=http://concourse.ci/

  # username and password are optional
  export CONCOURSE_USER=user
  export CONCOURSE_PASSWORD=password

  # invoke the plugin
  bitbar-concourse
  ```

* Check the bitbar icon in the system tray for updated status

  Example:

  ![Flintstone CI](public/flintstone.png)

# Installation

    $ gem install bitbar-concourse

# Development

* Use `fswatch` to run specs whenever code or tests change. Install it with `brew install fswatch` if not available.

  ```
  $ fswatch --one-per-batch spec lib | xargs -n1 -I{} rspec
  ```

* Since the bitbar protocol is text-based, the bitbar-concourse gem can be tested in the terminal. Just execute the script in `~/.bitbar/` in a terminal window.

# Misc

The propeller logo is in the [public domain](https://thenounproject.com/search/?q=propeller&i=13111).

# TODO
* Order latest builds in presenter, by status and then by last-run date
* Use TerminalNotifier when a build is failing:

        TerminalNotifier.notify('Hello World', :open => 'http://twitter.com/alloy')

  We'd have to keep state and notify only on a change (red => green etc.).
