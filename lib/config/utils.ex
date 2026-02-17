defmodule Config.Utils do
  @moduledoc ~S"""
  A set of opinionated  utility functions to be used in configuration
  files.
  """

  import Config, only: [config_env: 0]

  @doc ~S"""
  Returns the compile-environment name.
  """
  @spec compile_env() :: :test | :dev | :remote

  def compile_env do
    with name when name not in [:test, :dev] <- config_env(),
         do: :remote
  end

  @doc ~S"""
  Returns the runtime-environment name.
  """
  @spec runtime_env() :: :test | :dev | :staging | :prod | atom

  def runtime_env, do: config_env()

  @doc ~S"""
  Returns the version defined in the Mix project.
  """
  @spec version() :: semver
        when semver: String.t()

  def version, do: Mix.Project.config()[:version]

  @doc ~S"""
  Retrieves an environment variable and casts its value to boolean.
  """
  @spec boolean(env_var, default | nil) :: boolean | default | nil
        when env_var: String.t(),
             default: boolean

  def boolean(env_var, default \\ nil)
      when is_nil(default)
      when is_boolean(default) do
    value =
      with nil <- nullify(System.get_env(env_var)),
           do: default

    cast(value, to: :boolean, env: env_var)
  end

  @doc ~S"""
  Retrieves an environment variable and casts its value to integer.
  """
  @spec int(env_var, default | nil) :: integer | default | nil
        when env_var: String.t(),
             default: integer

  def int(env_var, default \\ nil)
      when is_nil(default)
      when is_integer(default) do
    value =
      with nil <- nullify(System.get_env(env_var)),
          do: default

    cast(value, to: :integer, env: env_var)
  end

  @doc ~S"""
  Retrieves an environment variable.
  """
  @spec string(env_var, default | nil) :: String.t() | default | nil
        when env_var: String.t(),
             default: String.t()

  def string(env_var, default \\ nil)
      when is_nil(default)
      when is_binary(default),
      do: nullify(System.get_env(env_var)) || nullify(default)

  #
  #   PRIVATE
  #

  defp nullify(nil), do: nil
  defp nullify(""), do: nil
  defp nullify(value) when is_binary(value), do: with("" <- String.trim(value), do: nil)

  defp cast(nil, to: :boolean, env: _), do: false

  defp cast(value, to: :boolean, env: _)
       when is_boolean(value),
       do: value

  @truthy ["true", "1", "on", "yes", "enabled"]
  @falsy ["false", "0", "off", "no", "disabled"]
  @boolean_like @truthy ++ @falsy

  defp cast(value, to: :boolean, env: env_var) do
    value = String.downcase(value)

    case value in @boolean_like do
      true -> value in @truthy
      false -> raise(ArgumentError, "expected #{env_var} to be a boolean-like string, got #{inspect(value)}")
    end
  end

  defp cast(value, to: :integer, env: _)
       when is_integer(value),
       do: value

  defp cast(value, to: :integer, env: env_var) do
    String.to_integer(value, 10)
  rescue
    _ -> raise(ArgumentError, "expected #{env_var} to be an integer, got #{inspect(value)}")
  end
end
