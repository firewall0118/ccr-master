# Transparency JS helpers
module TransparencyHelper
  # Parenthesis because http://stackoverflow.com/a/2760992/1197775.
  def directive(key, value)
    "({\"#{key}\": function(){return '#{value}';}})"
  end
  alias_method :dir, :directive

  def href(value)
    dir 'href', value
  end

  def data(key, value)
    dir "data-#{key}", value
  end
end
