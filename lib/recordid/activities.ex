defmodule Recordid.Activities do
  @moduledoc """
  The Activities context.
  """

  import Ecto.Query, warn: false
  alias Recordid.Repo

  alias Recordid.Accounts.User
  alias Recordid.Activities.Activity

  @doc """
  Returns the list of activities.

  ## Examples

      iex> list_activities()
      [%Activity{}, ...]

  """
  def list_activities(user = %User{}) do
    Activity
    |> for_user(user)
    |> Repo.all()
  end

  def list_days_with_activities(user = %User{}) do
    query =
      from(a in Activity,
        where: not is_nil(a.date_started) and a.user_id == ^user.id,
        select: %{date: a.date_started, activity_count: count(a.id)},
        group_by: [a.date_started],
        order_by: [desc: a.date_started]
      )

    Repo.all(query)
  end

  @doc """
  Returns a list of activities for a given date sorted by start time descending.
  """
  def list_activities_for_date(user, date) do
    Activity
    |> for_user(user)
    |> started_on(date)
    |> most_recent_first()
    |> Repo.all()
  end

  defp for_user(query, %User{id: user_id} = _user) do
    from a in query, where: a.user_id == ^user_id
  end

  defp started_on(query, date) do
    from a in query, where: a.date_started == ^date
  end

  defp most_recent_first(query) do
    from a in query, order_by: [desc: a.date_started, desc: a.time_started]
  end

  def get_activity!(user, id) do
    Activity
    |> for_user(user)
    |> Repo.get!(id)
  end

  @doc """
  Creates a activity.

  ## Examples

      iex> create_activity(%{field: value})
      {:ok, %Activity{}}

      iex> create_activity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity(attrs \\ %{}) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a activity.

  ## Examples

      iex> update_activity(activity, %{field: new_value})
      {:ok, %Activity{}}

      iex> update_activity(activity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity(%Activity{} = activity, attrs) do
    activity
    |> Activity.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a activity.

  ## Examples

      iex> delete_activity(activity)
      {:ok, %Activity{}}

      iex> delete_activity(activity)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity(%Activity{} = activity) do
    Repo.delete(activity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity changes.

  ## Examples

      iex> change_activity(activity)
      %Ecto.Changeset{data: %Activity{}}

  """
  def change_activity(%Activity{} = activity, attrs \\ %{}) do
    Activity.changeset(activity, attrs)
  end

  def new_activity() do
    %Activity{}
  end

  def new_activity(%User{} = user) do
    %{new_activity() | user_id: user.id}
  end
end
