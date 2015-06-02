module ConfigsHelper

  def hide_secret(string)
    '*' * string.length if string
  end
end
