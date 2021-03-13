defmodule Openpay.Utils.ExtraValidations do
  @moduledoc """
  Changeset extra validations which help us to validate the common parts of the changeset.
  """
  import Ecto.Changeset

  def validate_length_in(changeset, key, values) when is_list(values) do
    size =
      changeset
      |> get_change(key, "")
      |> (fn value -> "#{value}" end).()
      |> String.length()

    if size in values do
      changeset
    else
      add_error(changeset, key, "invalid value for the length #{Enum.join(values, ",")}")
    end
  end
end
