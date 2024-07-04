let
  renderTable = value:
    assert builtins.isAttrs value;
    builtins.concatStringsSep "" (map
      (key: (renderKeyValue key value."${key}") + "\n")
      (builtins.attrNames value));

  renderKeyValue = key: value:
    if value == null then "" else "${renderKey key} = ${renderValue value}";

  renderKey = key:
    assert builtins.isString key;
    if builtins.match "[A-Za-z0-9_-]+" key != null then
      key
    else
      builtins.toJSON key;

  renderValue = value:
    if builtins.isList value then
      "[" +
      (builtins.concatStringsSep ", " (map renderValue value)) +
      "]"
    else if builtins.isAttrs value then
      "{" +
      (builtins.concatStringsSep ", " (map
        (key: renderKeyValue key value."${key}")
        (builtins.attrNames value))) +
      "}"
    else
      builtins.toJSON value;
in

{
  toTOML = renderTable;
}
