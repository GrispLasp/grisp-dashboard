# grisp-dashboard
Dashboard client and webserver for GRiSP boards.

## Installation

### Webserver

The dashboard webserver runs on Elixir. Install instructions can be found here: https://elixir-lang.org/install.html

After installing Elixir, go in the root directory and run the following command: `mix deps.get`

### Client

The client part of the dashboard uses ReactJS for the frontend framework.

To run the client, you will need to install NodeJS (https://nodejs.org/en/) and npm. **Not*e*: npm is installed by default with NodeJS.

Next, go the `client/`directory and run `npm install`.

## Usage

To start the dashboard, follow the instructions below.

### Webserver

Start the webserver as an Erlang distributed node, by running `iex --sname my_node_name --cookie MyCookie -S mix`.

### Client

To run the client, go to `client/`and do the following command: `npm run web`.

You can now access the dashboard at `http://localhost:8080`.

## Default configuration

The client runs on port **8080**.
The webserver runs on port **8081**.

## Development 

The client comes with hot-loader. A change to any of the files (html/css/js) in `client/` will trigger a live-reload of the webpage you are working on.


