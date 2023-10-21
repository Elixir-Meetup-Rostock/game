defmodule GameWeb.UserRegistrationLive.Index do
  use GameWeb, :live_view

  alias Game.Accounts
  alias Game.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event(
        "save",
        %{"email" => email, "username" => username, "password" => password},
        socket
      ) do
    user_params = %{"email" => email, "username" => username, "password" => password}

    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)

        socket
        |> redirect(to: "/users/confirm")
        |> assign_form(changeset)
        |> reply(:noreply)

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign_form(changeset)}
    end
  end

  def handle_event(
        "validate",
        %{"email" => email, "username" => username, "password" => password},
        socket
      ) do
    user_params = %{"email" => email, "username" => username, "password" => password}

    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    # form = to_form(changeset, as: "user")

    IO.inspect(changeset)

    # if changeset.valid? do
    #   assign(socket, form: form, check_errors: false)
    # else
    #   assign(socket, form: form)
    # end
    socket
    |> assign(form: changeset)
  end
end
