defmodule Ueberauth.Strategy.Identity do
  use Ueberauth.Strategy, uid_field: :email,
                          email_field: :email,
                          name_field: :name,
                          first_name_field: :first_name,
                          last_name_field: :last_name,
                          nickname_field: :nickname,
                          phone_field: :phone,
                          location_field: :location,
                          description_field: :description,
                          password_field: :password,
                          password_confirmation_field: :password_confirmation,
                          param_nesting: nil

  alias Ueberauth.Auth.Info
  alias Ueberauth.Auth.Credentials
  alias Ueberauth.Auth.Extra

  def uid(conn) do
    param_for(conn, :uid_field)
  end

  def info(conn) do
    struct(
      Info,
      email: param_for(conn, :email_field),
      name: param_for(conn, :name_field),
      first_name: param_for(conn, :first_name_field),
      last_name: param_for(conn, :last_name_field),
      nickname: param_for(conn, :nickname_field),
      phone: param_for(conn, :phone_field),
      location: param_for(conn, :location_field),
      description: param_for(conn, :description_field)
    )
  end

  def credentials(conn) do
    struct(
      Credentials,
      other: %{
        password: param_for(conn, :password_field),
        password_confirmation: param_for(conn, :password_confirmation_field)
      }
    )
  end

  def extra(conn) do
    struct(Extra, raw_info: conn.params)
  end

  defp option(conn, name) do
    Dict.get(options(conn), name, Dict.get(default_options, name))
  end

  defp param_for(conn, name) do
    param_for(conn, name, option(conn, :param_nesting))
  end

  defp param_for(conn, name, nil) do
    Map.get(conn.params, to_string(option(conn, name)))
  end

  defp param_for(conn, name, nesting) do
    case Map.get(conn.params, to_string(nesting)) do
      nil -> nil
      nested -> Map.get(nested, to_string(option(conn, name)))
    end
  end
end
