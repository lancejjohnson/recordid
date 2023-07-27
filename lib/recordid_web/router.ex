defmodule RecordidWeb.Router do
  use RecordidWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RecordidWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RecordidWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/activities", ActivityLive.Index, :index
    live "/activities/new", ActivityLive.Index, :new
    live "/activities/:id/edit", ActivityLive.Index, :edit

    live "/activities/:id", ActivityLive.Show, :show
    live "/activities/:id/show/edit", ActivityLive.Show, :edit

    live "/today", TodayLive

    live "/days/:date", DayActivityLive, :index
    live "/days/:date/activities/new", DayActivityLive, :new
    live "/days/:date/activities/:id/edit", DayActivityLive, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", RecordidWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:recordid, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RecordidWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
