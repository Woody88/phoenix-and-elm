defmodule PhoenixAndElm.LobbyChannel do
  use Phoenix.Channel
  alias PhoenixAndElm.{Contact, Repo}
  import Ecto.Query

  def join("lobby", _, socket), do: {:ok, socket}

  def handle_in("contacts", params, socket) do
    search = Map.get(params, "search") || ""

    page = Contact
      |> Contact.search(search)
      |> Ecto.Query.order_by(:first_name)
      |> Repo.paginate(params)

    {:reply, {:ok, Map.put(page, :search, search)}, socket}
  end

  def handle_in("contact:" <> contact_id, _, socket) do
    contact = Contact
    |> Repo.get(contact_id)

    case contact do
      nil ->
        {:reply, {:error, %{error: "Contact no found"}}, socket}
      _ ->
        {:reply, {:ok, %{contact: contact}}, socket}
    end
  end
end