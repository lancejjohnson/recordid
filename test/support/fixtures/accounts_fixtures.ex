defmodule Recordid.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Recordid.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Recordid.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end

  def random_valid_time_zone(opts \\ []) do
    time_zone = Tzdata.canonical_zone_list() |> Enum.random()

    if time_zone in Keyword.get(opts, :exclude, []),
      do: random_valid_time_zone(opts),
      else: time_zone
  end
end
