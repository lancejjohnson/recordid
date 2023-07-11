defmodule Recordid.ActivitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Recordid.Activities` context.
  """

  @doc """
  Generate a activity.
  """
  def activity_fixture(attrs \\ %{}) do
    {:ok, activity} =
      attrs
      |> Enum.into(%{

      })
      |> Recordid.Activities.create_activity()

    activity
  end
end
