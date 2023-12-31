defmodule Recordid.ActivitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Recordid.Activities` context.
  """

  alias Recordid.Accounts.User
  alias Recordid.AccountsFixtures

  def create_activities(user, attrs \\ %{}, count \\ 1)

  def create_activities(user, attrs, count) do
    attrs = Map.put_new(attrs, :user_id, user.id)

    for _ <- 1..count do
      activity_fixture(attrs)
    end
  end

  @doc """
  Generate a activity.
  """
  def activity_fixture(attrs \\ %{}) do
    {:ok, activity} =
      attrs
      |> Enum.into(%{})
      |> Recordid.Activities.create_activity()

    activity
  end

  def full_activity_finished(:today) do
    full_activity_finished(Date.utc_today())
  end

  def full_activity_finished(:yesterday) do
    Date.utc_today()
    |> Date.add(-1)
    |> full_activity_finished()
  end

  # TODO(lancejjohnson): Not really happy with this
  def full_activity_finished(date) do
    full_activity_finished(date, AccountsFixtures.user_fixture())
  end

  def full_activity_finished(date, user = %User{}) do
    attrs = %{
      user_id: user.id,
      date_started: date,
      date_finished: date,
      time_started: Time.utc_now(),
      time_finished: Time.add(Time.utc_now(), 60 * 20),
      description: "Test description #{Enum.random(0..10_000)}"
    }

    activity_fixture(attrs)
  end
end
