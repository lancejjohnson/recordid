# Recordid

## Activities

Recordid allows you to record what you did during your day by accepting a
formatted description of you activity.

### Formatting rules

Times are represented using the 24-hour clock and all times require 4 digits
without intervening characters.

Dates are represented as YYYY-MM-DD

Description: Any characters not prefixed or postfixed by special characters.
Start time: 4 digits followed by a dash.
Finish time: 4 digits preceded by a dash.
Start date: ^YYYY-MM-DD
End date: $YYYY-MM-DD
Tags: preceded by #
Companions: preceded by @
Locations: preceded by +


## Development

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

