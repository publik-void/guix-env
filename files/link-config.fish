set config_dir "$XDG_CONFIG_HOME/config-fish"

set --prepend fish_function_path "$config_dir/functions"
set --prepend fish_complete_path "$config_dir/completions"

if test -d "$config_dir/conf.d"
  for i in "$config_dir/conf.d/"*
    source $i
  end
end

if test -e "$config_dir/config.fish"
  source "$config_dir/config.fish"
end

set --export SHELL (type --force-path fish)
